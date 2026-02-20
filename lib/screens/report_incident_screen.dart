import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final desc = _descController.text;
      final location = _locationController.text;

      try {
        // Ensure FirebaseFirestore is initialized before use.
        // In a real app, Firebase would be initialized in main.dart.
        await FirebaseFirestore.instance.collection('incidents').add({
          'title': title,
          'description': desc,
          'location': location,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incident Report Submitted')),
        );

        _formKey.currentState!.reset();
        _titleController.clear();
        _descController.clear();
        _locationController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting report: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set a light greenish background color for the scaffold body
      backgroundColor: Colors.green[50], // Lighter green background
      appBar: AppBar(
        title: const Text('Report Incident'),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove shadow
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SwiftReport Header
              Text(
                'Report Incident',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800], // Darker green for main title
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Quickly and easily report incidents with our streamlined form.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[600], // Greenish grey for subheading
                ),
              ),
              const SizedBox(height: 30),
              // Main form card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report an Incident',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800], // Darker green for card title
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fill out the form below to submit an incident report.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[600], // Greenish grey for card subheading
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Incident Title Text Field
                        Text(
                          'Incident Title',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700], // Greenish grey for label
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Flood in my area',
                            prefixIcon: const Icon(Icons.description, color: Colors.green), // Green icon
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.green[100], // Lighter green fill
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a title'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        // Description Text Field
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700], // Greenish grey for label
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descController,
                          decoration: InputDecoration(
                            hintText: 'Describe the incident in short...',
                            prefixIcon: const Icon(Icons.chat_bubble_outline, color: Colors.green), // Green icon
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.green[100], // Lighter green fill
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          ),
                          maxLines: 5, // Increased maxLines for description
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a description'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        // Location Text Field
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700], // Greenish grey for label
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Pulpally, Wayanad',
                            prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.green), // Green icon
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.green[100], // Lighter green fill
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a location'
                              : null,
                        ),
                        const SizedBox(height: 30),
                        // Submit Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _submitReport,
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: const Text(
                              'Submit Report',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700], // Darker green button color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
