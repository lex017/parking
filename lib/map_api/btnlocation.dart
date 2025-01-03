import 'package:flutter/material.dart';

class btnLocation extends StatefulWidget {
  const btnLocation({super.key});

  @override
  State<btnLocation> createState() => _btnLocationState();
}

class _btnLocationState extends State<btnLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("address"),
    );
  }
}