import 'package:flutter/material.dart';
import '../../../services/donation_service.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState
    extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController =
      TextEditingController();
  final TextEditingController reasonController =
      TextEditingController();
  final TextEditingController amountController =
      TextEditingController();

  final DonationService _donationService = DonationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Donation Request"),
        backgroundColor: const Color(0xFF1E88E5), // Blue
      ),
      backgroundColor: const Color(0xFFEAF3FF), // Mild blue
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Start a Help Request",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5)), // Blue title
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Color(0xFF1E88E5)), // Blue text
                    decoration: _inputDecoration("Name"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter name" : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: reasonController,
                    style: const TextStyle(color: Color(0xFF1E88E5)),
                    decoration: _inputDecoration("Reason"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter reason" : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Color(0xFF1E88E5)),
                    decoration: _inputDecoration("Amount Needed"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter amount" : null,
                  ),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF1E88E5), // Blue button
                        foregroundColor: Colors.white, // White text on button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _donationService
                              .createDonationRequest(
                            name: nameController.text,
                            reason: reasonController.text,
                            amountNeeded:
                                int.parse(amountController.text),
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Request Created Successfully"),
                            ),
                          );

                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Submit Request",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF1E88E5)), // Blue labels
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color(0xFF1E88E5), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)),
    );
  }
}