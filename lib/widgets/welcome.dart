/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: use_build_context_synchronously, unawaited_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/extensions/string_ext.dart';
import 'package:my_app/importer.dart';
import 'package:my_app/widgets/login_screen.dart';

import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    Key? key,
    this.completion,
  }) : super(key: key);

  final Function()? completion;
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {


  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (ctx) => Center(
              child: Container(alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
               
                 MaterialButton(
                    minWidth: 100.0,
                    height: 35,
                    
                    color: Color(0xFF801E48),
                    child: new Text('Welcome',
                        style: new TextStyle(fontSize: 46.0, color: Colors.white)),
                    onPressed: () {

                        FirebaseAuth.instance.signOut().whenComplete(() => {
                               Nav.pushReplacement(
                            context,
                            screen: const LoginScreen(),
                            fullScreen: true,
                            name: '/login',
                            
                          )
                        });

                    },
                  ),
                ],
              ),
              )
            ),
          ),
        ),
      );
    
  }

}
