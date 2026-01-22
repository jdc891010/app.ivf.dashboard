import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/staff_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/patients_screen.dart';
import 'screens/patient_detail_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/staff_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/treatments_screen.dart';
import 'screens/lab_results_screen.dart';
import 'screens/messenger_screen.dart';
import 'screens/protocols_screen.dart';
import 'screens/protocol_detail_screen.dart';
import 'screens/medical_notes_screen.dart';
import 'screens/appointment_form_screen.dart';
import 'screens/staff_form_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return MaterialApp(
      title: 'IVF Clinic Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF8F6F3),
        primaryColor: const Color(0xFF8BA888),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF8BA888),
          secondary: Color(0xFF6B9B9E),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF3A3A3A),
          error: Color(0xFFE89B8E),
        ),
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: const Color(0xFF3A3A3A),
          displayColor: const Color(0xFF3A3A3A),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8BA888),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF8BA888),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8BA888),
          secondary: Color(0xFF6B9B9E),
          surface: Color(0xFF1E1E1E),
          onPrimary: Colors.white,
          onSurface: Colors.white,
          error: Color(0xFFE89B8E),
        ),
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/patients': (context) => const PatientsScreen(),
        '/patient_detail': (context) => const PatientDetailScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
        '/appointment_form': (context) => const AppointmentFormScreen(),
        '/treatments': (context) => const TreatmentsScreen(),
        '/protocols': (context) => const ProtocolsScreen(),
        '/protocol_detail': (context) => const ProtocolDetailScreen(),
        '/lab_results': (context) => const LabResultsScreen(),
        '/messenger': (context) => const MessengerScreen(),
        '/staff': (context) => const StaffScreen(),
        '/staff_form': (context) => const StaffFormScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/medical_notes': (context) => const MedicalNotesScreen(),
      },
    );
  }
}
