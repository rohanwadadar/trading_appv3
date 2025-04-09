import 'package:flutter/material.dart';
import 'stock_details.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  String selectedFilter = 'Most Traded'; // Default filter

  // Dummy stock data (Replace with real API data later)
  final List<Map<String, dynamic>> allStocks = [
    {'symbol': 'AAPL', 'name': 'Apple Inc', 'price': 145.50, 'change': '+3.5%', 'volume': 500000},
    {'symbol': 'TSLA', 'name': 'Tesla Inc', 'price': 1100.00, 'change': '+10.0%', 'volume': 700000},
    {'symbol': 'AMZN', 'name': 'Amazon Inc', 'price': 3200.00, 'change': '-4.5%', 'volume': 400000},
    {'symbol': 'MSFT', 'name': 'Microsoft Corp', 'price': 299.75, 'change': '+3.1%', 'volume': 600000},
    {'symbol': 'NFLX', 'name': 'Netflix Inc', 'price': 390.00, 'change': '-11.0%', 'volume': 300000},
    {'symbol': 'GOOG', 'name': 'Alphabet Inc', 'price': 2850.30, 'change': '-2.1%', 'volume': 550000},
  ];

  List<Map<String, dynamic>> filteredStocks = [];

  @override
  void initState() {
    super.initState();
    filterStocks();
  }

  void filterStocks() {
    setState(() {
      if (selectedFilter == 'Most Traded') {
        filteredStocks = List.from(allStocks)
          ..sort((a, b) => b['volume'].compareTo(a['volume']));
      } else if (selectedFilter == 'Top Gainers') {
        filteredStocks = List.from(allStocks)
          ..sort((a, b) => double.parse(b['change'].replaceAll('%', ''))
              .compareTo(double.parse(a['change'].replaceAll('%', ''))));
      } else if (selectedFilter == 'Top Losers') {
        filteredStocks = List.from(allStocks)
          ..sort((a, b) => double.parse(a['change'].replaceAll('%', ''))
              .compareTo(double.parse(b['change'].replaceAll('%', ''))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Stocks', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Sorting Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Most Traded', 'Top Gainers', 'Top Losers'].map((filter) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                      filterStocks();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedFilter == filter ? Colors.green : Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStocks.length,
              itemBuilder: (context, index) {
                final stock = filteredStocks[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to Stock Details Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockDetailsPage(stockName: stock['symbol']),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[850]?.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.primaries[index % Colors.primaries.length],
                          child: Text(stock['symbol'][0], style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock['symbol'],
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(stock['name'], style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${stock['price']}',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              stock['change'],
                              style: TextStyle(
                                color: stock['change'].contains('-') ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
