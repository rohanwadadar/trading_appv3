import 'package:flutter/material.dart';

class RewardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      appBar: AppBar(
        title: Text("Rewards", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Past", style: TextStyle(color: Colors.green)),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            rewardCard(
              title: "Robinhood Financial • Limitations apply",
              description: "Get up to \$1,500 of stock a year when you invite friends to Robinhood!",
              buttonText: "Invite Friends",
              icon: Icons.attach_money,
            ),
            SizedBox(height: 16),
            rewardCard(
              title: "Robinhood Gold • Limitations apply",
              description: "Get an APY rate boost for 60 days when you join Robinhood Gold",
              buttonText: "Get started",
              icon: Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget rewardCard({required String title, required String description, required String buttonText, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(buttonText, style: TextStyle(color: Colors.black)),
              ),
              Icon(icon, color: Colors.yellow, size: 32),
            ],
          ),
        ],
      ),
    );
  }
}
