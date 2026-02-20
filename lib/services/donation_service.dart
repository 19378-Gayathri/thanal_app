import 'package:cloud_firestore/cloud_firestore.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDonationRequest({
    required String name,
    required String reason,
    required int amountNeeded,
  }) async {
    await _firestore.collection('donation_requests').add({
      'name': name,
      'reason': reason,
      'amountNeeded': amountNeeded,
      'amountCollected': 0,
      'status': 'pending',
    });
  }

  Future<void> donateToRequest({
    required String requestId,
    required String donorName,
    required int amount,
  }) async {
    final requestRef =
        _firestore.collection('donation_requests').doc(requestId);

    await requestRef.collection('donations').add({
      'donorName': donorName,
      'amount': amount,
      'timestamp': Timestamp.now(),
    });

    await requestRef.update({
      'amountCollected': FieldValue.increment(amount),
    });
  }
}