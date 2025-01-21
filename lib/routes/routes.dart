import 'package:flutter/material.dart';
import 'package:buang_bijak/screens/home_screen.dart';
import 'package:buang_bijak/screens/pickup_screens.dart';
import 'package:buang_bijak/screens/user_settings.dart';
import 'package:buang_bijak/screens/landing_page.dart';
import 'package:buang_bijak/screens/detail_pickup.dart';
import 'package:buang_bijak/screens/landing_pickup.dart';
import 'package:buang_bijak/screens/history_pickup.dart';
import 'package:buang_bijak/screens/dashboard.dart';
import 'package:buang_bijak/screens/dashboard_detail.dart';
import 'package:buang_bijak/screens/not_found.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(
        isAdmin: false,
      ),
  '/ajukan-pickup': (context) => const PickupPage(),
  '/profil-saya': (context) => const UserSettings(),
  '/login': (context) => const LoginSignup(),
  '/landing-pickup': (context) => LandingPickup(),
  '/history-pickup': (context) => HistoryPickup(),
  '/dashboard': (context) => Dashboard(),
  '/not-found': (context) => const NotFoundPage(),
};

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/detail-pickup':
      final args = settings.arguments as Map<String, String>?;
      if (args != null) {
        return MaterialPageRoute(
          builder: (context) => DetailPickup(
            status: args['status'] ?? '',
            date: args['date'] ?? '',
            time: args['time'] ?? '',
            wasteType: args['wasteType'] ?? '',
            address: args['address'] ?? '',
            orderId: args['order_id'] ?? '',
            isRevised: args['isRevised'] == 'false',
            rejectedReason: args['rejectedReason'] ?? '',
          ),
        );
      }
      return MaterialPageRoute(builder: (context) => const NotFoundPage());

    case '/dashboard-detail':
      final args = settings.arguments as Map<String, String>?;
      if (args != null) {
        return MaterialPageRoute(
          builder: (context) => DashboardDetail(
            status: args['status'] ?? '',
            wasteType: args['wasteType'] ?? '',
            address: args['address'] ?? '',
            date: args['date'] ?? '',
            time: args['time'] ?? '',
            orderId: args['order_id'] ?? '',
            rejectedReason: args['rejectedReason'] ?? '',
            fullName: args['fullName'] ?? '',
          ),
        );
      }
      return MaterialPageRoute(builder: (context) => const NotFoundPage());

    default:
      return MaterialPageRoute(builder: (context) => const NotFoundPage());
  }
}
