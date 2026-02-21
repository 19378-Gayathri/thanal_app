import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';

class DonationLedgerScreen extends StatelessWidget {
  const DonationLedgerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF), // Mild blue background
      appBar: AppBar(
        title: const Text("Donation Ledger"),
        backgroundColor: const Color(0xFF1E88E5), // Blue AppBar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final donation = Donation.fromMap(docs[index].data() as Map<String, dynamic>);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white, // Card background remains white for readability
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1), // Mild blue shadow
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF1E88E5), // Blue border instead of dark green
                    width: 1.2,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.account_circle, color: Color(0xFF1E88E5)),
                  title: Text(
                    donation.donorName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("₹${donation.amount.toStringAsFixed(2)}"),
                  trailing: Text(
                    "${donation.date.day}/${donation.date.month}/${donation.date.year}",
                    style: const TextStyle(color: Color(0xFF1E88E5)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}