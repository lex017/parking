import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:parking/homepage.dart';
import 'package:parking/loginandregis/registerPage.dart';
import 'package:parking/model/userdata.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool obs = true;
  void showMessage() {
    setState(() {
      obs = !obs;
    });
  }
  
   final formkey = GlobalKey<FormState>();
   Userparking myUser = Userparking();


  static const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyCDkvYdEQX2HTTavA-juAvROFaRn2jc1HQ",
    authDomain: "your-auth-domain",
    projectId: "parkingapp-47d6d",
    storageBucket: "your-storage-bucket",
    messagingSenderId: "77735745622",
    appId: "1:77735745622:android:db7edf8465d5299f47c3f7",
    measurementId: "your-measurement-id",
  );
   
  

  Widget loginDisplay() {
    return SizedBox(
      width: 160,
      height: 160,

          child: Image.asset("images/p_logo1.png",
          ),
        
      
    );
  }

  Widget showText() {
    return Text(
      "LOGIN",
      style: TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
          fontFamily: 'Lobster'),
    );
  }
   Widget showText1() {
    return Text(
      "Welcome to my app",
      style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Lobster'),
    );
  }

 Widget emailInput() {
  return SizedBox(
    width: 350,
    child: TextFormField(
      onSaved: (String? email) {
        myUser.email = email ?? '';
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Please enter an email"),
        EmailValidator(errorText: "Please enter a valid email")
      ]),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),  
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.black), 
        filled: true,
        fillColor: Colors.transparent,  
        prefixIcon: Icon(
          Icons.email,
          color: Colors.black,
          size: 35.0,
        ),
      ),
    ),
  );
}


 Widget passwordInput() {
  return SizedBox(
    width: 350,
    child: TextFormField(
      obscureText: obs,  
      onSaved: (String? pass) {
        myUser.Pass = pass ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),  
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.black), 
        filled: true,
        fillColor: Colors.transparent,  
        prefixIcon: Icon(
          Icons.key,
          color: Colors.black,
          size: 35.0,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            showMessage();
          },
          icon: const Icon(Icons.visibility),
        ),
      ),
    ),
  );
}


  Widget LoginButton() {
    return SizedBox(
      width: 350,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
           if (formkey.currentState?.validate() ?? false){
            formkey.currentState?.save();
            try{
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: myUser.email, 
                password: myUser.Pass
                ).then((value){
                  formkey.currentState?.reset();
                  Navigator.of(context).pop();
                  MaterialPageRoute route =MaterialPageRoute(builder: (c)=>Homepage());
                  Navigator.of(context).push(route);
                });
            }on FirebaseAuthException catch(e){
              String errorMessage = 'Something went wrong!';

            if (e.code == 'email-already-in-use') {
              errorMessage = 'This email is already in use.';
            } else if (e.code == 'weak-password') {
              errorMessage = 'The password is too weak.';
            } else if (e.code == 'invalid-email') {
              errorMessage = 'The email address is invalid.';
            }

           
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );

           
            print('FirebaseAuthException: ${e.message}');
          } catch (e) {
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An unexpected error occurred.')),
            );
            print('Unexpected error: $e');
            }
           }
        },
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      ),
    );
  }


  Widget signUp() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center, 
    children: [
      Text(
        "Register",
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const RegisterPage()),
          );
        },
        child: Text(
          "Click here",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ],
  );
}


 @override
Widget build(BuildContext context) {
  return FutureBuilder<FirebaseApp>(
    future: Firebase.initializeApp(options: firebaseConfig),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          appBar: AppBar(title: Text("Error1")),
          body: Center(
            child: Text("${snapshot.error}"),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return Scaffold(
          body: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30.0),
                          showText(),
                          const SizedBox(height: 10.0),
                          showText1(),
                          
                        ],
                      ),),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          const SizedBox(height: 100.0),
                          emailInput(),
                          const SizedBox(height: 50.0),
                          passwordInput(),
                          const SizedBox(height: 60.0),
                          LoginButton(),
                          const SizedBox(height: 20.0),
                          signUp(),
                          
                        ]
                        ),
                      )
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(title: Text("Error2")),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}

}
