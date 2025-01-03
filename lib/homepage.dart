import 'package:flutter/material.dart';
import 'package:parking/bottombar/chatPage.dart';
import 'package:parking/bottombar/historyPage.dart';

import 'package:parking/bottombar/maingPage.dart';
import 'package:parking/bottombar/profilePage.dart';
import 'package:parking/drawer.dart';



const List screenPage=[
  mainPage(),
  ChatPage(),
  HistoryPage(),
  ProfilePage()

];
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking app'),
      ),
      
      
      

      body: mainPage(),
      drawer: const drawer_menu(),
    );
  }
}