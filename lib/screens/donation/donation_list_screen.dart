import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donate_screen.dart';

class DonationListScreen extends StatelessWidget {
  const DonationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Donation Requests"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('donation_requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child:
                    CircularProgressIndicator());
          }

          final docs =
              snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
                child:
                    Text("No Requests Found"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder:
                (context, index) {
              var data = docs[index];

              return Container(
                margin:
                    const EdgeInsets.all(12),
                padding:
                    const EdgeInsets.all(18),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                          16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 123, 180, 211),
                      blurRadius: 8,
                      offset:
                          const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      data['name'],
                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(
                        height: 6),
                    Text(
                      "Needed: ₹${data['amountNeeded']}",
                      style:
                          const TextStyle(
                        color:
                            Colors.black87,
                      ),
                    ),
                    Text(
                      "Collected: ₹${data['amountCollected']}",
                      style:
                          const TextStyle(
                        color:
                            Colors.black87,
                      ),
                    ),
                    const SizedBox(
                        height: 12),
                    Align(
                      alignment: Alignment
                          .centerRight,
                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 56, 132, 142),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        10),
                          ),
                        ),
                        child:
                            const Text(
                          "Donate",
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DonateScreen(
                                requestId:
                                    data.id,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
