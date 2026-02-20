import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Required for date formatting

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool elderMode = false;
  bool isAdmin = false; // Based on your previous code, this would come from arguments
  bool _isAdminLoaded = false;

  // Define the consistent green color palette
  final Color _baseGreenBackground = const Color(0xFFEEF7EE); // Light background green
  final Color _greenAccent = const Color(0xFF4CAF50); // A brighter green for icons/accents
  final Color _darkGreenText = const Color(0xFF388E3C); // Darker green for main text
  final Color _lightGreyText = const Color(0xFF616161); // For secondary text like date

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
    // Determine font and icon sizes based on elderMode
    // Base sizes for "normal" mode
    final double baseThanalFontSize = 28;
    final double baseDateFontSize = 16;
    final double baseCardFontSize = 12;
    final double baseCardIconSize = 24;

    // Scaling factors for Elder Mode
    final double elderModeScaleFactor = 1.3; // Increase font/icon sizes by 30% in Elder Mode

    // Calculate actual sizes based on elderMode state
    final double thanalFontSize = elderMode ? baseThanalFontSize * elderModeScaleFactor : baseThanalFontSize;
    final double dateFontSize = elderMode ? baseDateFontSize * elderModeScaleFactor : baseDateFontSize;
    final double cardFontSize = elderMode ? baseCardFontSize * elderModeScaleFactor : baseCardFontSize;
    final double cardIconSize = elderMode ? baseCardIconSize * elderModeScaleFactor : baseCardIconSize;
    // The 'Elder Mode' label itself will keep its specific larger size for prominence as a toggle.

    // Get current date for display (Current time is Friday, July 25, 2025)
    final DateTime now = DateTime(2025, 7, 25); // Hardcoded for consistency with screenshot
    final String formattedDate = DateFormat('EEEE, dd MMMM').format(now);

    return Scaffold(
      backgroundColor: _baseGreenBackground, // Apply the light green background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- START Thanal title font size change ---
                      Text(
                        'Thanal',
                        style: TextStyle(
                          fontSize: thanalFontSize, // Now scales with elderMode
                          fontWeight: FontWeight.bold,
                          color: _darkGreenText,
                        ),
                      ),
                      // --- END Thanal title font size change ---
                      // --- START Date font size change ---
                      Text(
                        formattedDate, // Display formatted date
                        style: TextStyle(
                          fontSize: dateFontSize, // Now scales with elderMode
                          color: _lightGreyText,
                        ),
                      ),
                      // --- END Date font size change ---
                    ],
                  ),
                  Row(
                    children: [
                      // 'Elder Mode' label itself kept at fixed large size for prominence
                      Text(
                        'Elder Mode',
                        style: TextStyle(
                          fontSize: 18, // Remains fixed for the toggle label itself
                          fontWeight: FontWeight.bold,
                          color: _lightGreyText,
                        ),
                      ),
                      Switch(
                        value: elderMode,
                        onChanged: (value) {
                          setState(() {
                            elderMode = value;
                          });
                        },
                        activeColor: _greenAccent, // Green color when active
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16), // Padding around the grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Changed to 4 items per row
                  crossAxisSpacing: 10, // Reduced spacing between columns
                  mainAxisSpacing: 10, // Reduced spacing between rows
                  childAspectRatio: 0.85, // Adjusted ratio for a more compact card
                ),
                itemCount: _getDashboardItems().length,
                itemBuilder: (context, index) {
                  final item = _getDashboardItems()[index];
                  return _buildDashboardCard(
                    icon: item['icon'] as IconData,
                    label: item['label'] as String,
                    onTap: item['onTap'] as VoidCallback,
                    iconColor: _greenAccent, // All icons are green
                    textColor: _darkGreenText, // All text is dark green
                    cardFontSize: cardFontSize, // Passed the scaled font size
                    cardIconSize: cardIconSize, // Passed the scaled icon size
                    showBadge: item['showBadge'] as bool? ?? false,
                    badgeText: item['badgeText'] as String? ?? '',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to define dashboard items and their properties
  List<Map<String, dynamic>> _getDashboardItems() {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.lightbulb_outline, // Matches image
        'label': 'Live Alerts',
        'onTap': () => Navigator.pushNamed(context, '/alert'),
        'showBadge': true,
        'badgeText': 'Urgent',
      },
      {
        'icon': Icons.checklist_rtl, // Matches image
        'label': 'Checklist Access',
        'onTap': () => Navigator.pushNamed(context, '/checklist'),
      },
      {
        'icon': Icons.people_outline, // Matches image
        'label': 'Emergency Contacts',
        'onTap': () => Navigator.pushNamed(context, '/emergency_contacts'),
      },
      {
        'icon': Icons.health_and_safety_outlined, // Matches image
        'label': 'First Aid Guide',
        'onTap': () => Navigator.pushNamed(context, '/first-aid'),
      },
      {
        'icon': Icons.chat_bubble_outline, // Matches image
        'label': 'Thanal Chatbot',
        'onTap': () => Navigator.pushNamed(context, '/chatbot'),
      },
      {
        'icon': Icons.edit_note, // Matches image
        'label': 'Report Incident',
        'onTap': () => Navigator.pushNamed(context, '/report'),
      },
      {
        'icon': Icons.dashboard_outlined, // Matches image
        'label': 'Incident Dashboard',
        'onTap': () => Navigator.pushNamed(context, '/incidentDashboard'),
      },
      {
        'icon': Icons.person_add_alt_1_outlined, // Matches image
        'label': 'Volunteer Registration',
        'onTap': () => Navigator.pushNamed(context, '/volunteer'),
      },
      {
        'icon': Icons.format_list_bulleted_add, // Matches image
        'label': 'Volunteer Dashboard',
        'onTap': () => Navigator.pushNamed(context, '/volunteer_dashboard'),
      },
      // Removed: Donation Ledger, Add Donation, Voice Assistant
    ];

    if (isAdmin) {
      items.add({
        'icon': Icons.admin_panel_settings_outlined, // Matches image
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
    required double cardFontSize, // Now dynamic
    required double cardIconSize, // Now dynamic
    bool showBadge = false,
    String badgeText = '',
  }) {
    return Card(
      color: Colors.white, // Card background is white
      elevation: 0, // No shadow for the cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: _greenAccent.withOpacity(0.1), // Subtle green splash
        child: Padding(
          padding: const EdgeInsets.all(6.0), // Further reduced padding
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: cardIconSize, color: iconColor), // Uses dynamic size
                    const SizedBox(height: 4), // Reduced spacing
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: cardFontSize, // Uses dynamic size
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      maxLines: 2, // Allow label to wrap for smaller cards
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showBadge)
                Positioned(
                  right: 0, // Align to top right
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), // Smaller badge padding
                    decoration: BoxDecoration(
                      color: Colors.redAccent, // Red for urgent badge
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8, // Even smaller font for badge
                        fontWeight: FontWeight.bold,
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