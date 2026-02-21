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
    _calculatePackedItems();
  }

  void _calculatePackedItems() {
    _packedItemsCount = checklist.where((item) => item['done'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
    final int totalItems = checklist.length;
    final double readinessScore = (_packedItemsCount / totalItems) * 100;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1565C0), // Dark blue
              Color(0xFF42A5F5), // Light blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding:
                      const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Emergency Checklist'.tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Stay prepared for any situation.'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
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
                      color: Colors.white.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Readiness Score',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _packedItemsCount /
                                  totalItems,
                              backgroundColor:
                                  Colors.white24,
                              color: Colors.blueAccent,
                              minHeight: 8,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$_packedItemsCount of $totalItems items packed',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  '${readinessScore.round()}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Colors.white,
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
                        color: item['done']
                            ? Colors.white.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        margin:
                            const EdgeInsets.symmetric(
                                vertical: 8),
                        child: CheckboxListTile(
                          title: Text(
                            item['key']
                                .toString()
                                .tr(),
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                              decoration: item['done']
                                  ? TextDecoration
                                      .lineThrough
                                  : null,
                              color: Colors.white,
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
                            color: Colors.white,
                            size: 28,
                          ),
                          activeColor: Colors.white,
                          checkColor: Colors.blue,
                          controlAffinity:
                              ListTileControlAffinity
                                  .trailing,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}