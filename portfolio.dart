import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile.dart';
import 'notification.dart';

// Enums
enum TransactionType { buy, sell }
enum HoldingType { stock, crypto, forex }

// Models
class Transaction {
  final String id;
  final TransactionType type;
  final String symbol;
  final String name;
  final double amount;
  final double shares;
  final DateTime date;
  final String currency;

  Transaction({
    required this.id,
    required this.type,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.shares,
    required this.date,
    required this.currency,
  });
}

class Holding {
  final String symbol;
  final String name;
  final double value;
  final double change;
  final double changePercentage;
  final IconData icon;
  final HoldingType type;

  Holding({
    required this.symbol,
    required this.name,
    required this.value,
    required this.change,
    required this.changePercentage,
    required this.icon,
    required this.type,
  });
}

// Main App
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  bool _showBalance = false;
  final List<Transaction> transactions = [
    Transaction(
      id: '1',
      type: TransactionType.buy,
      symbol: 'TSLA',
      name: 'Tesla, Inc.',
      amount: 244.40,
      shares: 10,
      date: DateTime.now().subtract(Duration(days: 1)),
      currency: 'USD',
    ),
    Transaction(
      id: '2',
      type: TransactionType.sell,
      symbol: 'AMRI',
      name: 'PT. Atma Merapi',
      amount: 3867.00,
      shares: 100,
      date: DateTime.now().subtract(Duration(days: 2)),
      currency: 'IDR',
    ),
  ];

  final List<Holding> holdings = [
    Holding(
      symbol: 'IDR/USD',
      name: 'Rupiah / U.S. Dollar',
      value: 139.3550,
      change: 0.0025,
      changePercentage: 0.36,
      icon: Icons.currency_exchange,
      type: HoldingType.forex,
    ),
    Holding(
      symbol: 'TSLA',
      name: 'Tesla, Inc.',
      value: 244.40,
      change: 9.54,
      changePercentage: 4.06,
      icon: Icons.directions_car,
      type: HoldingType.stock,
    ),
  ];

  final List<Holding> watchlist = [
    Holding(
      symbol: 'NVDA',
      name: 'NVIDIA Corporation',
      value: 721.28,
      change: 15.43,
      changePercentage: 2.18,
      icon: Icons.memory,
      type: HoldingType.stock,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Portfolio'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceSection(),
                SizedBox(height: 16),
              //  _buildPortfolioValueCard(),
                //SizedBox(height: 24),
                _buildPerformanceSection(),
                SizedBox(height: 28),
                _buildQuickActions(),
                SizedBox(height: 24),
                _buildTransactionHistory(),
                SizedBox(height: 24),
                _buildHoldingsSection(),
                SizedBox(height: 24),
                _buildWatchlistSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return GestureDetector(
      onTap: () => setState(() => _showBalance = !_showBalance),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Icon(
                  _showBalance ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _showBalance ? '\$5,000.00' : '••••••••',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioValueCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(124, 24, 20, 34),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Value',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            _showBalance ? '\$15,900.00' : '••••••••',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPortfolioStat('24h Change', '+\$234.56', true),
              _buildPortfolioStat('Total Profit', '+\$7,950.00', true),
              _buildPortfolioStat('Return', '+50.5%', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioStat(String label, String value, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceSection() {
    return CombinedPortfolioPerformance(showBalance: _showBalance);
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.add_circle_outline, 'Deposit'),
        _buildActionButton(Icons.shopping_cart_outlined, 'Buy'),
        _buildActionButton(Icons.sell_outlined, 'Sell'),
        _buildActionButton(Icons.swap_horiz_outlined, 'Transfer'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }









  //transaction
  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...transactions.map((transaction) => _buildTransactionItem(transaction)),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    bool isPositive = transaction.type == TransactionType.sell;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(124, 24, 20, 34),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction.type == TransactionType.buy
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: isPositive ? Colors.greenAccent : Colors.redAccent,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.type == TransactionType.buy ? 'Bought' : 'Sold'} ${transaction.symbol}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${transaction.shares} shares @ ${transaction.currency}${transaction.amount}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.currency}${(transaction.amount * transaction.shares).toStringAsFixed(2)}',
                style: TextStyle(
                  color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transaction.date.toString().substring(0, 10),
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }











  Widget _buildHoldingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Holdings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...holdings.map((holding) => _buildHoldingItem(holding)),
      ],
    );
  }









  Widget _buildWatchlistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Watchlist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Add More',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...watchlist.map((holding) => _buildHoldingItem(holding)),
      ],
    );
  }
  Widget _buildHoldingItem(Holding holding) {
    bool isPositive = holding.change >= 0;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(124, 24, 20, 34),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getTypeColor(holding.type).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              holding.icon,
              color: _getTypeColor(holding.type),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  holding.name,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${holding.value.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? Colors.greenAccent : Colors.redAccent,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${holding.change.toStringAsFixed(2)} (${holding.changePercentage.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      color: isPositive ? Colors.greenAccent : Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Color _getTypeColor(HoldingType type) {
    switch (type) {
      case HoldingType.stock:
        return Colors.blueAccent;
      case HoldingType.crypto:
        return Colors.orangeAccent;
      case HoldingType.forex:
        return Colors.greenAccent;
      default:
        return Colors.white;
    }
  }
}



class _PortfolioPerformanceData {
  final String timeframe;
  final double portfolioValue;
  final List<FlSpot> spots;

  _PortfolioPerformanceData({
    required this.timeframe,
    required this.portfolioValue,
    required this.spots,
  });

  /// Calculates total profit and return percentage based on a target value.
  Map<String, double> calculateProfitAndReturn(double targetValue) {
    if (spots.isEmpty || spots.first.y == 0) return {"profit": 0, "return": 0};
    double totalProfit = targetValue - spots.first.y;
    double returnPercentage = (totalProfit / spots.first.y) * 100;
    return {"profit": totalProfit, "return": returnPercentage};
  }

  /// Calculates the dynamic 24h change based on the tapped spot.
  double calculateChange24h(double tappedX) {
    if (spots.isEmpty) return 0;

    FlSpot tappedSpot = spots.reduce(
            (prev, curr) => (curr.x - tappedX).abs() < (prev.x - tappedX).abs() ? curr : prev);

    if (timeframe == "1D") {
      return tappedSpot.y - spots.first.y;
    }

    FlSpot? previousSpot = spots.where((spot) => spot.x <= tappedSpot.x - 1).fold<FlSpot?>(null, (prev, curr) {
      if (prev == null) return curr;
      return (tappedSpot.x - 1 - curr.x).abs() < (tappedSpot.x - 1 - prev.x).abs() ? curr : prev;
    });

    return previousSpot != null ? tappedSpot.y - previousSpot.y : 0;
  }
}

class CombinedPortfolioPerformance extends StatefulWidget {
  final bool showBalance;

  const CombinedPortfolioPerformance({Key? key, required this.showBalance}) : super(key: key);

  @override
  CombinedPortfolioPerformanceState createState() => CombinedPortfolioPerformanceState();
}

class CombinedPortfolioPerformanceState extends State<CombinedPortfolioPerformance> {
  String selectedTimeframe = "1D";
  double selectedValue = 0;
  String selectedDate = "";
  bool showGridLine = false;
  double gridLineX = 0;
  double? touchX;
  double? touchY;

  double liveProfit = 0;
  double liveReturnPercentage = 0;
  double liveChange24h = 0;


  final Map<String, _PortfolioPerformanceData> timeFrameData = {
    "1D": _PortfolioPerformanceData(
      timeframe: "1D",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 15665.44),    // 9:30 AM
        FlSpot(0.5, 15700.00),  // 10:15 AM
        FlSpot(1, 15750.00),    // 11:00 AM
        FlSpot(1.5, 15800.00),  // 11:45 AM
        FlSpot(2, 15850.00),    // 12:30 PM
        FlSpot(2.5, 15750.00),  // 1:15 PM
        FlSpot(3, 15800.00),    // 2:00 PM
        FlSpot(3.5, 15850.00),  // 2:45 PM
        FlSpot(4, 15900.00),    // 3:30 PM
        FlSpot(4.5, 15890.00),  // 4:00 PM
      ],
    ),
    "5D": _PortfolioPerformanceData(
      timeframe: "5D",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 15600.00),    // Day 1 Start
        FlSpot(0.4, 15650.00),  // Day 1 End
        FlSpot(0.8, 15700.00),  // Day 2 Start
        FlSpot(1.2, 15725.00),  // Day 2 End
        FlSpot(1.6, 15775.00),  // Day 3 Start
        FlSpot(2.0, 15800.00),  // Day 3 End
        FlSpot(2.4, 15825.00),  // Day 4 Start
        FlSpot(2.8, 15850.00),  // Day 4 End
        FlSpot(3.2, 15875.00),  // Day 5 Start
        FlSpot(3.6, 15890.00),  // Day 5 Mid
        FlSpot(4.0, 15900.00),  // Day 5 End
      ],
    ),
    "1M": _PortfolioPerformanceData(
      timeframe: "1M",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 15200.00),    // Week 1 Start
        FlSpot(0.5, 15300.00),  // Week 1 End
        FlSpot(1.0, 15400.00),  // Week 2 Start
        FlSpot(1.5, 15500.00),  // Week 2 End
        FlSpot(2.0, 15600.00),  // Week 3 Start
        FlSpot(2.5, 15700.00),  // Week 3 End
        FlSpot(3.0, 15800.00),  // Week 4 Start
        FlSpot(3.5, 15850.00),  // Week 4 End
        FlSpot(4.0, 15900.00),  // Month End
      ],
    ),
    "3M": _PortfolioPerformanceData(
      timeframe: "3M",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 14800.00),    // Month 1 Start
        FlSpot(0.5, 14900.00),  // Month 1 Mid
        FlSpot(1.0, 15000.00),  // Month 1 End
        FlSpot(1.5, 15200.00),  // Month 2 Start
        FlSpot(2.0, 15400.00),  // Month 2 Mid
        FlSpot(2.5, 15500.00),  // Month 2 End
        FlSpot(3.0, 15700.00),  // Month 3 Start
        FlSpot(3.5, 15800.00),  // Month 3 Mid
        FlSpot(4.0, 15900.00),  // Month 3 End
      ],
    ),
    "6M": _PortfolioPerformanceData(
      timeframe: "6M",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 14500.00),    // Month 1
        FlSpot(0.7, 14700.00),  // Month 2
        FlSpot(1.4, 14900.00),  // Month 3
        FlSpot(2.1, 15200.00),  // Month 4
        FlSpot(2.8, 15500.00),  // Month 5
        FlSpot(3.5, 15700.00),  // Month 5.5
        FlSpot(4.0, 15900.00),  // Month 6
      ],
    ),
    "YTD": _PortfolioPerformanceData(
      timeframe: "YTD",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 14000.00),    // January
        FlSpot(0.5, 14200.00),  // February
        FlSpot(1.0, 14500.00),  // March
        FlSpot(1.5, 14700.00),  // April
        FlSpot(2.0, 14900.00),  // May
        FlSpot(2.5, 15200.00),  // June
        FlSpot(3.0, 15400.00),  // July
        FlSpot(3.5, 15600.00),  // August
        FlSpot(4.0, 15900.00),  // September
      ],
    ),
    "1Y": _PortfolioPerformanceData(
      timeframe: "1Y",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 13500.00),    // Q1 Start
        FlSpot(0.5, 13800.00),  // Q1 Mid
        FlSpot(1.0, 14100.00),  // Q1 End
        FlSpot(1.5, 14400.00),  // Q2 Start
        FlSpot(2.0, 14700.00),  // Q2 Mid
        FlSpot(2.5, 15000.00),  // Q2 End
        FlSpot(3.0, 15300.00),  // Q3 Start
        FlSpot(3.5, 15600.00),  // Q3 Mid
        FlSpot(4.0, 15900.00),  // Q3 End
      ],
    ),
    "3Y": _PortfolioPerformanceData(
      timeframe: "3Y",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 12000.00),    // Year 1 Start
        FlSpot(0.5, 12500.00),  // Year 1 Mid
        FlSpot(1.0, 13000.00),  // Year 1 End
        FlSpot(1.5, 13500.00),  // Year 2 Start
        FlSpot(2.0, 14000.00),  // Year 2 Mid
        FlSpot(2.5, 14500.00),  // Year 2 End
        FlSpot(3.0, 15000.00),  // Year 3 Start
        FlSpot(3.5, 15500.00),  // Year 3 Mid
        FlSpot(4.0, 15900.00),  // Year 3 End
      ],
    ),
    "5Y": _PortfolioPerformanceData(
      timeframe: "5Y",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 10000.00),    // Year 1
        FlSpot(0.8, 11000.00),  // Year 2
        FlSpot(1.6, 12000.00),  // Year 3
        FlSpot(2.4, 13000.00),  // Year 4
        FlSpot(3.2, 14500.00),  // Year 4.5
        FlSpot(4.0, 15900.00),  // Year 5
      ],
    ),
    "MAX": _PortfolioPerformanceData(
      timeframe: "MAX",
      portfolioValue: 15900.00,
      spots: [
        FlSpot(0, 8000.00),     // 2019
        FlSpot(0.5, 9000.00),   // 2020
        FlSpot(1.0, 10000.00),  // 2021
        FlSpot(1.5, 11000.00),  // 2022
        FlSpot(2.0, 12000.00),  // 2023 Q1
        FlSpot(2.5, 13000.00),  // 2023 Q2
        FlSpot(3.0, 14000.00),  // 2023 Q3
        FlSpot(3.5, 15000.00),  // 2023 Q4
        FlSpot(4.0, 15900.00),  // 2024
      ],
    ),
  };

  _PortfolioPerformanceData get currentData => timeFrameData[selectedTimeframe]!;

  @override
  void initState() {
    super.initState();
    _updateMetrics(currentData.spots.last);
  }

  void _changeTimeFrame(String timeFrame) {
    setState(() {
      selectedTimeframe = timeFrame;
      selectedValue = currentData.portfolioValue;
      _updateMetrics(currentData.spots.last);
      selectedDate = "";
    });
  }

  void _updateMetrics(FlSpot spot) {
    final profitReturn = currentData.calculateProfitAndReturn(spot.y);
    final change24h = currentData.calculateChange24h(spot.x);

    liveProfit = profitReturn["profit"]!;
    liveReturnPercentage = profitReturn["return"]!;
    liveChange24h = change24h;
  }

  String getFormattedTime(String timeframe, double x) {
    switch (timeframe) {
      case "1D":
        final times = ["9:30 AM", "10:15 AM", "11:00 AM", "11:45 AM", "12:30 PM", "1:15 PM", "2:00 PM", "2:45 PM", "3:30 PM", "4:00 PM"];
        int index = (x * 2).round();
        return index < times.length ? times[index] : times.last;
      case "5D":
        return "Day ${(x + 1).round()}";
      case "1M":
        return "Week ${(x + 1).round()}";
      default:
        return x.toStringAsFixed(1);
    }
  }

  Widget _buildPortfolioStat(String label, String value, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeframeButton(String timeFrame) {
    final isSelected = selectedTimeframe == timeFrame;

    return GestureDetector(
      onTap: () => _changeTimeFrame(timeFrame),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          timeFrame,
          style: TextStyle(
            color: isSelected ? const Color.fromARGB(124, 24, 20, 34) : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Performance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color.fromARGB(124, 24, 20, 34), borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Portfolio Value', style: TextStyle(color: Colors.white70, fontSize: 14)),
              SizedBox(height: 8),
              Text(
                widget.showBalance ? '\$${selectedValue.toStringAsFixed(2)}' : '••••••••',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPortfolioStat('24h Change', '${liveChange24h >= 0 ? '+' : ''}\$${liveChange24h.toStringAsFixed(2)}', liveChange24h >= 0),
                  _buildPortfolioStat('Total Profit', '${liveProfit >= 0 ? '+' : ''}\$${liveProfit.toStringAsFixed(2)}', liveProfit >= 0),
                  _buildPortfolioStat('Return', '${liveReturnPercentage >= 0 ? '+' : ''}${liveReturnPercentage.toStringAsFixed(2)}%', liveReturnPercentage >= 0),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: showGridLine,
                    getDrawingVerticalLine: (value) => value == gridLineX
                        ? FlLine(color: Colors.white.withOpacity(0.2), strokeWidth: 1, dashArray: [5, 5])
                        : FlLine(color: Colors.transparent),
                    drawHorizontalLine: false,
                  ),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: currentData.spots,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [Colors.green.withOpacity(0.2), Colors.green.withOpacity(0.0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                      if ((event is FlPanDownEvent ||
                          event is FlPanUpdateEvent ||
                          event is FlTapDownEvent) &&
                          response?.lineBarSpots != null &&
                          response!.lineBarSpots!.isNotEmpty) {
                        final spot = response.lineBarSpots![0];
                        final profitReturn = currentData.calculateProfitAndReturn(spot.y);
                        final change24h = currentData.calculateChange24h(spot.x);

                        setState(() {
                          selectedValue = spot.y;
                          selectedDate = getFormattedTime(selectedTimeframe, spot.x);
                          liveProfit = profitReturn["profit"]!;
                          liveReturnPercentage = profitReturn["return"]!;
                          liveChange24h = change24h;
                          showGridLine = true;
                          gridLineX = spot.x;
                          touchX = event.localPosition?.dx;
                          touchY = event.localPosition?.dy;
                        });

                      } else if (event is FlPanEndEvent || event is FlTapUpEvent) {
                        final profitReturn = currentData.calculateProfitAndReturn(currentData.spots.last.y);
                        final change24h = currentData.calculateChange24h(currentData.spots.last.x);

                        setState(() {
                          selectedValue = currentData.portfolioValue;
                          selectedDate = "";
                          liveProfit = profitReturn["profit"]!;
                          liveReturnPercentage = profitReturn["return"]!;
                          liveChange24h = change24h;
                          showGridLine = false;
                          touchX = null;
                          touchY = null;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            if (touchX != null && touchY != null && selectedDate.isNotEmpty)
              Positioned(
                left: touchX! - 40,
                top: touchY! - 40,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    selectedDate,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: timeFrameData.keys.map((timeFrame) => _buildTimeframeButton(timeFrame)).toList(),
        ),
      ],
    );
  }
}