/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: use_build_context_synchronously, unawaited_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/extensions/string_ext.dart';
import 'package:my_app/importer.dart';
import 'package:my_app/widgets/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/widgets/profile.dart';
import 'package:my_app/widgets/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import '../constants.dart';
import '../extensions/firebase_options_dict.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
    this.completion,
  }) : super(key: key);

  final Function()? completion;
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
      
String CurrentUser = "";

  List<Widget> tabs = [ 
    WelcomeScreen(),
    ProfileScreen(),
    Text("Settings")
    
  ];
  var tabSelected = 1;
  String uid = "abc";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setLoggedInUser();
    Firebase.initializeApp(options: firebaseOptions,).whenComplete(() { 
      print("completed");
      
    });
  }

  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (ctx) => 
               Container(
              
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                
                children: [
                Expanded(flex: 1,
                child:Container(
                  alignment: Alignment.topLeft,
                  color: Color.fromARGB(200,186,57,142),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                       MaterialButton(
                        onPressed:()=>{

                           setState(() {            
                                  tabSelected = 1;
                            })
                            
                        } ,
                        child:   Container(
                       padding: const EdgeInsets.fromLTRB(0,05,0,05),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                        children: 
                        [

                       CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        child: Text(CurrentUser[0].toUpperCase()),
                       ),  
                       Text(CurrentUser,style: TextStyle(color: Color.fromARGB(255, 236, 224, 236)),),
                       FaIcon(
                              Icons.arrow_right_sharp,
                              size: 30,
                              color: Colors.white,
                            ),

                        ]),
                       ),  
                        ) ,


                       MaterialButton(
                        onPressed:()=>{

                           setState(() {            
                                  tabSelected = 1;
                            })
                            
                        } ,
                        child:   Container(
                       padding: const EdgeInsets.fromLTRB(0,05,0,05),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                        children: 
                        [
                          
                       Text("Welcome",style: TextStyle(color: Colors.white),),
                       FaIcon(
                              Icons.arrow_right_sharp,
                              size: 30,
                              color: Colors.white,
                            ),

                        ]),
                       ),  
                        ) ,


                      Container(
                        color:Colors.white,
                        height: 01,
                      ),

                       MaterialButton(
                        onPressed:()=>{
                             setState(() {            
                                  tabSelected = 2;
                            })
                        } ,
                        child:   Container(
                       padding: const EdgeInsets.fromLTRB(0,05,0,05),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                        children: 
                        [
                       Text("Profile",style: TextStyle(color: Colors.white),),
                       FaIcon(
                              Icons.arrow_right_sharp,
                              size: 30,
                              color: Colors.white,
                            ),

                        ]),
                       ),  
                        ) ,


                      Container(
                        color:Colors.white,
                        height: 01,
                      ),


                        MaterialButton(
                        onPressed:()=>{
                             setState(() {            
                                  tabSelected = 3;
                            })
                        } ,
                        child:   Container(
                       padding: const EdgeInsets.fromLTRB(0,05,0,05),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                        children: 
                        [
                       Text("Settings",style: TextStyle(color: Colors.white),),
                       FaIcon(
                              Icons.arrow_right_sharp,
                              size: 30,
                              color: Colors.white,
                            ),

                        ]),
                       ),  
                        ) ,


                      Container(
                        color:Colors.white,
                        height: 01,
                      ),

                      MaterialButton(
                        onPressed:()=>{
                              FirebaseAuth.instance.signOut().whenComplete(() => {
                               Nav.pushReplacement(
                               context,
                               screen: const LoginScreen(),
                               fullScreen: true,
                               name: '/login',
                                
                          )
                        })
                        } ,
                        child:   Container(
                       padding: const EdgeInsets.fromLTRB(0,05,0,05),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                        children: 
                        [
                       Text("Logout",style: TextStyle(color: Colors.white),),
                       FaIcon(
                              Icons.arrow_right_sharp,
                              size: 30,
                              color: Colors.white,
                            ),

                        ]),
                       ),  
                        ) ,

                    
                      Container(
                        color:Colors.white,
                        height: 01,
                      ),

                  ]),
                ) 
                ),
                Expanded(flex: 4,
                child: Container(
                  color: Colors.white,
                  child: tabs[tabSelected-1]
                  
                )
                ),
                
              ]),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [


               
              //    MaterialButton(
              //       minWidth: 100.0,
              //       height: 35,
                    
              //       color: Color(0xFF801E48),
              //       child: new Text(uid == null ? 'no user' : uid,
              //           style: new TextStyle(fontSize: 16.0, color: Colors.white)),
              //       onPressed: () {

              //           FirebaseAuth.instance.signOut().whenComplete(() => {
              //                  Nav.pushReplacement(
              //               context,
              //               screen: const LoginScreen(),
              //               fullScreen: true,
              //               name: '/login',
                            
              //             )
              //           });

              //       },
              //     ),
               
              //   ],
              // ),
              )
            
          ),
        ),
      );
    
  }
  
  void setLoggedInUser() async 
  {
    
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    
    setState(() {
      CurrentUser = prefs.getString("name")!;
    });
  }

}
