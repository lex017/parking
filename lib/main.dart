import 'package:flutter/material.dart';
import 'package:parking/loginandregis/firstpage.dart';
import 'package:parking/loginandregis/loginPage.dart';


void main(){
  runApp(parking());
}

class parking extends StatelessWidget {
  const parking({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 22.0,

          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
            size: 33.0
          )
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(fontSize: 25,color: Colors.white),
          unselectedLabelStyle: TextStyle(fontSize: 14,color: Colors.white),
        )
      ),

      home: firstpage()
    );
  }
}