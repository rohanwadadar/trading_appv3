import 'package:flutter/material.dart';

class TradingDashboard extends StatefulWidget {
  @override
  _TradingDashboardState createState() => _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  TextEditingController wishlistController = TextEditingController();
  String selectedWishlist = "My Favorites"; // Default wishlist

  // Wishlist Categories
  List<String> wishlists = ["My Favorites", "Growth Stocks", "Dividend Stocks"];

  // Watchlist dummy data
  Map<String, List<Map<String, dynamic>>> categorizedWatchlists = {
    "My Favorites": [],
    "Growth Stocks": [],
    "Dividend Stocks": [],
  };

  // Dummy stock data (10 sets)
  final List<Map<String, dynamic>> allStocks = [
    {"name": "AAPL", "fullName": "Apple Inc", "price": 138.93, "change": -1.32},
    {"name": "MSFT", "fullName": "Microsoft Corporation", "price": 289.45, "change": 1.23},
    {"name": "GOOGL", "fullName": "Alphabet Inc", "price": 2174.75, "change": -0.21},
    {"name": "TSLA", "fullName": "Tesla Inc", "price": 681.79, "change": 4.89},
    {"name": "AMZN", "fullName": "Amazon Inc", "price": 113.22, "change": 9.77},
    {"name": "NFLX", "fullName": "Netflix Inc", "price": 242.98, "change": 2.34},
    {"name": "META", "fullName": "Meta Platforms", "price": 169.15, "change": -0.45},
    {"name": "NVDA", "fullName": "Nvidia Corporation", "price": 453.12, "change": 3.75},
    {"name": "BABA", "fullName": "Alibaba Group", "price": 79.25, "change": -2.13},
    {"name": "AMD", "fullName": "Advanced Micro Devices", "price": 125.65, "change": 1.92},
  ];

  List<Map<String, dynamic>> searchResults = [];

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

  // Add Stock to Wishlist
  void addToWishlist(Map<String, dynamic> stock) {
    if (!categorizedWatchlists[selectedWishlist]!.any((item) => item["name"] == stock["name"])) {
      setState(() {
        categorizedWatchlists[selectedWishlist]!.add(stock);
        searchController.clear();
        isSearching = false;
      });
    }
  }

  // Build Wishlist Selector
  Widget _buildWishlistSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: selectedWishlist,
          dropdownColor: Colors.black87,
          style: TextStyle(color: Colors.white),
          underline: Container(),
          items: wishlists.map((list) {
            return DropdownMenuItem(
              value: list,
              child: Text(list, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedWishlist = value!;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.black,
                title: Text("Add New Wishlist", style: TextStyle(color: Colors.white)),
                content: TextField(
                  controller: wishlistController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(hintText: "Enter wishlist name", hintStyle: TextStyle(color: Colors.grey)),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: Colors.white))),
                  TextButton(
                    onPressed: () {
                      if (wishlistController.text.isNotEmpty) {
                        setState(() {
                          wishlists.add(wishlistController.text);
                          categorizedWatchlists[wishlistController.text] = [];
                          wishlistController.clear();
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Add", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Build Search Bar
  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search stocks...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          filled: true,
          fillColor: Color(0xFF1C2127),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: performSearch,
      ),
    );
  }

  // Build Search Results
  Widget _buildSearchResults() {
    return isSearching && searchResults.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Color(0xFF1C2127),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: searchResults
                  .map(
                    (stock) => ListTile(
                      leading: Icon(Icons.trending_up, color: stock["change"] >= 0 ? Colors.green : Colors.red),
                      title: Text(stock["name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(stock["fullName"], style: TextStyle(color: Colors.grey[400])),
                      trailing: IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () => addToWishlist(stock),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : SizedBox.shrink();
  }

  // Build Wishlist Items (Compact UI)
  Widget _buildWatchlistItem(Map<String, dynamic> stock) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: stock["change"] >= 0 ? Colors.green : Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(stock["name"], style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Text("\$${stock["price"]}", style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _buildWishlistSelector(),
            _buildSearchBar(),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildSearchResults()),  // 🛠 Fix: Make search results scrollable
                  Expanded(
                    child: ListView(
                      children: categorizedWatchlists[selectedWishlist]!
                          .map((stock) => _buildWatchlistItem(stock))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
