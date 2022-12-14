import '../widgets/animated_button.dart';
import '../widgets/custom_snackbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../services/authentication_service.dart';
import '../themes/text_styles.dart';
import '../widgets/custom_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  final AuthenticationService auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1e2c37),
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
                style: TextStyles.titleLarge,
              ),
              SizedBox(
                height: deviceHeight * 0.06,
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
              SizedBox(
                height: deviceHeight * 0.02,
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
              SizedBox(
                height: deviceHeight * 0.035,
              ),
              AnimatedButton(
                text: 'Login',
                buttonController: buttonController,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    buttonController.error();
                    return;
                  }

                  await auth
                      .loginUsingEmailAndPassword(
                    emailController.text,
                    passwordController.text,
                  )
                      .then(
                    (value) {
                      if (FirebaseAuth.instance.currentUser != null) {
                        buttonController.success();
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        buttonController.error();
                        CustomSnackBar(
                          text:
                              'User with this email and password doesn\'t exist',
                        ).showSnackbar(context);
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: deviceHeight * 0.06,
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
              SizedBox(
                height: deviceHeight * 0.15,
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
