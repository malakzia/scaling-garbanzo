/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: use_build_context_synchronously, unawaited_futures, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/extensions/string_ext.dart';
import 'package:my_app/importer.dart';
import 'package:my_app/widgets/login_screen.dart';
import 'package:my_app/importer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    this.completion,
  }) : super(key: key);

  final Function()? completion;
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {

final database  = FirebaseDatabase.instance.reference();
  final _emailController = TextEditingController();
final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();

  bool isEmailValid = true;
  bool isFirstNameValid = true;
  bool isLastNameValid = true;

  
  bool isLoginButtonEnabled = false;
  bool isPasswordValid = false;
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;
  bool isPasswordFucosed = false;
  String currentUserEmail = '';
  String currentUserFirsName = '';
  String currentUserLastName = '';
  
  bool isUpdateButtonEnabled = false;
  String ErrorMessage = "";
  bool isError = false;
  bool isSuccess = false;
  
  String SuccessMessage= "";



  PlatformFile? objFile = null;

  void chooseFileUsingFilePicker() async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
      });
    }
  }

  void uploadSelectedFile() async {
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {


      // var snapshot=database.child("/Users").child(FirebaseAuth.instance.currentUser!.uid).listen((event) 
      // {
      //     if(event.snapshot.exists)
      //     {
      //       final data = new Map<String , dynamic>.from(event.snapshot.value as dynamic);
      //       currentUserFirsName = data['firstname'] as String;
      //       // currentUserLastName= data['lastname'] as String;
            
      //     }
      //  });
      getCurrentUser();
     
    });
  }

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text("Profile",style: TextStyle(fontSize: 50),),  

                isError ? Container(padding: const EdgeInsets.all(20),color:Colors.red,child: Text(ErrorMessage ,style: TextStyle(color: Colors.white)),) : SizedBox(height: 0),
                isSuccess ? Container(padding: const EdgeInsets.all(20),color:Colors.green,child: Text(SuccessMessage,style: TextStyle(color: Colors.white),),) : SizedBox(height: 0),

              RaisedButton(
                    child: Text('UPLOAD FILE'),
                    onPressed: (() => chooseFileUsingFilePicker()),
                  ),
                 SizedBox(
                  height: 100,
                 ), 
                 
                 returnFirstNameTextFormField(),
                 SizedBox(
                  height: 10,
                 ),
                 returnLastNameTextFormField(),
                 SizedBox(
                  height: 10,
                 ),
                 returnEmailTextFormField(),
                 SizedBox(
                  height: 10,
                 ),
                 returnPasswordTextFormField(),

                 isPasswordFucosed == true ?  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("* Password should be min 7 character") ,
                    Text("* Password should have one lowercase letter") ,
                    Text("* Password should have one uppercase letter") ,
                    Text("* Password should have one number") ,
                    Text("")
                  ],
                ) : const SizedBox(height: 0), 
               
                 const SizedBox(height: 30),
                  isLoading == true ? CircularProgressIndicator() : MElevatedButton(
                    title: 'Update',
                    onPressed:  _updateEmailPassword,
                    isLoading: isLoading,
                  ),
                ],
              ),
              )
            ),
          ),
        ),
      );
    
  }

    Future _updateEmailPassword() async {
        
        print((isEmailValid));
         setState(() {
          isError  = false;
          isLoading  = true;
        });

        String email = _emailController.value.text.toString();
        String password = _passwordController.value.text.toString();
        String firstname = _firstNameController.value.text.toString();
        String lastname = _lastNameController.value.text.toString();
        
        

        // checking the validations of all the fields
        if(!isFirstNameValid)
        {
          setState(() {
           isError  = true;
           ErrorMessage = "First Name is invalid";
          });
           
        }

        if(!isLastNameValid)
        {
          setState(() {
           isError  = true;
           ErrorMessage = "Last Name is invalid";
          });
           
        }


        if(!isEmailValid)
        {
          setState(() {
           isError  = true;
           ErrorMessage = "Email is invalid";
          });
           
        }

        if(password.isNotEmpty)
        {
          if(!isPasswordValid)
          {
            setState(() {
            isError  = true;
            ErrorMessage = "Password is invalid";
            });

          }          
        }
        else 
        {
          isPasswordValid = false;
        }
        
  
        if(!isError)
        {
          // adding first name to firebase realtime database
          Map<String , String> data ={
            "firstname" : firstname,
            "lastname" : lastname,
          };

          // ignore: deprecated_member_use
          
          database.child("/Users").child(FirebaseAuth.instance.currentUser!.uid).set(data).then((value) => {           

              success()

          }).catchError((data){
            
            failure(data);

          });

          FirebaseAuth.instance.currentUser!.updateEmail(email).then((value) => {           
            print("email is valid"),  
            setState(() {
               currentUserEmail = email;
            }),
            success(),

             if(isPasswordValid)
            {
              print("password is valid"),
              FirebaseAuth.instance.currentUser!.updatePassword(password).then((value) => {           
                  success()

              }).catchError((data){
                  
                  failure(data);

              })
            }

        }).catchError((data){
            failure(data);

        });


        }
        else 
        {
           setState(() {
          isLoading  = false;
        });
        }
        
  }

  success()
  {
          setState(() {
               isSuccess= true;
               isError = false;
               SuccessMessage = "Updated Successfully";
               isLoading  = false;
               
            });
  }

  failure(data)
  {
          isError = true;
                isSuccess= false;
                ErrorMessage = data.toString();
                isLoading  = false;
  }

     Widget returnLastNameTextFormField() {
    return MTextField(
      controller: _lastNameController,
      showIcon: false,
      check: isLastNameValid,
      
      helperText: 'abc',
      
      labelText: 'abc',
      type: TextInputType.name,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      onChanged: _onLastNameChanged,
      backgroundColor: Colors.white.withOpacity(0.6),
      hint: 'Last Name',
    );
  }

   Widget returnFirstNameTextFormField() {
    return MTextField(
      controller: _firstNameController,
      showIcon: false,
      check: isFirstNameValid,
      
      helperText: 'abc',
      
      labelText: 'abc',
      type: TextInputType.name,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      onChanged: _onFirstNameChanged,
      backgroundColor: Colors.white.withOpacity(0.6),
      hint: 'First Name',
    );
  }

    Widget returnEmailTextFormField() {
    return MTextField(
      controller: _emailController,
      showIcon: false,
      check: isEmailValid,
      
      helperText: 'abc',
      
      labelText: 'abc',
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      onChanged: _onEmailChanged,
      backgroundColor: Colors.white.withOpacity(0.6),
      hint: 'Email',
    );
  }

    void _onPasswordChanged(String text) {
    setState(
      () {

        isPasswordFucosed = true;
        isPasswordValid = (text.isEmpty || !(text.length < 7)) && text.isPassword ;
        isUpdateButtonEnabled =
            (isEmailValid && _emailController.text.trim().isNotEmpty) &&
                (isPasswordValid && _passwordController.text.isNotEmpty);
 
      },
      
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
      isLoginButtonEnabled =
          (isEmailValid && _emailController.text.trim().isNotEmpty) &&
              (isPasswordValid && _passwordController.text.isNotEmpty);
    });
  }

  void _onFirstNameChanged(String text) {
    
    setState(() {
      isFirstNameValid= text.isNotEmpty && (text.trim().isName == true);
      
  });
  }

  void _onLastNameChanged(String text) {
    
    setState(() {

      isLastNameValid = text.isNotEmpty && (text.trim().isName == true);
  });
  }
  
  Future<void> getCurrentUser() 
  async {
       SharedPreferences _prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    
    setState(() {
      _firstNameController.text = prefs.getString("name")!;
      _lastNameController.text = prefs.getString("name")!;
      _emailController.text = prefs.getString("name")!;
    });
  }
  


}




