import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'title': 'Market Update', 'message': 'BTC/USD has surged 5% today!', 'time': '2 min ago'},
    {'title': 'Trade Executed', 'message': 'Your buy order for ETH was completed.', 'time': '10 min ago'},
    {'title': 'Price Alert', 'message': 'DOGE has hit your target price of \$0.10.', 'time': '30 min ago'},
    {'title': 'Withdrawal Success', 'message': '\$500 has been withdrawn to your bank.', 'time': '1 hour ago'},
    {'title': 'Deposit Received', 'message': '\$1000 has been credited to your account.', 'time': '2 hours ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1A237E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.all(16.0),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey[700]),
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              leading: Icon(Icons.notifications, color: Colors.blueAccent, size: 30),
              title: Text(
                notifications[index]['title']!,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notifications[index]['message']!,
                style: TextStyle(color: Colors.grey[300]),
              ),
              trailing: Text(
                notifications[index]['time']!,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            );
          },
        ),
      ),
    );
  }
}
