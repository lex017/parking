import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking/cash/receip.dart';

class btnLocation extends StatefulWidget {
  const btnLocation({super.key});

  @override
  State<btnLocation> createState() => _BtnLocationState();
}

class _BtnLocationState extends State<btnLocation> {
  int? selectedHours;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Section with Header Image and Go Back Button
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/header_image.jpg'), // Add your header image path
                    fit: BoxFit.cover,
                  ),
                  color: Colors.blue.shade100,
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20.0),

          // Bottom Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fetch and display one specific location
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Locations')
                        .doc('location1') // Replace with the document ID you want
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text(
                          "Error loading data",
                          style: TextStyle(color: Colors.red),
                        );
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text(
                          "No data available",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      final nameLocation = data['nameLocation'] ?? 'Unknown Name';
                      final description = data['description'] ?? 'No description available';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameLocation,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Hour Selection Dropdown
                  Row(
                    children: [
                      const Text(
                        "Select Hours: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: selectedHours,
                        hint: const Text("Choose"),
                        items: const [
                          DropdownMenuItem(
                            value: 2,
                            child: Text("2 Hours"),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text("4 Hours"),
                          ),
                          DropdownMenuItem(
                            value: 8,
                            child: Text("8 Hours"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedHours = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom Row with Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price Display
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            "${selectedHours != null ? selectedHours! * 15000 : 0} LAK",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton.icon(
                        onPressed: selectedHours == null
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (c) => BillPage()),
                                );
                              },
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        label: const Text(
                          "GO",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          backgroundColor: selectedHours == null
                              ? Colors.grey
                              : Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
