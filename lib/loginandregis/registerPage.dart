import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:parking/loginandregis/loginPage.dart';
import 'package:parking/model/userdata.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obs = true;

  void showMessage() {
    setState(() {
      obs = !obs;
    });
  }

  final formkey = GlobalKey<FormState>();

  static const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyCDkvYdEQX2HTTavA-juAvROFaRn2jc1HQ",
    authDomain: "your-auth-domain",
    projectId: "parkingapp-47d6d",
    storageBucket: "your-storage-bucket",
    messagingSenderId: "77735745622",
    appId: "1:77735745622:android:db7edf8465d5299f47c3f7",
    measurementId: "your-measurement-id",
  );

  Userparking myUser = Userparking();

  Widget showText() {
    return Text(
      "Sign up",
      style: TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
        fontFamily: 'Lobster',
      ),
    );
  }

  Widget showText1() {
    return Text(
      "Create a new account",
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Lobster',
      ),
    );
  }

  Widget userInput() {
  return SizedBox(
    width: 350,
    child: TextFormField(
      onSaved: (String? username) {
        myUser.username = username ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Username',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black,
          size: 35.0,
        ),
      ),
    ),
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
        filled: true,
        fillColor: Colors.white,
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
        filled: true,
        fillColor: Colors.white,
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

Widget passconfilm() {
  return SizedBox(
    width: 350,
    child: TextFormField(
      obscureText: obs,
      onSaved: (String? passconfilm) {
        myUser.passconfilm = passconfilm ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Confirm Password',
        filled: true,
        fillColor: Colors.white,
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


  // Sign Up button
  Widget sigupButton() {
    return SizedBox(
      width: 350,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (formkey.currentState?.validate() ?? false) {
            formkey.currentState?.save();

            // Validate password confirmation
            if (myUser.Pass != myUser.passconfilm) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Passwords do not match!')),
              );
              return;
            }

            try {
              // Register the user with Firebase Authentication
              final userCredential =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: myUser.email,
                password: myUser.Pass,
              );

              // Save username to Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userCredential.user?.uid)
                  .set({
                'username': myUser.username,
                'email': myUser.email,
                'password': myUser.Pass
              });

              // Reset form and navigate to login page
              formkey.currentState?.reset();
              myUser = Userparking();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User created successfully!')),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const loginPage()),
              );
            } on FirebaseAuthException catch (e) {
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
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An unexpected error occurred.')),
              );
            }
          }
        },
        child: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget login() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => const loginPage()),
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
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30.0),
                              showText(),
                              const SizedBox(height: 10.0),
                              showText1(),
                            ],
                          ),
                        ),
                        Center(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(
                              height: 40.0,
                            ),
                            userInput(),
                            const SizedBox(
                              height: 40.0,
                            ),
                            emailInput(),
                            const SizedBox(
                              height: 40.0,
                            ),
                            passwordInput(),
                            const SizedBox(
                              height: 40.0,
                            ),
                            passconfilm(),
                            const SizedBox(
                              height: 50.0,
                            ),
                            sigupButton(),
                            login(),
                          ]),
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
