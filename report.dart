import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reports and Statements',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            // Title: Account activity reports
            Text(
              'Account activity reports',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Generate and download custom CSV files for your individual or retirement account activity. Futures activity is not available.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 10),

            // Reports option
            _buildOptionTile(title: "Reports"),

            SizedBox(height: 20),

            // Title: Monthly Statements
            Text(
              'Monthly statements',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'PDF statements are available within the first 2 weeks of the following month.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 10),

            _buildOptionTile(title: "Individual"),
            _buildOptionTile(title: "Futures & event contracts"),

            SizedBox(height: 20),

            // Title: Daily Statements
            Text(
              'Daily statements',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'PDF statements are available within 1 business day after market close.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 10),

            _buildOptionTile(title: "Futures & event contracts"),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({required String title}) {
    return Card(
      color: Colors.grey[900],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: () {
          // Handle navigation or actions here
        },
      ),
    );
  }
}
