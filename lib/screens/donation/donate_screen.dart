import 'package:flutter/material.dart';
import '../../../services/donation_service.dart';

class DonateScreen extends StatefulWidget {
  final String requestId;

  const DonateScreen({super.key, required this.requestId});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final TextEditingController donorController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final DonationService _donationService = DonationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate"),
        backgroundColor: Colors.blue.shade700, // 🔵 Changed
      ),
      backgroundColor: const Color(0xFFE3F2FD), // 🔵 Mild blue background
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200, // 🔵 Changed
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Support This Cause",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue), // 🔵 Changed
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: donorController,
                  decoration: InputDecoration(
                    labelText: "Your Name",
                    labelStyle:
                        const TextStyle(color: Colors.blue), // 🔵 Changed
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue.shade700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Donation Amount",
                    labelStyle:
                        const TextStyle(color: Colors.blue), // 🔵 Changed
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue.shade700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue.shade700, // 🔵 Changed
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await _donationService.donateToRequest(
                        requestId: widget.requestId,
                        donorName: donorController.text,
                        amount:
                            int.parse(amountController.text),
                      );

                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content:
                            Text("Donation Successful"),
                      ));

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Donate Now",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}