import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Orders')),
      body: ListView(
        children: [
          _buildOrderItem('AAPL', 10, 150.5, 'Buy', 'Completed'),
          _buildOrderItem('TSLA', 5, 650.3, 'Sell', 'Pending'),
          _buildActivityHistoryItem(
            'Market Analysis',
            'AAPL price target increased to \$180 by analysts',
            '2025-03-20',
            Icons.trending_up,
            Colors.blue,
          ),
          _buildOrderItem('MSFT', 8, 320.75, 'Buy', 'Completed'),
          _buildActivityHistoryItem(
            'Dividend Announcement',
            'MSFT announces quarterly dividend of \$0.68 per share',
            '2025-03-19',
            Icons.attach_money,
            Colors.green,
          ),
          _buildOrderItem('GOOGL', 3, 2750.25, 'Buy', 'Cancelled'),
          _buildActivityHistoryItem(
            'Stock Split',
            'TSLA announces 5:1 stock split effective April 15',
            '2025-03-18',
            Icons.call_split,
            Colors.purple,
          ),
          _buildOrderItem('AMZN', 2, 3240.50, 'Sell', 'Completed'),
          _buildActivityHistoryItem(
            'Earnings Report',
            'AMZN Q1 earnings exceeded expectations by 15%',
            '2025-03-17',
            Icons.insert_chart,
            Colors.orange,
          ),
          _buildActivityHistoryItem(
            'Market Alert',
            'Major market indices down 2% on Fed announcement',
            '2025-03-16',
            Icons.warning,
            Colors.red,
          ),
          _buildOrderItem('META', 12, 225.80, 'Buy', 'Pending'),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
      String stock, int quantity, double price, String type, String status) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text('$stock - $type'),
        subtitle: Text('Quantity: $quantity | Price: \$$price'),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == 'Completed' ? Colors.green : Colors.orange,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityHistoryItem(
    String title,
    String description,
    String date,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: color.withOpacity(0.05),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(description),
            SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}