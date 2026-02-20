import 'package:flutter/material.dart';
import 'LiveMapScreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool elderMode = false;
  bool isAdmin = false;
  bool _isAdminLoaded = false;

  final Color _baseGreenBackground = const Color(0xFFEEF7EE);
  final Color _greenAccent = const Color(0xFF4CAF50);
  final Color _darkGreenText = const Color(0xFF2E7D32);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAdminLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is bool) {
        setState(() {
          isAdmin = args;
          _isAdminLoaded = true;
        });
      } else {
        _isAdminLoaded = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double baseCardFontSize = 16;
    final double baseCardIconSize = 32;
    final double elderModeScaleFactor = 1.8;

    final double cardFontSize =
        elderMode ? baseCardFontSize * elderModeScaleFactor : baseCardFontSize;
    final double cardIconSize =
        elderMode ? baseCardIconSize * elderModeScaleFactor : baseCardIconSize;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image (UNCHANGED)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Thanal - A Hand to Hold in Every Crisis',
                    style: TextStyle(
                      fontSize: elderMode ? 34 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900, // Changed to black
                    ),
                  ),
                ),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 pushes to right
    children: [
      const SizedBox(), // empty space on left
      Row(
        children: [
          Text(
            'Elder Mode',
            style: TextStyle(
              fontSize: elderMode ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Transform.scale(
            scale: elderMode ? 1.5 : 1.2,
            child: Switch(
              value: elderMode,
              onChanged: (value) {
                setState(() {
                  elderMode = value;
                });
              },
              activeColor: _greenAccent,
            ),
          ),
        ],
      ),
    ],
  ),
),

                // Dashboard Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: _getDashboardItems().length,
                    itemBuilder: (context, index) {
                      final item = _getDashboardItems()[index];
                      return _buildDashboardCard(
                        icon: item['icon'] as IconData,
                        label: item['label'] as String,
                        onTap: item['onTap'] as VoidCallback,
                        iconColor: _greenAccent,
                        textColor: _darkGreenText,
                        cardFontSize: cardFontSize,
                        cardIconSize: cardIconSize,
                        showBadge:
                            item['showBadge'] as bool? ?? false,
                        badgeText:
                            item['badgeText'] as String? ?? '',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

List<Map<String, dynamic>> _getDashboardItems() {
  final List<Map<String, dynamic>> items = [
    {
      'icon': Icons.lightbulb_outline,
      'label': 'Live Alerts',
      'onTap': () => Navigator.pushNamed(context, '/alert'),
    },
    {
      'icon': Icons.checklist_rtl,
      'label': 'Checklist Access',
      'onTap': () => Navigator.pushNamed(context, '/checklist'),
    },
    {
      'icon': Icons.people_outline,
      'label': 'Emergency Contacts',
      'onTap': () =>
          Navigator.pushNamed(context, '/emergency_contacts'),
    },
    {
      'icon': Icons.health_and_safety_outlined,
      'label': 'First Aid Guide',
      'onTap': () => Navigator.pushNamed(context, '/first-aid'),
    },
    {
      'icon': Icons.chat_bubble_outline,
      'label': 'Thanal Chatbot',
      'onTap': () => Navigator.pushNamed(context, '/chatbot'),
    },
    {
      'icon': Icons.edit_note,
      'label': 'Report Incident',
      'onTap': () => Navigator.pushNamed(context, '/report'),
    },
    {
      'icon': Icons.dashboard_outlined,
      'label': 'Incident Dashboard',
      'onTap': () =>
          Navigator.pushNamed(context, '/incidentDashboard'),
    },
    {
      'icon': Icons.person_add_alt_1_outlined,
      'label': 'Volunteer Registration',
      'onTap': () => Navigator.pushNamed(context, '/volunteer'),
    },

    // 🔹 NEW: View Donation Requests
    {
      'icon': Icons.volunteer_activism,
      'label': 'Donations',
      'onTap': () =>
          Navigator.pushNamed(context, '/donation-requests'),
    },

    // 🔹 NEW: Create Donation Request
    {
      'icon': Icons.add_circle_outline,
      'label': 'Request Help',
      'onTap': () =>
          Navigator.pushNamed(context, '/create-request'),
    },
    {
  'icon': Icons.location_on_outlined,
  'label': 'Live Location',
  'onTap': () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LiveMapScreen(),
        ),
      ),
},
  ];

  if (isAdmin) {
    items.add({
      'icon': Icons.admin_panel_settings_outlined,
      'label': 'Admin Panel',
      'onTap': () => Navigator.pushNamed(context, '/admin'),
    });
  }

  return items;
}

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
    required Color textColor,
    required double cardFontSize,
    required double cardIconSize,
    bool showBadge = false,
    String badgeText = '',
  }) {
    return Card(
      color: const Color(0xFFDFF5E1), // Light green card
      elevation: 6,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: cardIconSize,
                  color: iconColor),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: cardFontSize,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showBadge)
                Container(
                  margin:
                      const EdgeInsets.only(top: 6),
                  padding:
                      const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
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