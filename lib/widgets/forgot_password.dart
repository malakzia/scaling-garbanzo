/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: use_build_context_synchronously, unawaited_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/extensions/string_ext.dart';
import 'package:my_app/importer.dart';

import '../constants.dart';
import 'dashboard_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
    this.completion,
  }) : super(key: key);

  final Function()? completion;
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isLoginButtonEnabled = false;
  bool isResetPasswordEmailSent = false;
  bool noUserFound = false;


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
        body: GestureDetector(
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
                                      isResetPasswordEmailSent == true ? Text("Reset Password Email sent to email" , style: TextStyle(
                                       color: Colors.green
                                      ),) : Text('') ,


                                      noUserFound == true ? Text("No user found against this email" , style: TextStyle(
                                       color: Colors.red
                                      ),) : Text('') ,


                                      const Text(
                                        'Reset Password',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: textColor,
                                          fontSize: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      returnEmailTextFormField(),

                                      const SizedBox(height: 30),
                                     isLoading == true ? CircularProgressIndicator() : MElevatedButton(
                                        title: 'Send Email',
                                        onPressed: isLoginButtonEnabled
                                            ? _forgotPasswordAction
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




  void _onEmailChanged(String text) {
    setState(() {
      isEmailValid = text.isEmpty || (text.trim().isEmail == true);
      isLoginButtonEnabled =
          (isEmailValid && _emailController.text.trim().isNotEmpty);
    });
  }

  Future _forgotPasswordAction() async {
        
         setState(() {
          isLoading  = true;
        });

        String email = _emailController.value.text.toString();
        FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => {

             setState(() {
              isLoading  = false;
              noUserFound = false;
              isResetPasswordEmailSent = true;
            })

        }).onError((error, stackTrace) => {
            setState(() {

              isLoading  = false;
              noUserFound = true;
              isResetPasswordEmailSent = false;

            })
        });

        // FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) => {

        //     Nav.pushReplacement(
        //           context,
        //           screen: const DashboardScreen(),
        //           fullScreen: true,
        //           name: '/dashboard',
                  
        //         )

        // }).catchError((data){
            
        //     setState(() {
        //       isLoggedIn = false;
        //        isLoading  = false;
        //     });

        // });
        
  }


}
/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: use_build_context_synchronously, unawaited_futures
