import 'package:flutter/material.dart';
import 'screens/common/home_screen.dart';
import 'screens/requester/request_screen.dart';
import 'screens/donor/donate_screen.dart';
import 'screens/admin/confirm_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/account/personal_info_screen.dart';
import 'screens/account/address_screen.dart';
import 'screens/account/phone_number_screen.dart';
import 'screens/account/change_password_screen.dart';
import 'screens/activity/donation_history_screen.dart';
import 'screens/activity/request_history_screen.dart';
import 'screens/activity/my_reviews_screen.dart';
import 'screens/activity/notifications_screen.dart';
import 'screens/support/help_support_screen.dart';
import 'screens/support/about_app_screen.dart';
import 'screens/support/privacy_policy_screen.dart';
import 'screens/support/terms_of_service_screen.dart';
import 'screens/delivery/delivery_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donate App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Redirect first to login
      routes: {
        '/': (context) => HomeScreen(),
        '/donate': (context) => DonateScreen(),
        '/request': (context) => RequestScreen(),
        '/confirm': (context) => ConfirmScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/edit_profile': (context) => PersonalInfoScreen(),
        '/address': (context) => AddressScreen(),
        '/phone_number': (context) => PhoneNumberScreen(),
        '/change_password': (context) => ChangePasswordScreen(),
        '/donation_history': (context) => DonationHistoryScreen(),
        '/request_history': (context) => RequestHistoryScreen(),
        '/my_reviews': (context) => MyReviewsScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/help_support': (context) => HelpSupportScreen(),
        '/about_app': (context) => AboutAppScreen(),
        '/privacy_policy': (context) => PrivacyPolicyScreen(),
        '/terms_of_service': (context) => TermsOfServiceScreen(),
        '/delivery': (context) => DeliveryScreen(),
      },
    );
  }
}
