import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date and time
import 'package:parking/drawer.dart'; // Ensure your drawer_menu() is correctly implemented

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  double balance = 0.0;
  List<Map<String, String>> transactions = []; // Use a Map to store transaction details

  // Controller for the input field
  final TextEditingController _fundsController = TextEditingController();

  // Function to add funds to the wallet
  void addFunds(double amount) {
    setState(() {
      balance += amount;
      String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      transactions.add({
        'type': 'Added',
        'amount': '\$${amount.toStringAsFixed(2)}',
        'timestamp': timestamp,
      });
    });
  }

  // Function to buy a ticket (check if sufficient funds are available)
  bool purchaseTicket(double price) {
    if (balance >= price) {
      setState(() {
        balance -= price;
        String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        transactions.add({
          'type': 'Purchased',
          'amount': '\$${price.toStringAsFixed(2)}',
          'timestamp': timestamp,
        });
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Wallet Balance
            Card(
              margin: EdgeInsets.only(bottom: 20),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balance:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            
            // Add Funds Section
            TextField(
              controller: _fundsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount to Add',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: Colors.blue),
                  onPressed: () {
                    double amount = double.tryParse(_fundsController.text) ?? 0;
                    if (amount > 0) {
                      addFunds(amount);
                      _fundsController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid amount')),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Purchase Ticket Button
            ElevatedButton(
              onPressed: () {
                bool success = purchaseTicket(30.0); // Example: Ticket costs $30
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ticket Purchased')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Insufficient funds')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                
              ),
              child: Text(
                'Buy Ticket for \$30',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Display Transaction History
            Text(
              'Transaction History:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      title: Text(
                          '${transactions[index]['type']} ${transactions[index]['amount']}'),
                      subtitle: Text('Date: ${transactions[index]['timestamp']}'),
                      trailing: Icon(
                        Icons.history,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: drawer_menu(), // Ensure this function is implemented correctly
    );
  }
}
