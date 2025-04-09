import 'package:flutter/material.dart';
import 'profile.dart'; // Import your profile screen here.
import 'topup.dart';
import 'treanding.dart';
import 'stock_details.dart'; // Import the new stock details page
import 'notification.dart';
import 'wishlist.dart' hide StockDetailsPage;
import 'portfolio.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _iconOpacityAnimation;

  final List<Widget> _screens = [
    DashboardContent(),
    TrendingScreen(),
    TopUpScreen(),
    TradingDashboard(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _sizeAnimation = Tween<double>(begin: 50, end: 70).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _iconOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  // search
List<Map<String, String>> allStocks = [
    {"name": "ibm", "logo": "https://logo.clearbit.com/ibm.com"},
    {"name": "BUKA", "logo": "https://logo.clearbit.com/amazon.com"},
    {"name": "Microsoft", "logo": "https://logo.clearbit.com/microsoft.com"},
    {"name": "Tesla", "logo": "https://logo.clearbit.com/tesla.com"},
    {"name": "GOOGL", "logo": "https://logo.clearbit.com/google.com"},
    {"name": "Netflix", "logo": "https://logo.clearbit.com/netflix.com"},
    {"name": "Meta", "logo": "https://logo.clearbit.com/meta.com"},
  ];

  List<Map<String, String>> filteredStocks = [];
  String searchQuery = "";
  bool isLoading = false;
void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
        _shrinkNavBar(); 
    });
  }

 void searchStocks(String query) {
  setState(() {
    searchQuery = query;
    filteredStocks = allStocks
        .where((stock) =>
            stock["name"]!.toLowerCase().startsWith(query.toLowerCase())) // Only matches stocks that start with the query
        .toList();
  });
}

  // search end 


  void _toggleNavBar() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

 
  void _shrinkNavBar() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex], // Main content stays in sync with navbar
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: _toggleNavBar,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: _isExpanded ? MediaQuery.of(context).size.width - 60 : 80,
                    height: _sizeAnimation.value,
                    margin: EdgeInsets.only(bottom: 15), // Slightly above bottom
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 31, 29, 37).withOpacity(0.9),
                      shape: _isExpanded ? BoxShape.rectangle : BoxShape.circle, // Ball when shrunk
                      borderRadius: _isExpanded ? BorderRadius.circular(60) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 12.0,
                          spreadRadius: 4,
                          offset: Offset(0, -8),
                        ),
                      ],
                    ),
                    child: _isExpanded
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            child: BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              backgroundColor: Colors.transparent,
                              selectedItemColor: Colors.greenAccent,
                              unselectedItemColor: Colors.grey.shade400,
                              currentIndex: _selectedIndex,
                              onTap: _onItemTapped,
                              elevation: 0,
                              items: [
                                BottomNavigationBarItem(
                                  icon: Opacity(
                                    opacity: _iconOpacityAnimation.value,
                                    child: Icon(Icons.home_filled, size: 20),
                                  ),
                                  label: 'Activity',
                                ),
                                BottomNavigationBarItem(
                                  icon: Opacity(
                                    opacity: _iconOpacityAnimation.value,
                                    child: Icon(Icons.trending_up_rounded, size: 20),
                                  ),
                                  label: 'Investing',
                                ),
                                BottomNavigationBarItem(
                                  icon: Opacity(
                                    opacity: _iconOpacityAnimation.value,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.account_balance_wallet_rounded, size: 22),
                                    ),
                                  ),
                                  label: 'Transact',
                                ),
                                BottomNavigationBarItem(
                                  icon: Opacity(
                                    opacity: _iconOpacityAnimation.value,
                                    child: Icon(Icons.favorite_rounded, size: 20),
                                  ),
                                  label: 'Wish List',
                                ),
                                BottomNavigationBarItem(
                                  icon: Opacity(
                                    opacity: _iconOpacityAnimation.value,
                                    child: Icon(Icons.person_rounded, size: 20),
                                  ),
                                  label: 'Profile',
                                ),


                                
                              ],
                            ),
                          )
                          
                        : Center(
                            child: Icon(Icons.menu, size: 22, color: Colors.white), // Small floating ball
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildPerformanceSection() {
  return CombinedPortfolioPerformance(showBalance: true);
}

// Enum definitions needed for the transactions and holdings
enum TransactionType { buy, sell }
enum HoldingType { stock, crypto, forex }

class Transaction {
  final String symbol;
  final double amount;
  final int shares;
  final TransactionType type;
  final DateTime date;
  final String currency;

  Transaction({
    required this.symbol,
    required this.amount,
    required this.shares,
    required this.type,
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
  final HoldingType type;
  final IconData icon;

  Holding({
    required this.symbol,
    required this.name,
    required this.value,
    required this.change,
    required this.changePercentage,
    required this.type,
    required this.icon,
  });
}

class DashboardContent extends StatefulWidget {
  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  List<Map<String, String>> allStocks = [
    {"name": "Apple", "logo": "https://logo.clearbit.com/apple.com"},
    {"name": "Amazon", "logo": "https://logo.clearbit.com/amazon.com"},
    {"name": "Microsoft", "logo": "https://logo.clearbit.com/microsoft.com"},
    {"name": "Tesla", "logo": "https://logo.clearbit.com/tesla.com"},
    {"name": "Google", "logo": "https://logo.clearbit.com/google.com"},
    {"name": "Netflix", "logo": "https://logo.clearbit.com/netflix.com"},
    {"name": "Meta", "logo": "https://logo.clearbit.com/meta.com"},
  ];

  // Add the missing data structures
  List<Transaction> transactions = [
    Transaction(
      symbol: 'AAPL',
      amount: 150.75,
      shares: 10,
      type: TransactionType.buy,
      date: DateTime.now().subtract(Duration(days: 5)),
      currency: '\$',
    ),
    Transaction(
      symbol: 'MSFT',
      amount: 240.50,
      shares: 5,
      type: TransactionType.sell,
      date: DateTime.now().subtract(Duration(days: 2)),
      currency: '\$',
    ),
    Transaction(
      symbol: 'GOOGL',
      amount: 2750.25,
      shares: 2,
      type: TransactionType.buy,
      date: DateTime.now().subtract(Duration(days: 1)),
      currency: '\$',
    ),
  ];

  List<Holding> holdings = [
    Holding(
      symbol: 'AAPL',
      name: 'Apple Inc.',
      value: 1507.50,
      change: 23.75,
      changePercentage: 1.58,
      type: HoldingType.stock,
      icon: Icons.phone_iphone,
    ),
    Holding(
      symbol: 'BTC',
      name: 'Bitcoin',
      value: 3625.00,
      change: -125.30,
      changePercentage: -3.34,
      type: HoldingType.crypto,
      icon: Icons.currency_bitcoin,
    ),
    Holding(
      symbol: 'EUR/USD',
      name: 'Euro/USD',
      value: 1250.75,
      change: 12.25,
      changePercentage: 0.98,
      type: HoldingType.forex,
      icon: Icons.currency_exchange,
    ),
  ];

  List<Holding> watchlist = [
    Holding(
      symbol: 'NVDA',
      name: 'NVIDIA Corporation',
      value: 275.50,
      change: 5.25,
      changePercentage: 1.94,
      type: HoldingType.stock,
      icon: Icons.memory,
    ),
    Holding(
      symbol: 'ETH',
      name: 'Ethereum',
      value: 1875.25,
      change: 45.75,
      changePercentage: 2.50,
      type: HoldingType.crypto,
      icon: Icons.auto_graph,
    ),
  ];

  List<Map<String, String>> filteredStocks = [];
  String searchQuery = "";
  bool isLoading = false;
String selectedTimeframe = '24 hour';
  String selectedCategory = 'Global';
  int _selectedIndex = 0; // For tracking the selected tab

  
 
  @override
  void initState() {
    super.initState();
    filteredStocks = allStocks;
  }

void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void searchStocks(String query) {
    setState(() {
      searchQuery = query;
      filteredStocks = allStocks
          .where((stock) =>
              stock["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
              radius: 16,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Hallo Rohan Wadadar',
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  },
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '2',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(124, 24, 20, 34),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Color(0xFF1A237E).withOpacity(0.8), // Dark blue gradient
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    // Search Bar
                    SizedBox(height: 16),
                /*//     TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search stocks...',
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor:
                            const Color.fromARGB(41, 0, 0, 0).withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: searchStocks,
                    ),

                    SizedBox(height: 8),

                    // Filtered Stock List
                    if (searchQuery.isNotEmpty && filteredStocks.isNotEmpty)
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: filteredStocks.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: const Color.fromARGB(54, 33, 33, 33),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    filteredStocks[index]["logo"]!,
                                  ),
                                ),
                                title: Text(
                                  filteredStocks[index]["name"]!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
*/
TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search stocks...',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: const Color.fromARGB(41, 0, 0, 0).withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: searchStocks,
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              // Category Tabs
              
              SizedBox(height: 16),
              // Filtered Stock List
          if (searchQuery.isNotEmpty) 
  SizedBox(
    height: 300,
    child: filteredStocks.isNotEmpty
        ? ListView.builder(
            itemCount: filteredStocks.length,
            itemBuilder: (context, index) {
              final stock = filteredStocks[index];

              return GestureDetector(
                onTap: () {
                  // Navigate to stock details page with API call
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                     builder: (context) => StockDetailsPage(stockName: stock["name"]!),

                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(54, 33, 33, 33),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(stock["logo"]!),
                    ),
                    title: Text(
                      stock["name"]!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text(
              "No results found",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
  ),
                    SizedBox(height: 14),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PortfolioPage(),
                              ),
                            );
                          },
                          child: _buildNavigationItem(
                            Icons.pie_chart,
                            'Events',
                          ),
                        ),
                        _buildNavigationItem(
                            Icons.currency_exchange, 'All stocks'),
                        _buildNavigationItem(Icons.show_chart, 'Indices'),
                        _buildNavigationItem(Icons.new_label, 'IPO',
                            iconColor: Colors.red),
                        _buildNavigationItem(Icons.equalizer, 'Equities'),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Welcome Text
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(124, 24, 20, 34),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Explore stock market trends and insights here!',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                     SizedBox(height: 24), SizedBox(height: 24),
                       _buildProfileBalance(),  // Profile Balance section at the top
                    SizedBox(height: 24),
                    SizedBox(height: 24),
                    _buildPerformanceSection(),
                    SizedBox(height: 24),
 

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
  _buildActionButton(Icons.add_circle_outline, 'Deposit', TopUpScreen()), // Navigates to topup.dart
  _buildActionButton(Icons.swap_horiz_outlined, 'Transfer', TopUpScreen()), // Also navigates to topup.dart
],


                    ),
                    
                    SizedBox(height: 24),
                    
                    // Transaction History Section
                    _buildTransactionHistory(),
                    
                    SizedBox(height: 24),
                    
                    // Holdings Section
                    _buildHoldingsSection(),
                    
                    SizedBox(height: 24),
                    
                    // Watchlist Section
                    _buildWatchlistSection(),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String label,
      {Color iconColor = Colors.white}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(41, 66, 66, 66),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              print('See Detail tapped for $title');
            },
            child: Text(
              'See Detail',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildActionButton(IconData icon, String label, Widget destination) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
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


  // Transaction History Section
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
        ...transactions.map((transaction) => _transitem(transaction)),
      ],
    );
  }

  Widget _transitem(Transaction transaction) {
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








double profileBalance = 12500.75; // Example balance, replace with actual data

Widget _buildProfileBalance() {
  return Container(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(124, 24, 20, 34),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Profile Balance",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "\$${profileBalance.toStringAsFixed(2)}", // Displaying balance
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
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

  // Holdings Section
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

  // Watchlist Section
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
              onPressed: () {   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TradingDashboard()),
                  );},
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

  Widget _buildHorizontalCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(124, 24, 20, 34),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gainer Info', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(124, 24, 20, 34),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loser Info', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalStockList() {
    // List of dummy stocks
    final List<Map<String, String>> dummyStocks = [
      {'name': 'BUKA', 'price': 'Rp278.00'},
      {'name': 'BBN', 'price': 'Rp4,630.00'},
      {'name': 'SDO', 'price': 'Rp24.00'},
      {'name': 'AAPL', 'price': 'Rp150.00'},
      {'name': 'GOOGL', 'price': 'Rp2,800.00'},
    ];

    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dummyStocks.length,
        itemBuilder: (context, index) {
          final stock = dummyStocks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockDetailsPage(stockName: stock['name']!),
                ),
              );
            },
            child: Container(
              width: 200,
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(124, 24, 20, 34),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    stock['price']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalNewsList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(124, 24, 20, 34),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('News Info $index', style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Market App',
      theme: ThemeData.dark(),
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}