import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IVF Clinic Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8BA888), // Sage Green
        scaffoldBackgroundColor: const Color(0xFFF8F6F3), // Warm White
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8BA888),
          primary: const Color(0xFF8BA888),
          secondary: const Color(0xFF6B9B9E), // Teal
          background: const Color(0xFFF8F6F3),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8BA888),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8BA888),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF8BA888),
            side: const BorderSide(color: Color(0xFF8BA888)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF8BA888), width: 2),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
        '/settings': (context) => const SettingsScreen(),
        '/medical_notes': (context) => const MedicalNotesScreen(),
      },
    );
  }
}
