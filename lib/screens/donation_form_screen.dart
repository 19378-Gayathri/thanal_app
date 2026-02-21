import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUpiApps();
  }

  void _fetchUpiApps() async {
    try {
      List<UpiApp> appsList = await _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
      setState(() => apps = appsList);
    } catch (e) {
      setState(() => apps = []);
      print("UPI error: $e");
    }
  }

  void _payWithUpi(UpiApp app) async {
    if (nameController.text.isEmpty || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name and amount")),
      );
      return;
    }

    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    UpiResponse response = await _upiIndia.startTransaction(
      app: app,
      receiverUpiId: 'your-upi-id@okaxis', // Replace with your actual UPI ID
      receiverName: nameController.text,
      transactionRefId: "Thanal_${DateTime.now().millisecondsSinceEpoch}",
      transactionNote: noteController.text,
      amount: amount,
    );

    _handleUpiResponse(response);
  }

  void _handleUpiResponse(UpiResponse response) {
    String status = response.status ?? "Unknown";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transaction status: $status")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color to milky blue
      backgroundColor: Color(0xFFE6F0FA), // light milky blue
      appBar: AppBar(
        title: Text("Donate via UPI"),
        backgroundColor: Colors.blue, // AppBar color changed to blue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Amount (₹)",
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: "Note",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Select UPI App to Pay",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            apps == null
                ? CircularProgressIndicator()
                : apps!.isEmpty
                    ? Text(
                        "No UPI apps found. Make sure you're on a real phone with GPay/PhonePe.",
                      )
                    : Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: apps!.map((app) {
                          return InkWell(
                            onTap: () => _payWithUpi(app),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.memory(app.icon, height: 60, width: 60),
                                SizedBox(height: 5),
                                Text(
                                  app.name,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
          ],
        ),
      ),
    );
  }
}