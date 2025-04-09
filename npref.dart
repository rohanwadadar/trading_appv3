import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const NotificationApp());
}

class NotificationApp extends StatelessWidget {
  const NotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notifications',
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          NotificationCategory(title: "Email Notifications", icon: Icons.email, screen: const EmailNotificationsScreen()),
          NotificationCategory(title: "SMS Notifications", icon: Icons.sms, screen: const SmsNotificationsScreen()),
          NotificationCategory(title: "Push Notifications", icon: Icons.notifications, screen: const PushNotificationsScreen()),
          NotificationCategory(title: "Promotions", icon: Icons.local_offer, screen: const PromotionsScreen()),
        ],
      ),
    );
  }
}

class NotificationCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget screen;
  const NotificationCategory({super.key, required this.title, required this.icon, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      ),
    );
  }
}

class EmailNotificationsScreen extends StatefulWidget {
  const EmailNotificationsScreen({super.key});

  @override
  _EmailNotificationsScreenState createState() => _EmailNotificationsScreenState();
}

class _EmailNotificationsScreenState extends State<EmailNotificationsScreen> {
  bool bankActivity = true;
  bool investorUpdates = false;
  bool orderStatus = true;

  @override
  Widget build(BuildContext context) {
    return NotificationSettingsScreen(
      title: "Email Notifications",
      settings: [
        NotificationToggle(title: "Bank Activity", value: bankActivity, onChanged: (val) => setState(() => bankActivity = val)),
        NotificationToggle(title: "Investor Updates", value: investorUpdates, onChanged: (val) => setState(() => investorUpdates = val)),
        NotificationToggle(title: "Order Status", value: orderStatus, onChanged: (val) => setState(() => orderStatus = val)),
      ],
    );
  }
}

class SmsNotificationsScreen extends StatefulWidget {
  const SmsNotificationsScreen({super.key});

  @override
  _SmsNotificationsScreenState createState() => _SmsNotificationsScreenState();
}

class _SmsNotificationsScreenState extends State<SmsNotificationsScreen> {
  bool otpAlerts = true;
  bool accountAlerts = false;

  @override
  Widget build(BuildContext context) {
    return NotificationSettingsScreen(
      title: "SMS Notifications",
      settings: [
        NotificationToggle(title: "OTP Alerts", value: otpAlerts, onChanged: (val) => setState(() => otpAlerts = val)),
        NotificationToggle(title: "Account Alerts", value: accountAlerts, onChanged: (val) => setState(() => accountAlerts = val)),
      ],
    );
  }
}

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  _PushNotificationsScreenState createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  bool appUpdates = true;
  bool securityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return NotificationSettingsScreen(
      title: "Push Notifications",
      settings: [
        NotificationToggle(title: "App Updates", value: appUpdates, onChanged: (val) => setState(() => appUpdates = val)),
        NotificationToggle(title: "Security Alerts", value: securityAlerts, onChanged: (val) => setState(() => securityAlerts = val)),
      ],
    );
  }
}

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  bool specialOffers = false;
  bool discounts = true;

  @override
  Widget build(BuildContext context) {
    return NotificationSettingsScreen(
      title: "Promotions",
      settings: [
        NotificationToggle(title: "Special Offers", value: specialOffers, onChanged: (val) => setState(() => specialOffers = val)),
        NotificationToggle(title: "Discount Alerts", value: discounts, onChanged: (val) => setState(() => discounts = val)),
      ],
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  final String title;
  final List<Widget> settings;
  const NotificationSettingsScreen({super.key, required this.title, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.all(16.0), children: settings),
    );
  }
}

class NotificationToggle extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const NotificationToggle({super.key, required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }
}
