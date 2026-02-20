import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<Map<String, dynamic>> checklist = [
    {'key': 'first aid kit', 'done': false, 'icon': Icons.medical_services},
    {'key': 'water supply', 'done': false, 'icon': Icons.water_drop},
    {'key': 'flashlight', 'done': false, 'icon': Icons.flashlight_on},
    {'key': 'documents', 'done': false, 'icon': Icons.description},
    {'key': 'food', 'done': false, 'icon': Icons.fastfood},
    {'key': 'charger', 'done': false, 'icon': Icons.battery_charging_full},
    {'key': 'whistle', 'done': false, 'icon': Icons.notifications_active},
    {'key': 'batteries', 'done': false, 'icon': Icons.battery_full},
    {'key': 'radio', 'done': false, 'icon': Icons.radio},
    {'key': 'face mask', 'done': false, 'icon': Icons.masks},
    {'key': 'gloves', 'done': false, 'icon': Icons.back_hand},
    {'key': 'medications', 'done': false, 'icon': Icons.local_pharmacy},
    {'key': 'warm clothes', 'done': false, 'icon': Icons.checkroom},
    {'key': 'blanket', 'done': false, 'icon': Icons.bed},
    {'key': 'multi-tool', 'done': false, 'icon': Icons.build},
    {'key': 'sanitizer', 'done': false, 'icon': Icons.sanitizer},
    {'key': 'rope', 'done': false, 'icon': Icons.nature_people},
    {'key': 'matches/lighter', 'done': false, 'icon': Icons.fireplace},
    {'key': 'emergency contact list', 'done': false, 'icon': Icons.contacts},
    {'key': 'cash', 'done': false, 'icon': Icons.attach_money},
  ];

  int _packedItemsCount = 0;

  @override
  void initState() {
    super.initState();
    _calculatePackedItems(); // Initialize count
  }

  void _calculatePackedItems() {
    _packedItemsCount = checklist.where((item) => item['done'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding ChecklistScreen with locale: ${context.locale}");
    final int totalItems = checklist.length;
    final double readinessScore = (_packedItemsCount / totalItems) * 100;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green background
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white, // White app bar
            expandedHeight: 120.0, // Reduced height as 'ReadyNow' is removed
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white, // Background color for the top section
                padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0), // Adjust top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Removed the Row containing "ReadyNow" logo and text
                    Text(
                      'Your Emergency Checklist'.tr(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stay prepared for any situation.'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    color: Colors.white, // White card background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    elevation: 0, // No shadow
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Readiness Score'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: _packedItemsCount / totalItems,
                            backgroundColor: Colors.grey[200],
                            color: Colors.green,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$_packedItemsCount of $totalItems items packed'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${readinessScore.round()}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...checklist.map((item) {
                    return Card(
                      color: item['done'] ? Colors.green[50] : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: CheckboxListTile(
                        title: Text(
                          item['key'].toString().tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration:
                                item['done'] ? TextDecoration.lineThrough : null,
                            color: item['done'] ? Colors.grey[600] : Colors.black87,
                          ),
                        ),
                        value: item['done'],
                        onChanged: (bool? value) {
                          setState(() {
                            item['done'] = value!;
                            _calculatePackedItems();
                          });
                        },
                        secondary: Icon(
                          item['icon'],
                          color: item['done'] ? Colors.grey[400] : Colors.green[700],
                          size: 28,
                        ),
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}