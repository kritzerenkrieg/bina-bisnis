import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:buang_bijak/firebase_options.dart';
import 'package:buang_bijak/routes/routes.dart';
import 'package:buang_bijak/screens/not_found.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Locale Indonesia
    await initializeDateFormatting('id_ID', null);

    // Inisialisasi Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
  } catch (e) {
    logger.e('Failed to initialize app', error: e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buang Bijak',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: appRoutes,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundPage(),
        );
      },
    );
  }
}
