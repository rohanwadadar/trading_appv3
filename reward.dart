import 'package:flutter/material.dart';

class Rewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("Rewards", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRewardCard(
              title: "Get up to \$1,500 of stock a year when you invite friends to Robinhood!",
              subtitle: "Robinhood Financial • Limitations apply",
              buttonText: "Invite Friends",
              icon: Icons.attach_money,
            ),
            SizedBox(height: 20),
            _buildRewardCard(
              title: "Get an APY rate boost for 60 days when you join Robinhood Gold",
              subtitle: "Robinhood Gold • Limitations apply",
              buttonText: "Get started",
              icon: Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required IconData icon,
  }) {
    return Card(
      color: Colors.grey[900], // Dark mode card color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(icon, color: Colors.amber, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
