
/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: use_build_context_synchronously, unawaited_futures

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/extensions/string_ext.dart';
import 'package:my_app/importer.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'dashboard_screen.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    this.completion,
  }) : super(key: key);

  final Function()? completion;
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    var dio = Dio();
      late Response response ;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isLoginButtonEnabled = false;

  bool isPasswordVisible = false;
  bool isLoading = false;
  bool  isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [

           Container(

             padding: const EdgeInsets.only(
                                    top: 30,
                                    bottom: 30,
                                    left: 30,
                                    right: 30,
                                  ),

                                  child: Image.asset("../web/images/logo.png"),

          ) ,

          GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (ctx) => Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Align(
                    child: Container(
                      alignment: Alignment.center,
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const SizedBox(height: 30),
                               
                                const SizedBox(height: 30),
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                    bottom: 30,
                                    left: 30,
                                    right: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                        228,
                                        230,
                                        235,
                                        1,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      isLoggedIn == false ? Text("Invalid username or password" , style: TextStyle(
                                       color: Colors.red
                                      ),) : Text('') ,
                                      const Text(
                                        'Login',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: textColor,
                                          fontSize: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      returnEmailTextFormField(),
                                      const SizedBox(height: 24),
                                      returnPasswordTextFormField(),
                                      const SizedBox(height: 6),
                                      returnForgotPasswordButton(),
                                      const SizedBox(height: 30),
                                     isLoading == true ? CircularProgressIndicator() : MElevatedButton(
                                        title: 'LOGIN',
                                        onPressed: isLoginButtonEnabled
                                            ? _signInAction
                                            : null,
                                        isLoading: isLoading,
                                      ),
                                      const SizedBox(height: 36),
                                      returnRegisterBorderButton(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 130 +
                                      MediaQuery.of(context).viewPadding.bottom,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ],)
      ),
    );
  }

  Widget returnRegisterBorderButton() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: "Don't you have an account? ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textSecondaryColor,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: 'Register',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Nav.push(
                  context,
                  screen: const SignUp(title: 'Sign Up',),
                  fullScreen: true,
                  name: '/registration',
                );
              },
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget returnForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: _forgotPasswordAction,
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            'Forgot password?',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: textColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget returnEmailTextFormField() {
    return MTextField(
      controller: _emailController,
      showIcon: false,
      check: isEmailValid,
      
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      onChanged: _onEmailChanged,
      backgroundColor: Colors.white.withOpacity(0.6),
      hint: 'Email',
    );
  }

  Widget returnPasswordTextFormField() {
    return MTextField(
      controller: _passwordController,
      obscureText: !isPasswordVisible,
      showIcon: false,
      type: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      onChanged: _onPasswordChanged,
      textInputAction: TextInputAction.done,
      check: isPasswordValid,
      backgroundColor: Colors.white.withOpacity(0.6),
      onSubmitted: (v) {
        if (isLoginButtonEnabled) {
          _signInAction();
        }
      },
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
        child: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          size: 22,
          color: textSecondaryColor,
        ),
      ),
      hint: 'Password',
    );
  }

  void _onPasswordChanged(String text) {
    setState(
      () {
        isPasswordValid = text.isEmpty || !(text.length < 5);
        isLoginButtonEnabled =
            (isEmailValid && _emailController.text.trim().isNotEmpty) &&
                (isPasswordValid && _passwordController.text.isNotEmpty);
      },
    );
  }

  void _onEmailChanged(String text) {
    setState(() {
      isEmailValid = text.isEmpty || (text.trim().isEmail == true);
      isLoginButtonEnabled =
          (isEmailValid && _emailController.text.trim().isNotEmpty) &&
              (isPasswordValid && _passwordController.text.isNotEmpty);
    });
  }

  Future _signInAction() async {
        
         setState(() {
          isLoading  = true;
        });

        String email = _emailController.value.text.toString();
        String password = _passwordController.value.text.toString();
        authenticate(email, password);

  }

          // final SharedPreferences prefs = await _prefs;
            void authenticate(String email , String password) async {
                  final SharedPreferences prefs = await _prefs;

            // This example uses the Google Books API to search for books about http.
            // https://developers.google.com/books/docs/overview

              try {
                
                dio.options.headers["Access-Control-Allow-Origin"] = "*";
                dio.options.headers["Access-Control-Allow-Credentials"] = true;
                dio.options.headers["Access-Control-Allow-Headers"] = "*";
                dio.options.headers["Access-Control-Allow-Methods"] = "*";
                
                response = await dio.post(BASE_URL+LOGIN_URL
                
                , data: {'login_id': email, 'password': password}).whenComplete(() => {
                    
                });
                if(response.statusCode == 200)
                {
                   prefs.setString("name",email) ;
                   Nav.pushReplacement(
                    context,
                    screen: const DashboardScreen(),
                    fullScreen: true,
                    name: '/dashboard',
                    
                  );   
                               
                }
              } catch (error) {
                print(error.toString());
                // Catch and throw your exceptions
              }

            }

  void _forgotPasswordAction() {
     Nav.pushReplacement(
                  context,
                  screen: const ForgotPasswordScreen(),
                  fullScreen: true,
                  name: '/forgot-password',
                  
                );
    
  }
}
