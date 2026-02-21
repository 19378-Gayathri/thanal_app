import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerRegisterScreen extends StatefulWidget {
  const VolunteerRegisterScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerRegisterScreen> createState() => _VolunteerRegisterScreenState();
}

class _VolunteerRegisterScreenState extends State<VolunteerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _address = '';
  String _phone = '';
  List<String> _selectedExpertise = [];

  bool _isLoading = false;

  final List<Map<String, dynamic>> _expertiseOptions = [
    {'name': 'Evacuation', 'icon': Icons.home},
    {'name': 'Medical Aid', 'icon': Icons.medical_services},
    {'name': 'Food Distribution', 'icon': Icons.fastfood},
    {'name': 'Elderly Assistance', 'icon': Icons.elderly},
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    if (_selectedExpertise.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one area of expertise.')),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in.');
      }

      await FirebaseFirestore.instance.collection('volunteers').doc(user.uid).set({
        'name': _name,
        'address': _address,
        'phone': _phone,
        'expertise': _selectedExpertise,
        'status': 'pending',
        'availability': true,
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted successfully! Await verification.')),
      );

      _formKey.currentState?.reset();
      setState(() => _selectedExpertise.clear());

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting registration: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5), // Strong blue background
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 2,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Volunteer Connect',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join our community of volunteers. Fill out the form below to get started.',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        const SizedBox(height: 32),

                        _buildLabel('Full Name'),
                        _buildTextField(
                          hintText: 'Enter your name',
                          onSaved: (value) => _name = value!.trim(),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your full name' : null,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('Address'),
                        _buildTextField(
                          hintText: 'Give address',
                          onSaved: (value) => _address = value!.trim(),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your address' : null,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('Phone Number'),
                        _buildTextField(
                          hintText: '(+91) 9876543210',
                          keyboardType: TextInputType.phone,
                          onSaved: (value) => _phone = value!.trim(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            final indianPhoneRegex =
                                RegExp(r'^((\+91|\+91\s|\+91-)|(\+91)?)[6789]\d{9}$');
                            if (!indianPhoneRegex.hasMatch(value)) {
                              return 'Enter a valid Indian phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        _buildLabel('Areas of Expertise'),
                        Text(
                          'Select all areas where you can provide assistance.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _expertiseOptions.map((option) {
                            final name = option['name'];
                            final icon = option['icon'];
                            final isSelected = _selectedExpertise.contains(name);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedExpertise.remove(name);
                                  } else {
                                    _selectedExpertise.add(name);
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFE3F2FD)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF42A5F5)
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      size: 20,
                                      color: isSelected
                                          ? const Color(0xFF1E88E5)
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(icon, size: 20, color: Colors.black54),
                                    const SizedBox(width: 6),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            onPressed: _submit,
                            icon: const Icon(Icons.send),
                            label: const Text(
                              'Submit Registration',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFE3F2FD), // Light blue input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: Color(0xFF42A5F5), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      style: const TextStyle(color: Colors.black87),
    );
  }
}