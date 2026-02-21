import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstAidTip {
  final String id;
  final String title;
  final String desc;
  final IconData icon;
  bool isFavorite;
  final String? videoId;

  FirstAidTip({
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
    this.isFavorite = false,
    this.videoId,
  });

  factory FirstAidTip.fromJson(Map<String, dynamic> json) {
    return FirstAidTip(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
      isFavorite: json['isFavorite'] ?? false,
      videoId: json['videoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'iconCodePoint': icon.codePoint,
      'isFavorite': isFavorite,
      'videoId': videoId,
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

final Color _appPrimaryBlue = const Color(0xFF1565C0); // Dark blue
final Color _appLightBlue   = const Color(0xFF42A5F5); // Light blue
final Color _appCardColor   = Colors.white;

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

  void _initializeTips() {
    _allTips = [ FirstAidTip(
        id: 'cpr',
        title: 'CPR',
        desc: 'Call emergency, start chest compressions.',
        icon: Icons.monitor_heart,
        videoId: 'gDwt7dD3awc',
      ),
      FirstAidTip(
        id: 'bleeding',
        title: 'Bleeding',
        desc: 'Apply pressure, use a clean cloth.',
        icon: Icons.water_drop,
        videoId: 'V8KiNURVjgk',
      ),
      FirstAidTip(
        id: 'burns',
        title: 'Burns',
        desc: 'Cool burn with water, do not apply ice.',
        icon: Icons.local_fire_department,
        videoId: 'TLr2qsEhpC8',
      ),
      FirstAidTip(
        id: 'choking',
        title: 'Choking',
        desc: 'Give quick upward pressure on belly to help cough out blockage.',
        icon: Icons.warning_amber_outlined,
        videoId: 'PA9hpOnvtCk',
      ),
      FirstAidTip(
        id: 'fractures',
        title: 'Fractures',
        desc: 'Do not move, get help quickly.',
        icon: Icons.broken_image,
        videoId:'sPzXAVNVJr0',
      ),
      FirstAidTip(
        id: 'snake_bite',
        title: 'Snake Bite',
        desc: 'Stay calm, keep limb still and low, get medical help fast.',
        videoId: 'kFbvJkbUukQ',
        icon: Icons.pets,
      ),
      FirstAidTip(
        id: 'heat_stroke',
        title: 'Heat Stroke',
        desc: 'Move to cool place, drink water, cool skin with wet cloth.',
        icon: Icons.thermostat,
        videoId: 'vRg-IChrlXw',
      ),
      FirstAidTip(
        id: 'seizure',
        title: 'Seizure',
        desc: 'Keep person safe, clear area, do not hold down, call emergency.',
        icon: Icons.electric_meter,
        videoId: 'jJWfHHqfSbk',
      ),
      FirstAidTip(id: 'unconsciousness', title: 'Unconsciousness', desc: 'Check response, call 108, clear airway, check breathing, give CPR, turn on side, watch closely.', icon: Icons.sick,videoId:'I-p_YnvOs-0',),
      FirstAidTip(id: 'sunburn', title: 'Sunburn', desc: 'Move to shade, cool skin with water, apply aloe vera, drink water.', icon: Icons.wb_sunny,videoId:'u0sLzfq_w9s',),
      FirstAidTip(id: 'electrocuted', title: 'Electrocuted', desc: 'Turn off power, do not touch victim, call 108, check breathing, give CPR if needed.', icon: Icons.electric_bolt,videoId:'WV5x2PQ71xE',),
      FirstAidTip(id: 'nosebleed', title: 'Nosebleed', desc: 'Sit down, lean forward, pinch nose gently, breathe through mouth.', icon: Icons.face_retouching_natural,videoId:'RxaZSMZ-CD0',),
      FirstAidTip(id: 'fainting', title: 'Fainting', desc: 'Lay down, raise legs, loosen tight clothes, give fresh air.', icon: Icons.airline_seat_legroom_extra,videoId:'ddHKwkMwNyI',),
      FirstAidTip(id: 'poisoning', title: 'Poisoning', desc: 'Call emergency, do not make person vomit unless told.', icon: Icons.dangerous,videoId:'b2ieb8BZJuY',),
      FirstAidTip(id: 'insect_bite', title: 'Insect Bite', desc: 'Clean area, apply cold pack, do not scratch.', icon: Icons.bug_report,videoId:'7Fh3v5c6FY4',),
      FirstAidTip(id: 'sprain', title: 'Sprain', desc: 'Rest, ice the area, compress with bandage, raise the leg or arm.', icon: Icons.medication,videoId:'BZMD3cfyjVI',),
      FirstAidTip(id: 'hypothermia', title: 'Hypothermia', desc: 'Move to warm place, remove wet clothes, cover with blanket.', icon: Icons.ac_unit,videoId:'Sf85qfJUNfc',),
      FirstAidTip(id: 'asthma_attack', title: 'Asthma Attack', desc: 'Help person sit up, use inhaler if available, call emergency if needed.', icon: Icons.air,videoId:'1dV2vFAcqIw',),
      FirstAidTip(id: 'cat_scratch', title: 'Cat Scratch', desc: 'Clean wound with soap and water, apply antiseptic, watch for infection.', icon: Icons.pets,videoId:'Li77KsAXtLI',),
      FirstAidTip(id: 'dog_scratch', title: 'Dog Scratch', desc: 'Wash wound well, apply antiseptic, seek medical help if deep or bleeding.', icon: Icons.pets,videoId:'J5AeWWQ3eN0',),
     
    ];

    _filterTips();
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds =
        _prefs!.getStringList('favorite_first_aid_tips');

    if (favoriteIds != null) {
      for (var tip in _allTips) {
        tip.isFavorite = favoriteIds.contains(tip.id);
      }
    }

    _filterTips();
  }

  Future<void> _saveFavorites() async {
    List<String> favoriteIds =
        _allTips.where((tip) => tip.isFavorite).map((tip) => tip.id).toList();

    await _prefs!.setStringList('favorite_first_aid_tips', favoriteIds);
  }

  void _filterTips() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredTips = _allTips.where((tip) {
        final matchesSearch =
            tip.title.toLowerCase().contains(query) ||
                tip.desc.toLowerCase().contains(query);

        final matchesFavorite =
            !_showFavoritesOnly || tip.isFavorite;

        return matchesSearch && matchesFavorite;
      }).toList();
    });
  }

  void _toggleFavorite(FirstAidTip tip) {
    setState(() {
      tip.isFavorite = !tip.isFavorite;
    });

    _saveFavorites();
    _filterTips();
  }

 @override
Widget build(BuildContext context) {
  final Color primaryColor = _appPrimaryBlue;
  final Color scaffoldBackgroundColor = _appLightBlue;
  final Color cardColor = _appCardColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('First Aid Guide'),
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: primaryColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredTips.length,
        itemBuilder: (context, index) {
          final tip = _filteredTips[index];
          return _buildTipCard(
            tip: tip,
            onFavoriteToggle: _toggleFavorite,
            primaryColor: primaryColor,
            cardColor: cardColor,
          );
        },
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
      margin: const EdgeInsets.only(bottom: 16),
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          if (tip.videoId != null && tip.videoId!.isNotEmpty) {
            final url = Uri.parse(
                "https://www.youtube.com/watch?v=${tip.videoId}");

            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('No video available for ${tip.title}'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                tip.icon,
                size: 36,
                color: primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip.desc,
                      style: TextStyle(
                        color:
                            primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onFavoriteToggle(tip),
                child: Icon(
                  tip.isFavorite
                      ? Icons.star
                      : Icons.star_border,
                  color: tip.isFavorite
                      ? Colors.orange
                      : primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}