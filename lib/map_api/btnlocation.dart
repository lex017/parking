import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking/cash/QrPay.dart';
import 'package:parking/map_api/LocationPage.dart';

class btnLocation extends StatefulWidget {
  final String documentId;

  const btnLocation({required this.documentId, super.key});

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
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Locations')
                .doc(widget.documentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: Text(
                      "Error loading image",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: Text(
                      "No image available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final imageUrl = data['imageUrl'] ?? '';

              return Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Text("Failed to load image"),
                            ),
                          )
                        : const Center(
                            child: Text("No image available"),
                          ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.of(context).pop();
                        MaterialPageRoute route =
                            MaterialPageRoute(builder: (c) => LocationPage());
                        Navigator.of(context).push(route);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20.0),
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
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Locations')
                        .doc(widget.documentId)
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

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final nameLocation =
                          data['nameLocation'] ?? 'Unknown Name';
                      final description =
                          data['description'] ?? 'No description available';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            "${selectedHours != null ? selectedHours! * 5000 : 0} LAK",
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
                                Navigator.of(context).pop();
                                MaterialPageRoute route =
                                    MaterialPageRoute(builder: (c) => QrPay());
                                Navigator.of(context).push(route);
                              },
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white),
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
