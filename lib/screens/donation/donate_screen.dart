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
      appBar: AppBar(title: const Text("Donate")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: donorController,
              decoration:
                  const InputDecoration(labelText: "Your Name"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Donation Amount"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print("Donate button clicked");
                await _donationService.donateToRequest(
                  requestId: widget.requestId,
                  donorName: donorController.text,
                  amount: int.parse(amountController.text),
                );
                 print("Donation function completed");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Donation Successful")),
                );

                Navigator.pop(context);
              },
              child: const Text("Donate Now"),
            )
          ],
        ),
      ),
    );
  }
}