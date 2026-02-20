import 'package:flutter/material.dart';
import '../../../services/donation_service.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final DonationService _donationService = DonationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Donation Request")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: "Reason"),
                validator: (value) =>
                    value!.isEmpty ? "Enter reason" : null,
              ),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Amount Needed"),
                validator: (value) =>
                    value!.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _donationService.createDonationRequest(
                      name: nameController.text,
                      reason: reasonController.text,
                      amountNeeded:
                          int.parse(amountController.text),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Request Created Successfully")),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit Request"),
              )
            ],
          ),
        ),
      ),
    );
  }
}