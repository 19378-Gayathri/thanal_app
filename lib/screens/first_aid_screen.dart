import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data model for a First Aid Tip
class FirstAidTip {
  final String id; // Unique ID for persistence
  final String title;
  final String desc;
  final IconData icon; // Icon for the tip
  bool isFavorite;

  FirstAidTip({
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
    this.isFavorite = false,
  });

  // Convert from JSON (for shared_preferences)
  factory FirstAidTip.fromJson(Map<String, dynamic> json) {
    return FirstAidTip(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'), // Recreate IconData
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Convert to JSON (for shared_preferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'iconCodePoint': icon.codePoint, // Store icon's codePoint
      'isFavorite': isFavorite,
    };
  }
}

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FirstAidTip> _allTips = [];
  List<FirstAidTip> _filteredTips = [];
  bool _showFavoritesOnly = false;
  SharedPreferences? _prefs;

  // Define the new green color palette
  final Color _appPrimaryGreen = const Color(0xFF4CAF50); // A medium vibrant green
  final Color _appLightGreen = const Color(0xFFEEF7EE); // Very light green for background
  final Color _appCardColor = Colors.white; // Cards remain white for contrast

  @override
  void initState() {
    super.initState();
    _initializeTips();
    _loadFavorites();
    _searchController.addListener(_filterTips);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTips);
    _searchController.dispose();
    super.dispose();
  }

  // Initialize tips with unique IDs and icons
  void _initializeTips() {
    _allTips = [
      FirstAidTip(id: 'cpr', title: 'CPR', desc: 'Call emergency, start chest compressions.', icon: Icons.monitor_heart),
      FirstAidTip(id: 'bleeding', title: 'Bleeding', desc: 'Apply pressure, use a clean cloth.', icon: Icons.water_drop),
      FirstAidTip(id: 'burns', title: 'Burns', desc: 'Cool burn with water, do not apply ice.', icon: Icons.local_fire_department),
      FirstAidTip(id: 'choking', title: 'Choking', desc: 'Give quick upward pressure on belly to help cough out blockage.', icon: Icons.warning_amber_outlined),
      FirstAidTip(id: 'fractures', title: 'Fractures', desc: 'Do not move, get help quickly.', icon: Icons.broken_image),
      FirstAidTip(id: 'snake_bite', title: 'Snake Bite', desc: 'Stay calm, keep limb still and low, get medical help fast.', icon: Icons.pets),
      FirstAidTip(id: 'unconsciousness', title: 'Unconsciousness', desc: 'Check response, call 108, clear airway, check breathing, give CPR, turn on side, watch closely.', icon: Icons.sick),
      FirstAidTip(id: 'sunburn', title: 'Sunburn', desc: 'Move to shade, cool skin with water, apply aloe vera, drink water.', icon: Icons.wb_sunny),
      FirstAidTip(id: 'electrocuted', title: 'Electrocuted', desc: 'Turn off power, do not touch victim, call 108, check breathing, give CPR if needed.', icon: Icons.electric_bolt),
      FirstAidTip(id: 'nosebleed', title: 'Nosebleed', desc: 'Sit down, lean forward, pinch nose gently, breathe through mouth.', icon: Icons.face_retouching_natural),
      FirstAidTip(id: 'heat_stroke', title: 'Heat Stroke', desc: 'Move to cool place, drink water, cool skin with wet cloth.', icon: Icons.thermostat),
      FirstAidTip(id: 'fainting', title: 'Fainting', desc: 'Lay down, raise legs, loosen tight clothes, give fresh air.', icon: Icons.airline_seat_legroom_extra),
      FirstAidTip(id: 'poisoning', title: 'Poisoning', desc: 'Call emergency, do not make person vomit unless told.', icon: Icons.dangerous),
      FirstAidTip(id: 'insect_bite', title: 'Insect Bite', desc: 'Clean area, apply cold pack, do not scratch.', icon: Icons.bug_report),
      FirstAidTip(id: 'sprain', title: 'Sprain', desc: 'Rest, ice the area, compress with bandage, raise the leg or arm.', icon: Icons.medication),
      FirstAidTip(id: 'hypothermia', title: 'Hypothermia', desc: 'Move to warm place, remove wet clothes, cover with blanket.', icon: Icons.ac_unit),
      FirstAidTip(id: 'asthma_attack', title: 'Asthma Attack', desc: 'Help person sit up, use inhaler if available, call emergency if needed.', icon: Icons.air),
      FirstAidTip(id: 'seizure', title: 'Seizure', desc: 'Keep person safe, clear area, do not hold down, call emergency.', icon: Icons.electric_meter),
      FirstAidTip(id: 'cat_scratch', title: 'Cat Scratch', desc: 'Clean wound with soap and water, apply antiseptic, watch for infection.', icon: Icons.pets),
      FirstAidTip(id: 'dog_scratch', title: 'Dog Scratch', desc: 'Wash wound well, apply antiseptic, seek medical help if deep or bleeding.', icon: Icons.pets),
    ];
    _filterTips(); // Initial filter
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = _prefs!.getStringList('favorite_first_aid_tips');
    if (favoriteIds != null) {
      setState(() {
        for (var tip in _allTips) {
          tip.isFavorite = favoriteIds.contains(tip.id);
        }
      });
    }
    _filterTips(); // Re-filter after loading favorites
  }

  Future<void> _saveFavorites() async {
    List<String> favoriteIds = _allTips.where((tip) => tip.isFavorite).map((tip) => tip.id).toList();
    await _prefs!.setStringList('favorite_first_aid_tips', favoriteIds);
  }

  void _filterTips() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTips = _allTips.where((tip) {
        final matchesSearch = tip.title.toLowerCase().contains(query) ||
            tip.desc.toLowerCase().contains(query);
        final matchesFavorite = !_showFavoritesOnly || tip.isFavorite;
        return matchesSearch && matchesFavorite;
      }).toList();
    });
  }

  void _toggleFavorite(FirstAidTip tip) {
    setState(() {
      tip.isFavorite = !tip.isFavorite;
    });
    _saveFavorites(); // Save changes
    _filterTips(); // Re-filter to update view if favorites mode is active
  }

  @override
  Widget build(BuildContext context) {
    // Use the defined green colors instead of Theme.of(context).colorScheme.primary
    final Color primaryColor = _appPrimaryGreen; // Changed to custom green
    final Color scaffoldBackgroundColor = _appLightGreen; // Changed to custom light green
    final Color cardColor = _appCardColor; // Card color remains white

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'First Aid Guide',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: scaffoldBackgroundColor, // Uses the light green background
        foregroundColor: primaryColor, // Uses the primary green for title/icons
        elevation: 0,
      ),
      backgroundColor: scaffoldBackgroundColor, // Uses the light green background
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse our collection of essential first aid tips. Use the search or filter by favorites for quick access.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color, // Keep original text color for description
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a tip...',
                    prefixIcon: Icon(Icons.search, color: primaryColor), // Icon color uses primary green
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white, // Search bar background
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor.withOpacity(0.3), width: 1.0), // Border color uses primary green
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2.0), // Border color uses primary green
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildToggleButton(
                      label: 'All Tips',
                      isSelected: !_showFavoritesOnly,
                      onTap: () {
                        setState(() {
                          _showFavoritesOnly = false;
                          _filterTips();
                        });
                      },
                      primaryColor: primaryColor, // Uses primary green
                    ),
                    const SizedBox(width: 8),
                    _buildToggleButton(
                      label: 'Favorites',
                      isSelected: _showFavoritesOnly,
                      onTap: () {
                        setState(() {
                          _showFavoritesOnly = true;
                          _filterTips();
                        });
                      },
                      primaryColor: primaryColor, // Uses primary green
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTips.isEmpty && _searchController.text.isNotEmpty
                ? Center(
                    child: Text(
                      'No results found for "${_searchController.text}"',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  )
                : _filteredTips.isEmpty && _showFavoritesOnly
                    ? Center(
                        child: Text(
                          'No favorite tips yet.',
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        itemCount: _filteredTips.length,
                        itemBuilder: (context, index) {
                          final tip = _filteredTips[index];
                          return _buildTipCard(
                            tip: tip,
                            onFavoriteToggle: _toggleFavorite,
                            primaryColor: primaryColor, // Uses primary green
                            cardColor: cardColor, // Uses white card color
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white, // Background color based on selection, uses primary green
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.5), width: 1), // Border color uses primary green
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3), // Shadow color uses primary green
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor, // Text color based on selection, uses primary green
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required FirstAidTip tip,
    required Function(FirstAidTip) onFavoriteToggle,
    required Color primaryColor,
    required Color cardColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: cardColor, // Card background remains white
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withOpacity(0.3), width: 1.5), // Border color uses primary green
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Implement navigation to detail screen or show more info
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${tip.title}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                tip.icon,
                size: 36,
                color: primaryColor, // Icon color uses primary green
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tip.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor.withOpacity(0.9), // Title color uses primary green
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip.desc,
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor.withOpacity(0.7), // Description color uses primary green
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onFavoriteToggle(tip),
                child: Icon(
                  tip.isFavorite ? Icons.star : Icons.star_border,
                  color: tip.isFavorite ? Colors.orange : primaryColor.withOpacity(0.7), // Favorite icon color uses primary green when not starred
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}