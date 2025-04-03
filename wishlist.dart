import 'package:flutter/material.dart';

class TradingDashboard extends StatefulWidget {
  @override
  _TradingDashboardState createState() => _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  TextEditingController wishlistController = TextEditingController();
  String selectedWishlist = "My First List"; // Default wishlist

  // Wishlist Categories
  List<String> wishlists = [
    "Options Watchlist",
    "My First List",
    "Cryptos to Watch"
  ];
  Map<String, int> watchlistItems = {
    "Options Watchlist": 0,
    "My First List": 16,
    "Cryptos to Watch": 4
  };
  Map<String, IconData> watchlistIcons = {
    "Options Watchlist": Icons.visibility,
    "My First List": Icons.flash_on,
    "Cryptos to Watch": Icons.currency_bitcoin,
  };

  // This map holds the stocks in each wishlist.
  Map<String, List<Map<String, dynamic>>> wishlistStocks = {};

  // Dummy stock data
  final List<Map<String, dynamic>> allStocks = [
    {"name": "GOOGL", "fullName": "Alphabet Inc", "price": 2174.75, "change": 1.21},
    {"name": "BABA", "fullName": "Alibaba Group", "price": 79.25, "change": -2.13},
    {"name": "AAPL", "fullName": "Apple Inc", "price": 138.93, "change": -1.32},
    {"name": "MSFT", "fullName": "Microsoft Corporation", "price": 289.45, "change": 1.23},
    {"name": "TSLA", "fullName": "Tesla Inc", "price": 681.79, "change": 4.89},
    {"name": "AMZN", "fullName": "Amazon Inc", "price": 113.22, "change": 9.77},
    {"name": "NFLX", "fullName": "Netflix Inc", "price": 242.98, "change": 2.34},
    {"name": "META", "fullName": "Meta Platforms", "price": 169.15, "change": -0.45},
    {"name": "NVDA", "fullName": "Nvidia Corporation", "price": 453.12, "change": 3.75},
    {"name": "AMD", "fullName": "Advanced Micro Devices", "price": 125.65, "change": 1.92},
  ];

  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    // Initialize wishlistStocks for each wishlist
    for (String list in wishlists) {
      wishlistStocks[list] = [];
    }
  }

  // Search Function (Prioritizes First-Letter Matches)
  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      searchResults = allStocks
          .where((stock) =>
              stock["name"].toLowerCase().contains(query.toLowerCase()) ||
              stock["fullName"].toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Sort: First-letter matches come first
      searchResults.sort((a, b) {
        bool aStartsWith = a["name"].toLowerCase().startsWith(query.toLowerCase());
        bool bStartsWith = b["name"].toLowerCase().startsWith(query.toLowerCase());
        if (aStartsWith && !bStartsWith) return -1;
        if (bStartsWith && !aStartsWith) return 1;
        return a["name"].compareTo(b["name"]); // Default alphabetical sorting
      });
    });
  }

  void showAddWatchlistDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add New Watchlist",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: wishlistController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter watchlist name",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      if (wishlistController.text.isNotEmpty) {
                        setState(() {
                          String newList = wishlistController.text;
                          wishlists.add(newList);
                          watchlistItems[newList] = 0;
                          watchlistIcons[newList] = Icons.visibility;
                          wishlistStocks[newList] = []; // initialize empty list for stocks
                          wishlistController.clear();
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Add", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showWatchlistOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.bar_chart, color: Colors.white),
            ),
            title: Text("Create screener", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("Find your next trade with filters for price, volume, and other indicators", style: TextStyle(color: Colors.grey)),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("New", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.visibility, color: Colors.white),
            ),
            title: Text("Create watchlist", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("Keep an eye on investments you're interested in", style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pop(context);
              showAddWatchlistDialog();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text("Go back", style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // Function to add a stock to the current wishlist
  void addStockToCurrentWishlist(Map<String, dynamic> stock) {
    setState(() {
      // Initialize the list if it doesn't exist
      if (wishlistStocks[selectedWishlist] == null) {
        wishlistStocks[selectedWishlist] = [];
      }
      // Prevent duplicates
      if (!wishlistStocks[selectedWishlist]!.any((item) => item["name"] == stock["name"])) {
        wishlistStocks[selectedWishlist]!.add(stock);
        // Update the item count for the current wishlist
        watchlistItems[selectedWishlist] = wishlistStocks[selectedWishlist]!.length;
      }
      
      // Clear search after adding
      searchController.clear();
      searchResults = [];
      isSearching = false;
      
      // Show a confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${stock['name']} added to $selectedWishlist"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    });
  }
  
  // Switch selected watchlist
  void selectWatchlist(String watchlist) {
    setState(() {
      selectedWishlist = watchlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the selected watchlist has any stocks
    bool hasStocks = wishlistStocks[selectedWishlist] != null && wishlistStocks[selectedWishlist]!.isNotEmpty;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "\$6.07",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              "Investing",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Focus the search field when search icon is pressed
              FocusScope.of(context).requestFocus(FocusNode());
              Future.delayed(Duration(milliseconds: 100), () {
                FocusScope.of(context).requestFocus(
                  FocusNode()..requestFocus()
                );
                // Set the keyboard focus on the search field
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(FocusNode());
                searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: searchController.text.length),
                );
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF1C2127),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search stocks...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onChanged: performSearch,
                ),
              ),
            ),

            // Search Results
            if (isSearching && searchResults.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF1C2127),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length > 3 ? 3 : searchResults.length, // Limit results to prevent overflow
                  itemBuilder: (context, index) {
                    final stock = searchResults[index];
                    return ListTile(
                      leading: Icon(
                        stock["change"] >= 0 ? Icons.trending_up : Icons.trending_down,
                        color: stock["change"] >= 0 ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        stock["name"],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        stock["fullName"],
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "\$${stock["price"].toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: stock["change"] >= 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "${stock["change"] >= 0 ? "+" : ""}${stock["change"].toStringAsFixed(2)}%",
                              style: TextStyle(
                                color: stock["change"] >= 0 ? Colors.green : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => addStockToCurrentWishlist(stock),
                    );
                  },
                ),
              ),

            // Lists Header with Current Selected Watchlist
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lists",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Current: $selectedWishlist",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                    onPressed: () => showWatchlistOptions(),
                  ),
                ],
              ),
            ),

            // Watchlists
            Container(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wishlists.length,
                itemBuilder: (context, index) {
                  final watchlist = wishlists[index];
                  final itemCount = watchlistItems[watchlist] ?? 0;
                  final icon = watchlistIcons[watchlist] ?? Icons.list;
                  final isSelected = selectedWishlist == watchlist;
                  
                  return GestureDetector(
                    onTap: () => selectWatchlist(watchlist),
                    child: Container(
                      width: 140,
                      margin: EdgeInsets.only(left: 16, right: index == wishlists.length - 1 ? 16 : 0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.withOpacity(0.2) : Color(0xFF1C2127),
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected 
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: index == 0 ? Colors.grey[800] : (index == 1 ? Colors.amber[900] : Colors.purple[900]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: Colors.white, size: 18),
                          ),
                          SizedBox(height: 6),
                          Text(
                            watchlist, 
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "$itemCount items", 
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Current Watchlist Stocks
            Expanded(
              child: hasStocks 
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: wishlistStocks[selectedWishlist]!.length,
                    itemBuilder: (context, index) {
                      final stock = wishlistStocks[selectedWishlist]![index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF1C2127),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            stock["change"] >= 0 ? Icons.trending_up : Icons.trending_down,
                            color: stock["change"] >= 0 ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            stock["name"],
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            stock["fullName"],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${stock["price"].toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: stock["change"] >= 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "${stock["change"] >= 0 ? "+" : ""}${stock["change"].toStringAsFixed(2)}%",
                                  style: TextStyle(
                                    color: stock["change"] >= 0 ? Colors.green : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.grey, size: 48),
                        SizedBox(height: 16),
                        Text(
                          "No stocks in this list yet.",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Search and add stocks above.",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
            ),

            // Footer - Compact disclaimer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: Colors.black,
              child: Text(
                "For more information, view our disclosures. Options involve risk.",
                style: TextStyle(color: Colors.grey, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () => showWatchlistOptions(),
        ),
      ),
    );
  }
}
