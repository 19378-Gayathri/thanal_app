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
    {'name': 'Evacuation', 'icon': Icons.home}, // Changed icon to match image
    {'name': 'Medical Aid', 'icon': Icons.medical_services}, // Changed icon to match image
    {'name': 'Food Distribution', 'icon': Icons.fastfood}, // Changed icon to match image
    {'name': 'Elderly Assistance', 'icon': Icons.elderly}, // Changed icon to match image
  ];

  Future<void> _submit() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    // Validate if at least one expertise is selected
    if (_selectedExpertise.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one area of expertise.')),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in. Please log in to register.');
      }

      await FirebaseFirestore.instance.collection('volunteers').doc(user.uid).set({
        'name': _name,
        'address': _address,
        'phone': _phone,
        'expertise': _selectedExpertise,
        'status': 'pending', // Initial status
        'availability': true, // Default availability
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted successfully! Await verification.')),
      );

      // Optionally navigate back or clear form
      // Navigator.pop(context); // Uncomment this line if you want to pop back after submission

      // Clear form fields after successful submission (optional)
      _formKey.currentState?.reset();
      setState(() {
        _selectedExpertise.clear();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting registration: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5EE), // Light green background matching the image
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center( // Center the card
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24), // Increased padding around the card
                child: Container(
                  width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity, // Max width for larger screens
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Rounded corners for the card
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24), // Padding inside the card
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Make column take minimum space
                      children: [
                        // Custom Title as in the image
                        const Text(
                          'Volunteer Connect',
                          style: TextStyle(
                            fontSize: 28, // Larger font size
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join our community of volunteers. Fill out the form below to get started.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Full Name Input
                        _buildLabel('Full Name'),
                        _buildTextField(
                          hintText: 'Enter your name',
                          onSaved: (value) => _name = value!.trim(),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your full name' : null,
                        ),
                        const SizedBox(height: 20),

                        // Address Input
                        _buildLabel('Address'),
                        _buildTextField(
                          hintText: 'Give address',
                          onSaved: (value) => _address = value!.trim(),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your address' : null,
                        ),
                        const SizedBox(height: 20),

                        // Phone Number Input
                        _buildLabel('Phone Number'),
                        _buildTextField(
                          hintText: '(+91) 9876543210', // Updated hint for Indian format
                          keyboardType: TextInputType.phone,
                          onSaved: (value) => _phone = value!.trim(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            // Regex for Indian mobile numbers (10 digits, starts with 6, 7, 8, or 9)
                            // Allows optional +91 prefix, and optional spaces/dashes for readability
                            final indianPhoneRegex = RegExp(r'^((\+91|\+91\s|\+91-)|(\+91)?)[6789]\d{9}$');

                            if (!indianPhoneRegex.hasMatch(value)) {
                              return 'Enter a valid Indian phone number (e.g., +91 9876543210 or 9876543210)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // Areas of Expertise
                        _buildLabel('Areas of Expertise'),
                        Text(
                          'Select all areas where you can provide assistance.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12.0, // horizontal spacing between chips
                          runSpacing: 12.0, // vertical spacing between rows of chips
                          children: _expertiseOptions.map((option) {
                            final String expertiseName = option['name'];
                            final IconData expertiseIcon = option['icon'];
                            final bool isSelected = _selectedExpertise.contains(expertiseName);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedExpertise.remove(expertiseName);
                                  } else {
                                    _selectedExpertise.add(expertiseName);
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFE8F5E9) : Colors.white, // Light green fill when selected
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF66BB6A) : Colors.grey.shade300, // Darker green border when selected
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF66BB6A).withOpacity(0.2),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          )
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                      size: 20,
                                      color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(expertiseIcon, size: 20, color: Colors.black54),
                                    const SizedBox(width: 6),
                                    Text(
                                      expertiseName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50), // Green button background
                              foregroundColor: Colors.white, // White icon and text
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              elevation: 5, // Shadow for the button
                            ),
                            onPressed: _submit,
                            icon: const Icon(Icons.send), // Send icon
                            label: const Text(
                              'Submit Registration',
                              style: TextStyle(
                                fontSize: 18, // Larger font size for the button text
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

  // Helper widget for consistent label styling
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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

  // Helper widget for consistent text field styling
  Widget _buildTextField({
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: const Color(0xFFE8F5E9), // Light green background for text fields
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // No border visible
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF66BB6A), width: 1.5), // Subtle green border on focus
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      style: const TextStyle(color: Colors.black87), // Text color
    );
  }
}