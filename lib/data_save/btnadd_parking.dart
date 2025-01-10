import 'package:flutter/material.dart';

class BtnaddParking extends StatefulWidget {
  const BtnaddParking({super.key});

  @override
  State<BtnaddParking> createState() => _BtnaddParkingState();
}

class _BtnaddParkingState extends State<BtnaddParking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("btnadd"),
      ),
    );
  }
}