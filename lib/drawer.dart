import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:parking/chose/Owner.dart';
import 'package:parking/constant/CloudinaryUploader.dart';
import 'package:parking/constant/getImageClound.dart';
import 'dart:convert';

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
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  String cloudinaryUrl = 'YOUR_CLOUDINARY_UPLOAD_URL'; // Replace with Cloudinary Upload URL
  String cloudinaryPreset = 'YOUR_UPLOAD_PRESET'; // Replace with your Cloudinary Upload Preset

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        await _uploadToCloudinaryAndSave();
      }
    } catch (e) {
      print("Error picking profile image: $e");
    }
  }

  Future<void> _uploadToCloudinaryAndSave() async {
    if (_profileImage == null) return;

    try {
      // Upload image to Cloudinary
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _profileImage!.path,
      ));
      request.fields['parking'] = cloudinaryPreset;

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);

        final imageUrl = data['secure_url'];
        print("Uploaded Image URL: $imageUrl");

        // Save the URL to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .update({'profileImage': imageUrl});

        setState(() {
          _profileImage = null; // Clear the local image after upload
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        print("Error uploading to Cloudinary: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

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
                  .doc(auth.currentUser?.uid)
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

                final data = snapshot.data!.data() as Map<String, dynamic>;
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
            currentAccountPicture: GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: _profileImage != null
                      ? Image.file(
                          _profileImage!,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        )
                      : FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(auth.currentUser?.uid)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                !snapshot.data!.exists) {
                              return Image.asset(
                                'images/profile-user.png',
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              );
                            }

                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final profileImage =
                                data['profileImage'] ?? 'images/profile-user.png';

                            return Image.network(
                              profileImage,
                              fit: BoxFit.cover,
                              width: 90,
                              height: 90,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'images/profile-user.png',
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                            );
                          },
                        ),
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
                  fontFamily: 'Roboto',
                ),
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
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => LocationPage());
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
                  fontFamily: 'Roboto',
                ),
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
                  fontFamily: 'Roboto',
                ),
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
                  fontFamily: 'Roboto',
                ),
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
                  fontFamily: 'Roboto',
                ),
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
                  fontFamily: 'Roboto',
                ),
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
                  fontFamily: 'Roboto',
                ),
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
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => Help());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'upload',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => CloudinaryUploader());
                Navigator.of(context).push(route);
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text(
                'showimage',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (c) => GetImage());
                Navigator.of(context).push(route);
              },
            ),
          ),
        ],
      ),
    );
  }
}
