import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'profile.dart';
import 'portfolio.dart';
import 'news.dart';
import 'newsmail.dart';
import 'stock.dart';
import 'stock_details.dart' as details;


class TrendingScreen extends StatefulWidget {
  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
   String apiKey = "XH0MOF8FACW6RR0L"; // Your API Key
  List<dynamic> newsData = [];
//news
  @override
  void initState() {
    super.initState();
    filteredStocks = allStocks;
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        "https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=AAPL&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        newsData = data["feed"] ?? []; // Extracting the news feed list
      });
    } else {
      print("Failed to load news");
    }
  }

 Widget _buildVerticalNewsList(BuildContext context) {
  return Container(
    child: newsData.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ) // Show loading indicator with theme color
        : ListView.builder(
            shrinkWrap: true, // Ensures it takes only required space
            physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
            itemCount: newsData.length > 5 ? 5 : newsData.length, // Limits display to 5 items
            itemBuilder: (context, index) {
              var newsItem = newsData[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetailScreen(newsItem: newsItem)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white24,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsItem["title"] ?? "No Title",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                newsItem["subtitle"] ?? newsItem["source"] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
  );
}

  void _showNewsDetail(Map<String, dynamic> newsItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(newsItem["title"] ?? "News Detail"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(newsItem["summary"] ?? "No Summary Available"),
              SizedBox(height: 10),
              Text("Sentiment Score: ${newsItem["sentiment_score"]}"),
              SizedBox(height: 10),
              newsItem["url"] != null
                  ? TextButton(
                      onPressed: () {
                        // Implement URL opening (e.g., using url_launcher package)
                      },
                      child: Text("Read More", style: TextStyle(color: Colors.blue)),
                    )
                  : Container(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
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

  String selectedTimeframe = '24 hour';
  String selectedCategory = 'Global';
  int _selectedIndex = 0; // For tracking the selected tab

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

  /*@override
  void initState() {
    super.initState();
    filteredStocks = allStocks;
  }
*/
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
            stock["name"]!.toLowerCase().startsWith(query.toLowerCase())) // Only matches stocks that start with the query
        .toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Color(0xFF1A237E).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SizedBox(height: 8),
              // Header with Title and Settings
              _buildHeader(),
              SizedBox(height: 20),
              SizedBox(height: 16),
              // Search Bar
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
              _buildCategoryTabs(),
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
                     builder: (context) => details.StockDetailsPage(stockName: stock["name"]!),

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

              SizedBox(height: 24),
              // Region Pills
              _buildRegionPills(),
              SizedBox(height: 20),

              // Market Indices Cards
              _buildMarketIndicesCards(),
              SizedBox(height: 24),
              SizedBox(height: 10),
              // Most Trending Stocks
              _buildSectionHeader('Most Traded Stocks'),
              _buildHorizontalStockList(),
              SizedBox(height: 10),
              

                    SizedBox(height: 24),

              /*/ Navigation Buttons
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
                      Icons.pie_chart, 'Events',
                    ),
                  ),
                 
                  _buildNavigationItem(Icons.show_chart, 'Indices'),
                  _buildNavigationItem(Icons.new_label, 'IPO',
                      iconColor: Colors.red),
                  _buildNavigationItem(Icons.equalizer, 'Equities'),
                ],
              ), */
              SizedBox(height: 24),
              
              
              
              
              
              
              
          
              SizedBox(height: 10),
              // Trending Section
             _buildTrendingSection(),
              SizedBox(height: 16),

              // Trending Stocks List
              _buildTrendingStocksList(),

              // See More Button
              _buildSeeMoreButton(),
              SizedBox(height: 24),

              // Gainers and Losers Section
              GainersLosersSection(),
              
              SizedBox(height: 16),
              _buildSeeMoreButton(),
              SizedBox(height: 24),
              

              // Recommendations Section
              // _buildRecommendationsSection(),
              SizedBox(height: 24),
               // Latest News
              _buildSectionHeadernews('Latest News'),
              // Call the updated Vertical News List function here
    _buildVerticalNewsList(context), 
            ],
          ),
        ),
      ),
    );
  }


Widget _buildSectionHeadernews(String title) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsMailScreen()), // Ensure NewsMailScreen is correctly defined in newmail.dart
      );
    },
    child: Padding(
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
          Icon(Icons.arrow_forward, color: Colors.blue),
        ],
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

Widget _buildHorizontalCards() {
  return Row(
    children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top Gainers', 
                    style: TextStyle(
                      color: Colors.green, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Icon(Icons.trending_up, color: Colors.green, size: 20)
                ],
              ),
              SizedBox(height: 10),
              Text('+12.5%', 
                style: TextStyle(
                  color: Colors.green, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(height: 5),
              Text('Market Insight', 
                style: TextStyle(
                  color: Colors.white54, 
                  fontSize: 12
                )
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top Losers', 
                    style: TextStyle(
                      color: Colors.red, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Icon(Icons.trending_down, color: Colors.red, size: 20)
                ],
              ),
              SizedBox(height: 10),
              Text('-8.3%', 
                style: TextStyle(
                  color: Colors.red, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(height: 5),
              Text('Market Insight', 
                style: TextStyle(
                  color: Colors.white54, 
                  fontSize: 12
                )
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildHorizontalStockList() {
  // Expanded stock data with more details
  final List<Map<String, dynamic>> dummyStocks = [
    {
      'name': 'BUKA', 
      'fullName': 'Bukalapak', 
      'price': '278.00', 
      'change': '+2.5%', 
      'color': Colors.green
    },
    {
      'name': 'BBN', 
      'fullName': 'Bank Negara', 
      'price': '4,630.00', 
      'change': '+0.8%', 
      'color': Colors.green
    },
    {
      'name': 'SDO', 
      'fullName': 'Sido Muncul', 
      'price': '24.00', 
      'change': '-1.2%', 
      'color': Colors.red
    },
    {
      'name': 'AAPL', 
      'fullName': 'Apple Inc', 
      'price': '150.00', 
      'change': '+0.5%', 
      'color': Colors.green
    },
    {
      'name': 'GOOGL', 
      'fullName': 'Alphabet', 
      'price': '2,800.00', 
      'change': '-0.3%', 
      'color': Colors.red
    },
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
             builder: (context) => details.StockDetailsPage(stockName: stock["name"]!),

              ),
            );
          },
          child: Container(
            width: 200,
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stock['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      stock['change'].contains('+') 
                        ? Icons.trending_up 
                        : Icons.trending_down,
                      color: stock['color'],
                      size: 20,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock['fullName'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp${stock['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          stock['change'],
                          style: TextStyle(
                            fontSize: 14,
                            color: stock['color'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
/*
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
              color: const Color.fromARGB(28, 0, 0, 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('News Info $index', style: TextStyle(color: Colors.white)),
          );
        },
      ),
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
  */

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Investing',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[850]?.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    List<String> categories = ['Global', 'Crypto', 'Mutual funds', 'CFD'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          bool isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 24),
              padding: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.green : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.grey,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRegionPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRegionPill('Asia', true),
          _buildRegionPill('Asia', false),
          _buildRegionPill('Eropa', false),
          _buildRegionPill('Amerika', false),
        ],
      ),
    );
  }

  Widget _buildRegionPill(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[850] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[850]!),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildMarketIndicesCards() {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMarketIndex('IH5G', '27,206.92', true, '+1.2%'),
          _buildMarketIndex('NIKKEI', '2,915.18', false, '-0.8%'),
          _buildMarketIndex('SENSEI', '14,863.10', true, '+2.1%'),
        ],
      ),
    );
  }

  Widget _buildMarketIndex(String name, String value, bool isPositive, String percentage) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                name,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildTrendingSection() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Top Intraday Stock',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StockPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[850]?.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                'See more',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _buildTrendingStocksList() {
    return Column(
      children: [
        _buildStockItem('ROTI', 'Nippon Indosari Tbk', '8600.00', '+50', '+3.23%', Colors.amber),
        _buildStockItem('GOTO', 'GoTo Gojek Tokopedia', '2421.05', '-121', '-20.6%', Colors.green),
        _buildStockItem('ABNB', 'Airbnb Inc', '5300.50', '+31', '+2.23%', Colors.red),
        _buildStockItem('UNVR', 'Unilever Indonesia', '3867.10', '-71', '-4.1%', Colors.blue),
        _buildStockItem('ADRO', 'Adaro Energy Indonesia', '3600.45', '+21', '+3.23%', Colors.grey),
      ],
    );
  }

  Widget _buildStockItem(String symbol, String name, String price, String change, String percentage, Color logoColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850]?.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: logoColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                symbol[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$change ($percentage)',
                style: TextStyle(
                  color: change.contains('-') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildRecommendationsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Recommendation',
  //         style: TextStyle(
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: _buildRecommendationCard(
  //               'NFLX',
  //               'Netflix, Inc',
  //               '2,122.340',
  //               '-0.201%',
  //               Colors.red,
  //               false,
  //             ),
  //           ),
  //           SizedBox(width: 12),
  //           Expanded(
  //             child: _buildRecommendationCard(
  //               'META',
  //               'Meta Platforms',
  //               '987.890',
  //               '+1.29%',
  //               Colors.blue,
  //               true,
  //             ),
  //           ),
  //           SizedBox(width: 12),
  //           Expanded(
  //             child: _buildRecommendationCard(
  //               'AMZN',
  //               'Amazon.com, Inc',
  //               '1,001.333',
  //               '-8.20%',
  //               Colors.orange,
  //               false,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildRecommendationCard(
  //   String symbol,
  //   String name,
  //   String price,
  //   String change,
  //   Color tagColor,
  //   bool isPositive,
  // ) {
  //   return Container(
  //     padding: EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[850]?.withOpacity(0.5),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //           decoration: BoxDecoration(
  //             color: tagColor,
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: Text(
  //             symbol,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           name,
  //           style: TextStyle(color: Colors.grey[400], fontSize: 12),
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         SizedBox(height: 4),
  //         Text(
  //           price,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //           ),
  //         ),
  //         Text(
  //           change,
  //           style: TextStyle(
  //             color: isPositive ? Colors.green : Colors.red,
  //             fontSize: 12,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSeeMoreButton() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'See More',
              style: TextStyle(color: Colors.green),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.green, size: 16),
          ],
        ),
      ),
    );
  }
}

class GainersLosersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context, title: 'Top Gainers'),
        SizedBox(height: 16),
        _buildStocksList(context, [
          _buildStockItem(context, 'TSLA', 'Tesla Inc', '1100.00', '+100', '+10.0%', Colors.green),
          _buildStockItem(context, 'AAPL', 'Apple Inc', '145.50', '+5', '+3.5%', Colors.green),
          _buildStockItem(context, 'MSFT', 'Microsoft Corp', '299.75', '+9', '+3.1%', Colors.green),
        ]),
        SizedBox(height: 20),
        _buildHeader(context, title: 'Top Losers'),
        SizedBox(height: 16),
        _buildStocksList(context, [
          _buildStockItem(context, 'NFLX', 'Netflix Inc', '390.00', '-50', '-11.0%', Colors.red),
          _buildStockItem(context, 'AMZN', 'Amazon Inc', '3200.00', '-150', '-4.5%', Colors.red),
          _buildStockItem(context, 'GOOG', 'Alphabet Inc', '2850.30', '-30', '-2.1%', Colors.red),
        ]),
      ],
    );
  }

  // Header with "See More" button
  Widget _buildHeader(BuildContext context, {required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StockPage()), // Navigate to full stock list
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[850]?.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'See more',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Builds a list of stocks
  Widget _buildStocksList(BuildContext context, List<Widget> stocks) {
    return Column(children: stocks);
  }

  // Single Stock Item - Now Clickable
  Widget _buildStockItem(BuildContext context, String symbol, String name, String price, String change, String percentChange, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => details.StockDetailsPage(stockName: symbol)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[850]?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Text(symbol, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(price, style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(change, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                Text(percentChange, style: TextStyle(color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
