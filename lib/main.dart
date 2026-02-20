import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
// This import allows for platform-specific Firebase options
import 'firebase_options.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import all your screen files as before
import 'screens/donation_ledger_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/location_permission.dart';
import 'screens/startscreen.dart';
import 'screens/loginscreen.dart';
import 'screens/registerscreen.dart';
import 'screens/home_screen.dart';
import 'screens/alert_screen.dart';
import 'screens/checklist_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/volunteerregister_screen.dart';
import 'screens/volunteerdashboard_screen.dart';
import 'screens/adminpanel_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/first_aid_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/report_incident_screen.dart';
import 'screens/chatbotscreen.dart';
import 'screens/donation_form_screen.dart';
import 'screens/incident_dashboard_screen.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // --- CHANGE 1: Correct the path to the .env file (assuming it's in your project root) ---
  await dotenv.load(fileName: ".env");

  // --- Add these new print statements for debugging your new keys ---
  print('Loaded Gemini API Key: ${dotenv.env['GEMINI_API_KEY']}');
  print('Loaded News API Key: ${dotenv.env['NEWS_API_KEY']}');
  print('Loaded OpenWeatherMap API Key: ${dotenv.env['OPENWEATHERMAP_API_KEY']}');

  // --- CHANGE 2: Use currentPlatform for better multi-platform support ---
  await Firebase.initializeApp(
    // This automatically selects the correct Firebase config (web, iOS, Android)
    options: DefaultFirebaseOptions.web, 
  );

  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('ml')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ThanalApp(),
    ),
  );
}

class ThanalApp extends StatelessWidget {
  const ThanalApp({super.key});

  @override
  Widget build(BuildContext context) {
    // No changes needed in this part of the code
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thanal App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/location': (context) => LocationPermissionScreen(),
        '/start': (context) => StartScreen(),
        '/signup': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/donation-form': (context) => DonationScreen(),
        '/donation-ledger': (context) => DonationLedgerScreen(),
        '/alert': (context) => const AlertScreen(),
        '/checklist': (context) => const ChecklistScreen(),
        '/guide': (context) => const GuideScreen(),
        '/volunteer': (context) => const VolunteerRegisterScreen(),
        '/volunteer_dashboard': (context) => const VolunteerDashboardScreen(),
        '/admin': (context) => const AdminPanelScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/first-aid': (context) => const FirstAidScreen(),
        '/emergency_contacts': (context) => const ContactScreen(),
        '/report': (context) => const ReportIncidentScreen(),
        '/chatbot': (context) => ChatbotScreen(),
        '/incidentDashboard': (context) => const IncidentDashboardScreen(),
      },
    );
  }
}