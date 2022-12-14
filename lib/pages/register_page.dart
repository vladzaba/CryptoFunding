import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../services/authentication_service.dart';
import '../themes/text_styles.dart';
import '../widgets/animated_button.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

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
                'Sign up',
                textAlign: TextAlign.center,
                style: TextStyles.titleLarge,
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
              CustomFormField(
                controller: repeatPasswordController,
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (passwordController.text !=
                      repeatPasswordController.text) {
                    return 'Please make sure your passwords match';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: deviceHeight * 0.035,
              ),
              AnimatedButton(
                text: 'Sign Up',
                buttonController: buttonController,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    buttonController.error();
                    return;
                  }

                  await auth
                      .registerUserUsingEmailAndPassword(
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
                          text: 'User with email already exist',
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
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text(
                  'Already have an account? \nLogin',
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
