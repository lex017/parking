import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/chose/Owner.dart';
import 'package:parking/data_save/position.dart';
import 'package:parking/homepage.dart';
import 'package:parking/map_api/LocationPage.dart';
import 'package:parking/menu/Help.dart';
import 'package:parking/menu/Wallet.dart';
import 'package:parking/menu/employeescan.dart';

import 'package:parking/menu/history.dart';

class drawer_menu extends StatefulWidget {
  const drawer_menu({super.key});

  @override
  State<drawer_menu> createState() => _drawer_menuState();
}

class _drawer_menuState extends State<drawer_menu> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(),
            accountName: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users') 
                  .doc(auth
                      .currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!.exists) {
                  return const Text(
                    'No Name Found',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                final data = snapshot.data!;
                return Text(
                  data['username'] ?? 'No Name Found',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            accountEmail: Text(
              auth.currentUser?.email ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: ClipOval(
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'Home',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => Homepage());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'Location',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =MaterialPageRoute(builder: (c)=>LocationPage());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'History',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => history());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'My Ticket',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'Wallet',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => Wallet());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'EmployeeScan',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => EmployeeScan());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'Setting',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'Owner',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => Owner());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'Help',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => Help());
                Navigator.of(context).push(route);
              },
            ),
          ),
        ],
      ),
    );
  }
}
