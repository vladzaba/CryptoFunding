import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:crypto_funding_app/services/authentication_service.dart';
import 'package:crypto_funding_app/widgets/custom_form_field.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final AuthenticationService auth = AuthenticationService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1e2c37),
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1e2c37),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomFormField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.account_circle_rounded,
                textInputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email field is empty';
                  } else if (!isEmail(value)) {
                    return 'Please provide a correct email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().length <= 7) {
                    return 'Password length should be atleast 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ArgonButton(
                height: 50,
                width: 350,
                borderRadius: 5.0,
                color: const Color(0xFF59b7b9),
                loader: Container(
                  padding: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                onTap: (startLoading, stopLoading, btnState) async {
                  if (btnState == ButtonState.Idle) {
                    startLoading();

                    if (!formKey.currentState!.validate()) {
                      stopLoading();
                      return;
                    }

                    await auth
                        .loginUsingEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                    )
                        .then(
                      (value) {
                        stopLoading();
                        if (FirebaseAuth.instance.currentUser != null) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          Flushbar(
                            flushbarPosition: FlushbarPosition.TOP,
                            backgroundColor:
                                const Color(0xff263742),
                            messageText: const Center(
                                child: Text(
                              'User with this email and password doesn\'t exist',
                              style: TextStyle(color: Colors.white),
                            )),
                            duration: const Duration(seconds: 2),
                          ).show(context);
                        }
                      },
                    );
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/register');
                },
                child: const Text(
                  "Don't have an account? \nSign Up",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 140,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
}
