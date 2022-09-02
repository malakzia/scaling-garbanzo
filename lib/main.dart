import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/extensions/firebase_options_dict.dart';
import 'package:my_app/extensions/string_ext.dart';
import 'package:my_app/importer.dart';
import 'package:my_app/widgets/forgot_password.dart';
import 'package:my_app/widgets/login_screen.dart';
import 'package:my_app/widgets/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';


void main()  {

  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(options: firebaseOptions);

  final String title = "Sign up";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        "/": (context) => SignUp(title: 'Authentication'),
        "/dashboard": (context, {p=0}) => DashboardScreen(),
        "/login": (context, {p=1}) => LoginScreen(),
        "/forgot-password": (context, {p=2}) => ForgotPasswordScreen(),
        
      },
      // home: const SignUp(title: 'Flutter Demo Home Page'),
    
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SignUp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignUp> {
  int _counter = 0;

   final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isSignupButtonEnabled = false;
  bool isPasswordFucosed = false;

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();  
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      
      body: Column(
        children: [
          Container(

             padding: const EdgeInsets.only(
                                    top: 30,
                                    bottom: 30,
                                    left: 30,
                                    right: 30,
                                  ),

                                  child: Image.asset("./web/images/logo.png"),

          ) ,  
          Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
           alignment: Alignment.center,
                      width: 500,
                      height:500,
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
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Signup',
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
                                      const SizedBox(height: 10),
                                      isPasswordFucosed == true ?  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("* Password should be min 7 character") ,
                                          Text("* Password should have one lowercase letter") ,
                                          Text("* Password should have one uppercase letter") ,
                                          Text("* Password should have one number") ,
                                          Text("")
                                        ],
                                      ) : const SizedBox(height: 10), 
                                      
                                      isLoading == true ? CircularProgressIndicator() : MElevatedButton(
                                        backgroundColor: Color.fromRGBO(
                                        228,
                                        230,
                                        235,
                                        1,
                                      ),
                                        title: 'Signup',
                                        onPressed: isSignupButtonEnabled
                                            ? _signupAction
                                            : null,
                                        isLoading: isLoading,
                                      ),
                                      const SizedBox(height: 36),
                                      returnRegisterBorderButton(),
                                      
                                    ],
                                  ),
        ),
        
      ),

        ],
      )  
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

    Future _signupAction() async {

        setState(() {
          isLoading  = true;
        });

        var email = _emailController.value.text;
        var password = _passwordController.value.text;

        FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toString(), password: password.toString()).whenComplete(() => {


              FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).whenComplete(() => {
              Nav.pushReplacement(
                  context,
                  screen: const LoginScreen(),
                  fullScreen: true,
                  name: '/login',
                  
                )
              })
              // go to dashboard if sign up successfull
              
        });

  }

    void _onPasswordChanged(String text) {
    setState(
      () {
        isPasswordFucosed = true;
        isPasswordValid = (text.isEmpty || !(text.length < 7)) && text.isPassword ;
        isSignupButtonEnabled =
            (isEmailValid && _emailController.text.trim().isNotEmpty) &&
                (isPasswordValid && _passwordController.text.isNotEmpty);

                
      },
    );
  }

    Widget returnRegisterBorderButton() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textSecondaryColor,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: 'Login',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Nav.push(
                  context,
                  screen: const LoginScreen(),
                  fullScreen: true,
                  name: '/login',
                  
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

    Widget returnPasswordTextFormField() {
    return MTextField(

      onTap: () => {
         setState(() {
            isPasswordFucosed = true;
          })
      },
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
        if (isSignupButtonEnabled) {
          _signupAction();
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

    void _onEmailChanged(String text) {
    setState(() {
       isPasswordFucosed = false;

      isEmailValid = text.isEmpty || (text.trim().isEmail == true);
      isSignupButtonEnabled =
          (isEmailValid && _emailController.text.trim().isNotEmpty) &&
              (isPasswordValid && _passwordController.text.isNotEmpty);
    });
  }

   Widget returnEmailTextFormField() {
    return MTextField(
      controller: _emailController,
      onTap: () =>{
         setState((){
          isPasswordFucosed = false;
         })
      },
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

}


