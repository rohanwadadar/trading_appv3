
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'dart:async';

// // void main() {
// //   runApp(StockScreenerApp());
// // }

// // class StockScreenerApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Stock Screener',
// //       theme: ThemeData.dark().copyWith(
// //         colorScheme: ColorScheme.dark(
// //           primary: Colors.blue,
// //           secondary: Colors.blueAccent,
// //         ),
// //         scaffoldBackgroundColor: Colors.black,
// //       ),
// //       home: StockScreenerPage(),
// //       debugShowCheckedModeBanner: false,
// //     );
// //   }
// // }

// // class AlpacaApiService {
// //   static const String baseUrl = 'https://data.alpaca.markets';
// //   static const String apiKeyId = 'PK6O4W6SBWAVCTZKQRPC';
// //   static const String apiSecret = 'e1rimphcUKc7SmJv9N3gla0oiMPgP8sstxp0Vk7D';

// //   static Map<String, String> get headers => {
// //     'accept': 'application/json',
// //     'APCA-API-KEY-ID': apiKeyId,
// //     'APCA-API-SECRET-KEY': apiSecret,
// //   };

// //   // Get stock quotes for multiple symbols
// //   static Future<List<Map<String, dynamic>>> getStockQuotes(List<String> symbols) async {
// //     try {
// //       final symbolsParam = symbols.join(',');
// //       final url = '$baseUrl/v2/stocks/quotes/latest?symbols=$symbolsParam&feed=iex';
      
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: headers,
// //       );

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         final quotes = data['quotes'] as Map<String, dynamic>;
        
// //         List<Map<String, dynamic>> stockData = [];
        
// //         for (String symbol in symbols) {
// //           if (quotes.containsKey(symbol)) {
// //             final quote = quotes[symbol];
// //             stockData.add({
// //               'symbol': symbol,
// //               'price': quote['ap']?.toDouble() ?? quote['bp']?.toDouble() ?? 0.0,
// //               'bid': quote['bp']?.toDouble() ?? 0.0,
// //               'ask': quote['ap']?.toDouble() ?? 0.0,
// //               'bidSize': quote['bs']?.toInt() ?? 0,
// //               'askSize': quote['as']?.toInt() ?? 0,
// //               'timestamp': quote['t'] ?? '',
// //             });
// //           }
// //         }
        
// //         return stockData;
// //       } else {
// //         throw Exception('Failed to load stock quotes: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('Error fetching stock quotes: $e');
// //       return [];
// //     }
// //   }

// //   // Get historical bars for a symbol
// //   static Future<Map<String, dynamic>?> getHistoricalBars(String symbol, {
// //     String timeframe = '1min',
// //     int limit = 100,
// //   }) async {
// //     try {
// //       final endDate = DateTime.now().toIso8601String().split('T')[0];
// //       final startDate = DateTime.now().subtract(Duration(days: 365)).toIso8601String().split('T')[0];
      
// //       final url = '$baseUrl/v2/stocks/$symbol/bars?timeframe=$timeframe&start=$startDate&end=$endDate&limit=$limit&adjustment=raw&feed=iex&sort=desc';
      
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: headers,
// //       );

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         final bars = data['bars'] as List<dynamic>;
        
// //         if (bars.isNotEmpty) {
// //           final latestBar = bars.first;
// //           final previousBar = bars.length > 1 ? bars[1] : null;
          
// //           double currentPrice = latestBar['c']?.toDouble() ?? 0.0;
// //           double previousPrice = previousBar?['c']?.toDouble() ?? currentPrice;
// //           double change = currentPrice - previousPrice;
// //           double changePercent = previousPrice != 0 ? (change / previousPrice) * 100 : 0.0;
          
// //           // Calculate 52-week high/low
// //           double weekHigh52 = bars.map<double>((bar) => bar['h']?.toDouble() ?? 0.0).reduce((a, b) => a > b ? a : b);
// //           double weekLow52 = bars.map<double>((bar) => bar['l']?.toDouble() ?? double.infinity).reduce((a, b) => a < b ? a : b);
          
// //           return {
// //             'symbol': symbol,
// //             'price': currentPrice,
// //             'change': change,
// //             'changePercent': changePercent,
// //             'volume': latestBar['v']?.toInt() ?? 0,
// //             'high': latestBar['h']?.toDouble() ?? 0.0,
// //             'low': latestBar['l']?.toDouble() ?? 0.0,
// //             'open': latestBar['o']?.toDouble() ?? 0.0,
// //             'close': latestBar['c']?.toDouble() ?? 0.0,
// //             'weekHigh52': weekHigh52,
// //             'weekLow52': weekLow52,
// //             'timestamp': latestBar['t'] ?? '',
// //           };
// //         }
// //       }
// //       return null;
// //     } catch (e) {
// //       print('Error fetching historical bars for $symbol: $e');
// //       return null;
// //     }
// //   }

// //   // Get news for symbols
// //   static Future<List<Map<String, dynamic>>> getNews({
// //     List<String>? symbols,
// //     int limit = 50,
// //   }) async {
// //     try {
// //       String url = '$baseUrl/v1beta1/news?limit=$limit&sort=desc';
      
// //       if (symbols != null && symbols.isNotEmpty) {
// //         url += '&symbols=${symbols.join(',')}';
// //       }

// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: headers,
// //       );

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         final newsItems = data['news'] as List<dynamic>;
        
// //         return newsItems.map((item) => {
// //           'id': item['id'],
// //           'headline': item['headline'],
// //           'summary': item['summary'],
// //           'author': item['author'],
// //           'url': item['url'],
// //           'symbols': List<String>.from(item['symbols'] ?? []),
// //           'createdAt': item['created_at'],
// //           'updatedAt': item['updated_at'],
// //         }).toList();
// //       }
// //       return [];
// //     } catch (e) {
// //       print('Error fetching news: $e');
// //       return [];
// //     }
// //   }
// // }

// // class StockScreenerPage extends StatefulWidget {
// //   @override
// //   _StockScreenerPageState createState() => _StockScreenerPageState();
// // }

// // class _StockScreenerPageState extends State<StockScreenerPage> {
// //   TextEditingController searchController = TextEditingController();
// //   bool isSearching = false;
// //   bool isLoading = false;
// //   List<Map<String, dynamic>> filteredStocks = [];
// //   List<Map<String, dynamic>> allStocks = [];
  
// //   // Filter states
// //   Map<String, bool> selectedFilters = {};
// //   Map<String, dynamic> filterValues = {};
  
// //   // Popular stock symbols to fetch
// //   final List<String> popularSymbols = [
// //     'AAPL', 'MSFT', 'GOOGL', 'TSLA', 'NVDA', 'AMZN', 'META', 'NFLX',
// //     'SPY', 'QQQ', 'AMD', 'INTC', 'CRM', 'UBER', 'LYFT', 'SPOT',
// //     'SNAP', 'TWTR', 'ROKU', 'ZOOM', 'SHOP', 'SQ', 'PYPL', 'ADBE'
// //   ];

// //   // Company name mapping (since Alpaca API doesn't provide company names in basic quotes)
// //   final Map<String, String> companyNames = {
// //     'AAPL': 'Apple Inc',
// //     'MSFT': 'Microsoft Corporation',
// //     'GOOGL': 'Alphabet Inc',
// //     'TSLA': 'Tesla Inc',
// //     'NVDA': 'Nvidia Corporation',
// //     'AMZN': 'Amazon Inc',
// //     'META': 'Meta Platforms',
// //     'NFLX': 'Netflix Inc',
// //     'SPY': 'SPDR S&P 500 ETF',
// //     'QQQ': 'Invesco QQQ Trust',
// //     'AMD': 'Advanced Micro Devices',
// //     'INTC': 'Intel Corporation',
// //     'CRM': 'Salesforce Inc',
// //     'UBER': 'Uber Technologies',
// //     'LYFT': 'Lyft Inc',
// //     'SPOT': 'Spotify Technology',
// //     'SNAP': 'Snap Inc',
// //     'TWTR': 'Twitter Inc',
// //     'ROKU': 'Roku Inc',
// //     'ZOOM': 'Zoom Video Communications',
// //     'SHOP': 'Shopify Inc',
// //     'SQ': 'Block Inc',
// //     'PYPL': 'PayPal Holdings',
// //     'ADBE': 'Adobe Inc',
// //   };

// //   // Sector mapping
// //   final Map<String, String> sectorMapping = {
// //     'AAPL': 'Technology',
// //     'MSFT': 'Technology',
// //     'GOOGL': 'Technology',
// //     'TSLA': 'Consumer Cyclical',
// //     'NVDA': 'Technology',
// //     'AMZN': 'Consumer Cyclical',
// //     'META': 'Communication Services',
// //     'NFLX': 'Communication Services',
// //     'AMD': 'Technology',
// //     'INTC': 'Technology',
// //     'CRM': 'Technology',
// //     'UBER': 'Consumer Cyclical',
// //     'LYFT': 'Consumer Cyclical',
// //     'SPOT': 'Communication Services',
// //     'SNAP': 'Communication Services',
// //     'TWTR': 'Communication Services',
// //     'ROKU': 'Communication Services',
// //     'ZOOM': 'Technology',
// //     'SHOP': 'Technology',
// //     'SQ': 'Technology',
// //     'PYPL': 'Technology',
// //     'ADBE': 'Technology',
// //   };

// //   // Filter categories and options
// //   final Map<String, List<Map<String, dynamic>>> filterCategories = {
// //     "Price": [
// //       {"key": "price", "title": "Share price", "type": "range", "min": 0.0, "max": 1000.0},
// //       {"key": "changePercent", "title": "Daily % change", "type": "range", "min": -10.0, "max": 10.0},
// //       {"key": "weekHigh52", "title": "52-week high", "type": "range", "min": 0.0, "max": 1000.0},
// //       {"key": "weekLow52", "title": "52-week low", "type": "range", "min": 0.0, "max": 1000.0},
// //     ],
// //     "Market": [
// //       {"key": "sector", "title": "Sector", "type": "select", "options": ["Technology", "Consumer Cyclical", "Communication Services"]},
// //     ],
// //     "Technical": [
// //       {"key": "volume", "title": "Today's volume", "type": "range", "min": 0.0, "max": 200000000.0},
// //     ],
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadStockData();
// //   }

// //   Future<void> loadStockData() async {
// //     setState(() {
// //       isLoading = true;
// //     });

// //     try {
// //       List<Map<String, dynamic>> stockData = [];
      
// //       // Fetch data in batches to avoid API limits
// //       for (int i = 0; i < popularSymbols.length; i += 5) {
// //         final batch = popularSymbols.sublist(i, i + 5 > popularSymbols.length ? popularSymbols.length : i + 5);
        
// //         for (String symbol in batch) {
// //           final historicalData = await AlpacaApiService.getHistoricalBars(symbol);
          
// //           if (historicalData != null) {
// //             stockData.add({
// //               "name": symbol,
// //               "fullName": companyNames[symbol] ?? symbol,
// //               "price": historicalData['price'],
// //               "change": historicalData['changePercent'],
// //               "volume": historicalData['volume'],
// //               "high": historicalData['high'],
// //               "low": historicalData['low'],
// //               "open": historicalData['open'],
// //               "close": historicalData['close'],
// //               "weekHigh52": historicalData['weekHigh52'],
// //               "weekLow52": historicalData['weekLow52'],
// //               "sector": sectorMapping[symbol] ?? "Unknown",
// //               "timestamp": historicalData['timestamp'],
// //             });
// //           }
          
// //           // Small delay to avoid rate limiting
// //           await Future.delayed(Duration(milliseconds: 200));
// //         }
// //       }

// //       setState(() {
// //         allStocks = stockData;
// //         filteredStocks = List.from(allStocks);
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       print('Error loading stock data: $e');
// //       setState(() {
// //         isLoading = false;
// //       });
      
// //       // Show error message
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Failed to load stock data. Please check your internet connection.'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }

// //   void performSearch(String query) {
// //     setState(() {
// //       if (query.isEmpty) {
// //         isSearching = false;
// //         applyFilters();
// //       } else {
// //         isSearching = true;
// //         filteredStocks = allStocks
// //             .where((stock) =>
// //                 stock["name"].toLowerCase().contains(query.toLowerCase()) ||
// //                 stock["fullName"].toLowerCase().contains(query.toLowerCase()))
// //             .toList();
// //       }
// //     });
// //   }

// //   void applyFilters() {
// //     setState(() {
// //       filteredStocks = allStocks.where((stock) {
// //         // Apply all active filters
// //         for (String filterKey in selectedFilters.keys) {
// //           if (selectedFilters[filterKey] == true) {
// //             if (!matchesFilter(stock, filterKey)) {
// //               return false;
// //             }
// //           }
// //         }
// //         return true;
// //       }).toList();
// //     });
// //   }

// //   bool matchesFilter(Map<String, dynamic> stock, String filterKey) {
// //     var filterValue = filterValues[filterKey];
// //     if (filterValue == null) return true;

// //     switch (filterKey) {
// //       case "sector":
// //         return stock["sector"] == filterValue;
// //       default:
// //         if (filterValue is RangeValues) {
// //           double value = stock[filterKey]?.toDouble() ?? 0.0;
// //           return value >= filterValue.start && value <= filterValue.end;
// //         }
// //     }
// //     return true;
// //   }

// //   void showFiltersSheet() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.black,
// //       isScrollControlled: true,
// //       builder: (context) => DraggableScrollableSheet(
// //         initialChildSize: 0.9,
// //         maxChildSize: 0.95,
// //         minChildSize: 0.5,
// //         builder: (context, scrollController) => Container(
// //           decoration: BoxDecoration(
// //             color: Colors.black,
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
// //           ),
// //           child: Column(
// //             children: [
// //               // Header
// //               Container(
// //                 padding: EdgeInsets.all(16),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     GestureDetector(
// //                       onTap: () => Navigator.pop(context),
// //                       child: Icon(Icons.close, color: Colors.white),
// //                     ),
// //                     Text(
// //                       "Filters",
// //                       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //                     ),
// //                     GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           selectedFilters.clear();
// //                           filterValues.clear();
// //                         });
// //                         applyFilters();
// //                       },
// //                       child: Text(
// //                         "Clear all",
// //                         style: TextStyle(color: Colors.grey, fontSize: 16),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               // Filter content
// //               Expanded(
// //                 child: ListView(
// //                   controller: scrollController,
// //                   children: filterCategories.entries.map((category) {
// //                     return Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                           child: Text(
// //                             category.key,
// //                             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
// //                           ),
// //                         ),
// //                         ...category.value.map((filter) => _buildFilterItem(filter)).toList(),
// //                         SizedBox(height: 20),
// //                       ],
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //               // Bottom button
// //               Container(
// //                 padding: EdgeInsets.all(16),
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     Navigator.pop(context);
// //                     applyFilters();
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.white,
// //                     minimumSize: Size(double.infinity, 50),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(25),
// //                     ),
// //                   ),
// //                   child: Text(
// //                     "Show ${filteredStocks.length} items",
// //                     style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFilterItem(Map<String, dynamic> filter) {
// //     bool isSelected = selectedFilters[filter["key"]] == true;
    
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
// //       child: ListTile(
// //         title: Text(
// //           filter["title"],
// //           style: TextStyle(color: Colors.white, fontSize: 16),
// //         ),
// //         trailing: Icon(
// //           Icons.chevron_right,
// //           color: Colors.grey,
// //         ),
// //         onTap: () => _showFilterOptions(filter),
// //       ),
// //     );
// //   }

// //   void _showFilterOptions(Map<String, dynamic> filter) {
// //     if (filter["type"] == "select") {
// //       _showSelectFilter(filter);
// //     } else if (filter["type"] == "range") {
// //       _showRangeFilter(filter);
// //     }
// //   }

// //   void _showSelectFilter(Map<String, dynamic> filter) {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.black,
// //       builder: (context) => Container(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               filter["title"],
// //               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 16),
// //             ...filter["options"].map<Widget>((option) => ListTile(
// //               title: Text(option, style: TextStyle(color: Colors.white)),
// //               trailing: filterValues[filter["key"]] == option
// //                   ? Icon(Icons.check, color: Colors.blue)
// //                   : null,
// //               onTap: () {
// //                 setState(() {
// //                   selectedFilters[filter["key"]] = true;
// //                   filterValues[filter["key"]] = option;
// //                 });
// //                 Navigator.pop(context);
// //               },
// //             )).toList(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showRangeFilter(Map<String, dynamic> filter) {
// //     RangeValues currentRange = filterValues[filter["key"]] ?? 
// //         RangeValues(filter["min"], filter["max"]);
    
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.black,
// //       builder: (context) => StatefulBuilder(
// //         builder: (context, setModalState) => Container(
// //           padding: EdgeInsets.all(16),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 filter["title"],
// //                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 16),
// //               Text(
// //                 "${currentRange.start.toStringAsFixed(2)} - ${currentRange.end.toStringAsFixed(2)}",
// //                 style: TextStyle(color: Colors.grey, fontSize: 14),
// //               ),
// //               RangeSlider(
// //                 values: currentRange,
// //                 min: filter["min"],
// //                 max: filter["max"],
// //                 divisions: 100,
// //                 activeColor: Colors.blue,
// //                 inactiveColor: Colors.grey,
// //                 onChanged: (values) {
// //                   setModalState(() {
// //                     currentRange = values;
// //                   });
// //                 },
// //               ),
// //               SizedBox(height: 16),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: () => Navigator.pop(context),
// //                       style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
// //                       child: Text("Cancel", style: TextStyle(color: Colors.white)),
// //                     ),
// //                   ),
// //                   SizedBox(width: 16),
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         setState(() {
// //                           selectedFilters[filter["key"]] = true;
// //                           filterValues[filter["key"]] = currentRange;
// //                         });
// //                         Navigator.pop(context);
// //                       },
// //                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
// //                       child: Text("Apply", style: TextStyle(color: Colors.white)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     int activeFiltersCount = selectedFilters.values.where((v) => v == true).length;
    
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         elevation: 0,
// //         title: Text(
// //           "Stock Screener",
// //           style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.refresh, color: Colors.white),
// //             onPressed: loadStockData,
// //           ),
// //           if (activeFiltersCount > 0)
// //             Container(
// //               margin: EdgeInsets.only(right: 16),
// //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //               decoration: BoxDecoration(
// //                 color: Colors.blue,
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Text(
// //                 "$activeFiltersCount",
// //                 style: TextStyle(color: Colors.white, fontSize: 12),
// //               ),
// //             ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Search Bar
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Container(
// //               height: 50,
// //               decoration: BoxDecoration(
// //                 color: Color(0xFF2C2C2E),
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: TextField(
// //                 controller: searchController,
// //                 style: TextStyle(color: Colors.white),
// //                 decoration: InputDecoration(
// //                   hintText: "Search stocks...",
// //                   hintStyle: TextStyle(color: Colors.grey),
// //                   prefixIcon: Icon(Icons.search, color: Colors.grey),
// //                   border: InputBorder.none,
// //                   contentPadding: EdgeInsets.symmetric(vertical: 15),
// //                 ),
// //                 onChanged: performSearch,
// //               ),
// //             ),
// //           ),
          
// //           // Filter Button
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: ElevatedButton.icon(
// //                     onPressed: showFiltersSheet,
// //                     icon: Icon(Icons.tune, color: Colors.white),
// //                     label: Text(
// //                       activeFiltersCount > 0 
// //                           ? "Filters ($activeFiltersCount)" 
// //                           : "Filters",
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Color(0xFF2C2C2E),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
          
// //           SizedBox(height: 16),
          
// //           // Results
// //           Expanded(
// //             child: isLoading
// //                 ? Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         CircularProgressIndicator(color: Colors.blue),
// //                         SizedBox(height: 16),
// //                         Text(
// //                           "Loading stock data...",
// //                           style: TextStyle(color: Colors.grey, fontSize: 16),
// //                         ),
// //                       ],
// //                     ),
// //                   )
// //                 : filteredStocks.isEmpty
// //                     ? Center(
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Icon(Icons.search_off, color: Colors.grey, size: 48),
// //                             SizedBox(height: 16),
// //                             Text(
// //                               "No stocks match your criteria",
// //                               style: TextStyle(color: Colors.grey, fontSize: 16),
// //                             ),
// //                             Text(
// //                               "Try adjusting your filters",
// //                               style: TextStyle(color: Colors.grey, fontSize: 14),
// //                             ),
// //                           ],
// //                         ),
// //                       )
// //                     : ListView.builder(
// //                         padding: EdgeInsets.symmetric(horizontal: 16),
// //                         itemCount: filteredStocks.length,
// //                         itemBuilder: (context, index) {
// //                           final stock = filteredStocks[index];
// //                           return Container(
// //                             margin: EdgeInsets.only(bottom: 8),
// //                             decoration: BoxDecoration(
// //                               color: Color(0xFF1C1C1E),
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             child: ListTile(
// //                               leading: Container(
// //                                 width: 40,
// //                                 height: 40,
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.grey[800],
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 child: Center(
// //                                   child: Text(
// //                                     stock["name"].length >= 2 
// //                                         ? stock["name"].substring(0, 2)
// //                                         : stock["name"],
// //                                     style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontWeight: FontWeight.bold,
// //                                       fontSize: 12,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                               title: Text(
// //                                 stock["name"],
// //                                 style: TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                               subtitle: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     stock["fullName"],
// //                                     style: TextStyle(color: Colors.grey, fontSize: 12),
// //                                   ),
// //                                   Text(
// //                                     "Vol: ${(stock["volume"] / 1000000).toStringAsFixed(1)}M • ${stock["sector"]}",
// //                                     style: TextStyle(color: Colors.grey, fontSize: 11),
// //                                   ),
// //                                 ],
// //                               ),
// //                               trailing: Column(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 crossAxisAlignment: CrossAxisAlignment.end,
// //                                 children: [
// //                                   Text(
// //                                     "\$${stock["price"].toStringAsFixed(2)}",
// //                                     style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                   Container(
// //                                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                                     decoration: BoxDecoration(
// //                                       color: stock["change"] >= 0
// //                                           ? Colors.green.withOpacity(0.2)
// //                                           : Colors.red.withOpacity(0.2),
// //                                       borderRadius: BorderRadius.circular(4),
// //                                     ),
// //                                     child: Text(
// //                                       "${stock["change"] >= 0 ? "+" : ""}${stock["change"].toStringAsFixed(2)}%",
// //                                       style: TextStyle(
// //                                         color: stock["change"] >= 0 ? Colors.green : Colors.red,
// //                                         fontSize: 12,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:math';

// void main() => runApp(StockScreenerApp());

// class StockScreenerApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Finviz-like Stock Screener',
//       theme: ThemeData.dark(),
//       home: StockScreenerPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class StockScreenerPage extends StatefulWidget {
//   @override
//   _StockScreenerPageState createState() => _StockScreenerPageState();
// }

// class _StockScreenerPageState extends State<StockScreenerPage> {
//   TextEditingController searchController = TextEditingController();
//   List<Map<String, dynamic>> allStocks = [];
//   List<Map<String, dynamic>> filteredStocks = [];
//   bool isLoading = false;

//   // ---- Filter configuration ----
//   Map<String, dynamic> selectedFilters = {};

//   final Map<String, List<Map<String, dynamic>>> filterCategories = {
//     "Descriptive": [
//       {
//         "key": "sector",
//         "title": "Sector",
//         "type": "select",
//         "options": ["Technology", "Financial", "Consumer", "Industrial"]
//       },
//       {
//         "key": "marketCap",
//         "title": "Market Cap (\$B)",
//         "type": "range",
//         "min": 1.0,
//         "max": 3000.0
//       },
//     ],
//     "Valuation": [
//       {"key": "peRatio", "title": "P/E Ratio", "type": "range", "min": 0.0, "max": 100.0},
//       {"key": "pbRatio", "title": "P/B Ratio", "type": "range", "min": 0.0, "max": 30.0},
//     ],
//     "Growth": [
//       {"key": "epsGrowth", "title": "EPS Growth %", "type": "range", "min": -50.0, "max": 200.0},
//     ],
//     "Technical": [
//       {"key": "smaPosition", "title": "Price vs SMA 50d", "type": "select", "options": ["Above", "Below", "Any"]},
//       {"key": "rsi", "title": "RSI(14)", "type": "range", "min": 0.0, "max": 100.0},
//       {"key": "volume", "title": "Volume (M)", "type": "range", "min": 0.0, "max": 200.0},
//     ],
//   };

//   // ---- Sample stock list; Replace with real tickers for real-world
//   final List<String> stockSymbols = [
//     "AAPL", "MSFT", "GOOGL", "TSLA", "NVDA", "JPM", "DIS", "BA", "KO", "AMD", "NFLX"
//   ];

//   // ---- Company names & sectors (demo only)
//   final Map<String, String> companyNames = {
//     "AAPL": "Apple Inc.",
//     "MSFT": "Microsoft",
//     "GOOGL": "Alphabet",
//     "TSLA": "Tesla",
//     "NVDA": "Nvidia",
//     "JPM": "JP Morgan",
//     "DIS": "Disney",
//     "BA": "Boeing",
//     "KO": "Coca-Cola",
//     "AMD": "AMD",
//     "NFLX": "Netflix"
//   };

//   final Map<String, String> companySectors = {
//     "AAPL": "Technology",
//     "MSFT": "Technology",
//     "GOOGL": "Technology",
//     "TSLA": "Consumer",
//     "NVDA": "Technology",
//     "JPM": "Financial",
//     "DIS": "Consumer",
//     "BA": "Industrial",
//     "KO": "Consumer",
//     "AMD": "Technology",
//     "NFLX": "Technology"
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchStockData();
//   }

//   Future<void> fetchStockData() async {
//     setState(() => isLoading = true);
//     await Future.delayed(Duration(milliseconds: 800));

//     // ---- Mock stock data: Use real API for real app ----
//     Random rng = Random();
//     List<Map<String, dynamic>> stocks = [];

//     for (final symbol in stockSymbols) {
//       double price = 10 + rng.nextInt(1000) + rng.nextDouble();
//       double shares = (100e6 + rng.nextInt(3000) * 1e6);
//       double marketCap = (price * shares) / 1e9; // in billions
//       double pe = 5 + rng.nextDouble() * 40;
//       double pb = 1 + rng.nextDouble() * 15;
//       double epsGrowth = -5 + rng.nextDouble() * 60;
//       double sma = price * (0.98 + 0.04 * rng.nextDouble());
//       String smaPosition = (price > sma) ? "Above" : "Below";
//       double rsi = 30 + rng.nextDouble() * 70;
//       double volume = 1 + rng.nextDouble() * 150; // in millions
//       stocks.add({
//         "symbol": symbol,
//         "name": companyNames[symbol] ?? symbol,
//         "sector": companySectors[symbol] ?? "Unknown",
//         "price": price,
//         "marketCap": marketCap,
//         "peRatio": pe,
//         "pbRatio": pb,
//         "epsGrowth": epsGrowth,
//         "smaPosition": smaPosition,
//         "rsi": rsi,
//         "volume": volume,
//       });
//     }

//     setState(() {
//       allStocks = stocks;
//       filteredStocks = List.from(allStocks);
//       isLoading = false;
//     });
//   }

//   void performSearch(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredStocks = applyAllFilters(allStocks);
//       } else {
//         filteredStocks = applyAllFilters(allStocks)
//           .where((stock) =>
//               stock["symbol"].toString().toLowerCase().contains(query.toLowerCase()) ||
//               stock["name"].toString().toLowerCase().contains(query.toLowerCase()))
//           .toList();
//       }
//     });
//   }

//   void showFilterSheet() {
//     showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.black,
//         isScrollControlled: true,
//         builder: (context) {
//           return DraggableScrollableSheet(
//             initialChildSize: 0.8,
//             minChildSize: 0.3,
//             maxChildSize: 0.95,
//             builder: (context, controller) => Container(
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(12))
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Row(
//                       children: [
//                         Expanded(
//                             child: Text("Filters",
//                                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
//                         ),
//                         GestureDetector(
//                             onTap: () {
//                               setState(() => selectedFilters.clear());
//                               Navigator.pop(context);
//                               performSearch(searchController.text);
//                             },
//                             child: Text("Clear all",
//                               style: TextStyle(color: Colors.blueAccent))
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView(
//                       controller: controller,
//                       children: filterCategories.entries.map((entry) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//                                 child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold))),
//                             ...entry.value.map((f) => buildFilterItem(f)).toList()
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   // Apply button
//                   Padding(
//                     padding: EdgeInsets.all(16),
//                     child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           performSearch(searchController.text);
//                         },
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(double.infinity, 45)),
//                         child: Text("Show ${applyAllFilters(allStocks).length} Stocks")
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   Widget buildFilterItem(Map<String, dynamic> filter) {
//     return ListTile(
//       title: Text(filter["title"]),
//       trailing: Icon(Icons.chevron_right, color: Colors.grey),
//       onTap: () {
//         if (filter["type"] == "select") {
//           showSelectFilter(filter);
//         } else if (filter["type"] == "range") {
//           showRangeFilter(filter);
//         }
//       }
//     );
//   }

//   void showSelectFilter(Map<String, dynamic> filter) {
//     String? current = selectedFilters[filter["key"]] as String?;
//     showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.black,
//         builder: (context) => Container(
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//             child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: filter["options"].map<Widget>((o) => ListTile(
//                       title: Text(o, style: TextStyle(color: Colors.white)),
//                       trailing: current == o ? Icon(Icons.check, color: Colors.blue) : null,
//                       onTap: () {
//                         setState(() => selectedFilters[filter["key"]] = o == "Any" ? null : o);
//                         Navigator.pop(context);
//                       },
//                     )).toList())));
//   }

//   void showRangeFilter(Map<String, dynamic> filter) {
//     RangeValues values = selectedFilters[filter["key"]] ??
//         RangeValues(filter["min"].toDouble(), filter["max"].toDouble());
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.black,
//       builder: (context) => StatefulBuilder(
//           builder: (context, setStateModal) {
//         return Container(
//           padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Text(filter["title"], style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(
//                 "${values.start.toStringAsFixed(2)} - ${values.end.toStringAsFixed(2)}",
//                 style: TextStyle(color: Colors.grey)),
//             RangeSlider(
//               values: values,
//               min: filter["min"].toDouble(),
//               max: filter["max"].toDouble(),
//               divisions: 100,
//               activeColor: Colors.blue,
//               inactiveColor: Colors.grey,
//               onChanged: (range) => setStateModal(() => values = range),
//             ),
//             Row(
//               children: [
//                 Expanded(child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text("Cancel", style: TextStyle(color: Colors.white))
//                 )),
//                 SizedBox(width: 8),
//                 Expanded(child: ElevatedButton(
//                     onPressed: () {
//                       setState(() => selectedFilters[filter["key"]] = values);
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: Text("Apply")
//                 )),
//               ],
//             )
//           ]),
//         );
//       })
//     );
//   }

//   // --- Utility to apply all filter logic to a stock list ---
//   List<Map<String, dynamic>> applyAllFilters(List<Map<String, dynamic>> input) {
//     return input.where((stock) {
//       for (var entry in selectedFilters.entries) {
//         if (entry.value == null) continue;
//         var key = entry.key;

//         // Select filter
//         if (entry.value is String) {
//           if (stock[key] != entry.value) return false;
//         }
//         // Range filter
//         if (entry.value is RangeValues) {
//           double val = stock[key]?.toDouble() ?? 0.0;
//           final range = entry.value as RangeValues;
//           if (val < range.start || val > range.end) return false;
//         }
//       }
//       return true;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double keyboardInset = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Stock Screener"),
//         actions: [
//           IconButton(icon: Icon(Icons.refresh), onPressed: fetchStockData),
//           IconButton(icon: Icon(Icons.tune), onPressed: showFilterSheet)
//         ]
//       ),
//       body: Column(
//         children: [
//           // Search Box
//           Padding(
//             padding: EdgeInsets.all(12),
//             child: TextField(
//               controller: searchController,
//               onChanged: performSearch,
//               decoration: InputDecoration(
//                 hintText: "Search by ticker or name...",
//                 prefixIcon: Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey[850],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none
//                 ),
//               ),
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           if (selectedFilters.values.any((v) => v != null))
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
//               child: Wrap(
//                 spacing: 8,
//                 children: selectedFilters.entries.where((element) => element.value != null).map((entry) {
//                   return Chip(
//                     label: Text("${entry.key}: ${entry.value is RangeValues ? "${(entry.value as RangeValues).start.toStringAsFixed(0)}~${(entry.value as RangeValues).end.toStringAsFixed(0)}" : entry.value.toString()}"),
//                     deleteIcon: Icon(Icons.close, size: 16),
//                     onDeleted: () {
//                       setState(() {
//                         selectedFilters[entry.key] = null;
//                         performSearch(searchController.text);
//                       });
//                     },
//                   );
//                 }).toList()
//               ),
//             ),
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : filteredStocks.isEmpty
//                     ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.sentiment_dissatisfied, color: Colors.grey, size: 52),
//                           SizedBox(height: 10),
//                           Text("No stocks match your filter", style: TextStyle(color: Colors.grey)),
//                         ],
//                       ),
//                     )
//                     : ListView.separated(
//                         itemCount: filteredStocks.length,
//                         separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[800]),
//                         itemBuilder: (context, idx) {
//                           final stk = filteredStocks[idx];
//                           return ListTile(
//                             contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
//                             leading: CircleAvatar(child: Text(stk["symbol"]), backgroundColor: Colors.blueGrey),
//                             title: Text(stk["name"], style: TextStyle(fontWeight: FontWeight.bold)),
//                             subtitle: Text("${stk["sector"]} • PE: ${stk["peRatio"].toStringAsFixed(1)} • Vol: ${stk["volume"].toStringAsFixed(1)}M"),
//                             trailing: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text("\$${stk["price"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
//                                 Text("MktCap \$${stk["marketCap"].toStringAsFixed(1)}B", style: TextStyle(fontSize: 12, color: Colors.grey)),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//           ),
//           SizedBox(height: keyboardInset)
//         ],
//       ),
//     );
//   }
// }















import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';

void main() => runApp(StockScreenerApp());

class StockScreenerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpaca Stock Screener',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: StockScreenerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AlpacaApiService {
  static const String baseUrl = 'https://data.alpaca.markets';
  static const String tradingUrl = 'https://paper-api.alpaca.markets';
  static const String apiKeyId = 'PK6O4W6SBWAVCTZKQRPC';
  static const String apiSecret = 'e1rimphcUKc7SmJv9N3gla0oiMPgP8sstxp0Vk7D';

  static Map<String, String> get headers => {
    'APCA-API-KEY-ID': apiKeyId,
    'APCA-API-SECRET-KEY': apiSecret,
    'accept': 'application/json',
  };

  /// Fetch all active US-equity assets with proper error handling
  static Future<List<Map<String, dynamic>>> getActiveAssets() async {
    try {
      final url = '$tradingUrl/v2/assets?status=active&asset_class=us_equity';
      print('Fetching assets from: $url'); // Debug log
      
      final response = await http.get(Uri.parse(url), headers: headers);
      print('Assets response status: ${response.statusCode}'); // Debug log
      
      if (response.statusCode == 200) {
        final list = json.decode(response.body) as List<dynamic>;
        return list
            .where((asset) => asset['tradable'] == true && asset['status'] == 'active')
            .take(100) // Limit to first 100 assets to avoid rate limits
            .map<Map<String, dynamic>>((asset) => {
                  'symbol': asset['symbol'],
                  'name': asset['name'] ?? asset['symbol'],
                  'exchange': asset['exchange'] ?? 'UNKNOWN',
                })
            .toList();
      } else {
        throw Exception('Assets API returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error fetching assets: $e');
      // Return fallback popular stocks if API fails
      return _getFallbackStocks();
    }
  }

  /// Get quotes for multiple symbols with chunking to avoid URL length limits
  static Future<Map<String, dynamic>> getLatestQuotes(List<String> symbols) async {
    try {
      // Chunk symbols to avoid URL length limits and rate limiting
      const chunkSize = 20;
      Map<String, dynamic> allQuotes = {};
      
      for (int i = 0; i < symbols.length; i += chunkSize) {
        final chunk = symbols.sublist(
          i, 
          (i + chunkSize > symbols.length) ? symbols.length : i + chunkSize
        );
        
        final symbolsParam = chunk.join(',');
        final url = '$baseUrl/v2/stocks/quotes/latest?symbols=$symbolsParam&feed=iex';
        print('Fetching quotes chunk ${i ~/ chunkSize + 1}: ${chunk.length} symbols'); // Debug log
        
        final response = await http.get(Uri.parse(url), headers: headers);
        print('Quotes response status: ${response.statusCode}'); // Debug log
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['quotes'] != null) {
            allQuotes.addAll(data['quotes'] as Map<String, dynamic>);
          }
        } else {
          print('Quotes API error ${response.statusCode}: ${response.body}');
        }
        
        // Rate limiting delay
        await Future.delayed(Duration(milliseconds: 300));
      }
      
      return allQuotes;
    } catch (e) {
      print('Error fetching quotes: $e');
      return {};
    }
  }

  /// Fallback stocks if API fails
  static List<Map<String, dynamic>> _getFallbackStocks() {
    return [
      {'symbol': 'AAPL', 'name': 'Apple Inc', 'exchange': 'NASDAQ'},
      {'symbol': 'MSFT', 'name': 'Microsoft Corporation', 'exchange': 'NASDAQ'},
      {'symbol': 'GOOGL', 'name': 'Alphabet Inc', 'exchange': 'NASDAQ'},
      {'symbol': 'TSLA', 'name': 'Tesla Inc', 'exchange': 'NASDAQ'},
      {'symbol': 'NVDA', 'name': 'NVIDIA Corporation', 'exchange': 'NASDAQ'},
      {'symbol': 'AMZN', 'name': 'Amazon.com Inc', 'exchange': 'NASDAQ'},
      {'symbol': 'META', 'name': 'Meta Platforms Inc', 'exchange': 'NASDAQ'},
      {'symbol': 'NFLX', 'name': 'Netflix Inc', 'exchange': 'NASDAQ'},
      {'symbol': 'AMD', 'name': 'Advanced Micro Devices', 'exchange': 'NASDAQ'},
      {'symbol': 'INTC', 'name': 'Intel Corporation', 'exchange': 'NASDAQ'},
    ];
  }
}

class StockScreenerPage extends StatefulWidget {
  @override
  _StockScreenerPageState createState() => _StockScreenerPageState();
}

class _StockScreenerPageState extends State<StockScreenerPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allStocks = [];
  List<Map<String, dynamic>> filteredStocks = [];
  bool isLoading = false;

  Map<String, dynamic> selectedFilters = {};

  final Map<String, List<Map<String, dynamic>>> filterCategories = {
    "Descriptive": [
      {
        "key": "sector",
        "title": "Sector",
        "type": "select",
        "options": ["Technology", "Healthcare", "Financial Services", "Consumer", "Industrial", "Other"]
      },
      {
        "key": "marketCap",
        "title": "Market Cap (\$B)",
        "type": "range",
        "min": 0.0,
        "max": 3000.0
      },
      {
        "key": "exchange",
        "title": "Exchange",
        "type": "select",
        "options": ["NASDAQ", "NYSE", "AMEX", "Other"]
      },
    ],
    "Valuation": [
      {"key": "peRatio", "title": "P/E Ratio", "type": "range", "min": 0.0, "max": 100.0},
      {"key": "pbRatio", "title": "P/B Ratio", "type": "range", "min": 0.0, "max": 30.0},
      {"key": "psRatio", "title": "P/S Ratio", "type": "range", "min": 0.0, "max": 50.0},
      {"key": "pegRatio", "title": "PEG Ratio", "type": "range", "min": 0.0, "max": 5.0},
    ],
    "Growth": [
      {"key": "epsGrowth", "title": "EPS Growth %", "type": "range", "min": -50.0, "max": 200.0},
      {"key": "revenueGrowth", "title": "Revenue Growth %", "type": "range", "min": -50.0, "max": 200.0},
    ],
    "Profitability": [
      {"key": "roe", "title": "ROE %", "type": "range", "min": -50.0, "max": 100.0},
      {"key": "roa", "title": "ROA %", "type": "range", "min": -50.0, "max": 50.0},
      {"key": "grossMargin", "title": "Gross Margin %", "type": "range", "min": 0.0, "max": 100.0},
      {"key": "netMargin", "title": "Net Margin %", "type": "range", "min": -50.0, "max": 50.0},
    ],
    "Technical": [
      {"key": "smaPosition", "title": "Price vs SMA 50d", "type": "select", "options": ["Above", "Below", "Any"]},
      {"key": "rsi", "title": "RSI(14)", "type": "range", "min": 0.0, "max": 100.0},
      {"key": "volume", "title": "Volume (M)", "type": "range", "min": 0.0, "max": 500.0},
      {"key": "beta", "title": "Beta", "type": "range", "min": -3.0, "max": 3.0},
      {"key": "volatility", "title": "Volatility %", "type": "range", "min": 0.0, "max": 200.0},
    ],
    "Price": [
      {"key": "price", "title": "Last Price (\$)", "type": "range", "min": 0.0, "max": 1000.0},
      {"key": "changePercent", "title": "Daily Change %", "type": "range", "min": -20.0, "max": 20.0},
      {"key": "weekHigh52", "title": "52W High (\$)", "type": "range", "min": 0.0, "max": 1000.0},
      {"key": "weekLow52", "title": "52W Low (\$)", "type": "range", "min": 0.0, "max": 1000.0},
    ],
  };

  // Sector mapping for known stocks
  final Map<String, String> sectorMapping = {
    'AAPL': 'Technology', 'MSFT': 'Technology', 'GOOGL': 'Technology',
    'TSLA': 'Consumer', 'NVDA': 'Technology', 'AMZN': 'Consumer',
    'META': 'Technology', 'NFLX': 'Technology', 'AMD': 'Technology',
    'INTC': 'Technology', 'JPM': 'Financial Services', 'BAC': 'Financial Services',
    'WMT': 'Consumer', 'JNJ': 'Healthcare', 'UNH': 'Healthcare',
    'PFE': 'Healthcare', 'XOM': 'Industrial', 'CVX': 'Industrial',
  };

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    setState(() => isLoading = true);
    
    try {
      print('Starting to fetch stock data...');
      
      // Get available assets
      final assets = await AlpacaApiService.getActiveAssets();
      print('Fetched ${assets.length} assets');
      
      if (assets.isEmpty) {
        throw Exception('No assets returned from API');
      }

      // Extract symbols for quote fetching
      final symbols = assets.map((asset) => asset['symbol'] as String).toList();
      print('Fetching quotes for ${symbols.length} symbols');
      
      // Get quotes data
      final quotes = await AlpacaApiService.getLatestQuotes(symbols);
      print('Received quotes for ${quotes.length} symbols');

      // Create enriched stock data with mock fundamental data
      final List<Map<String, dynamic>> stocks = [];
      final random = Random();
      
      for (final asset in assets) {
        final symbol = asset['symbol'] as String;
        final quote = quotes[symbol];
        
        // Get price from quote or use fallback
        double price = 0.0;
        double bid = 0.0;
        double ask = 0.0;
        int volume = 0;
        
        if (quote != null) {
          price = (quote['ap'] ?? quote['bp'] ?? 50.0 + random.nextDouble() * 100).toDouble();
          bid = (quote['bp'] ?? price * 0.999).toDouble();
          ask = (quote['ap'] ?? price * 1.001).toDouble();
          // volume = (quote['v'] ?? random.nextInt(1000000)).toInt();
        } else {
          // Fallback data if no quote available
          price = 50.0 + random.nextDouble() * 200;
          bid = price * 0.999;
          ask = price * 1.001;
        }

        // Generate mock fundamental data
        final mockData = _generateMockFundamentals(symbol, price, random);
        
        stocks.add({
          'symbol': symbol,
          'name': asset['name'],
          'exchange': asset['exchange'],
          'sector': sectorMapping[symbol] ?? 'Other',
          'price': price,
          'bid': bid,
          'ask': ask,
          'volume': (random.nextInt(50) + 1).toDouble(), // Volume in millions
          ...mockData,
        });
      }

      setState(() {
        allStocks = stocks;
        filteredStocks = List.from(allStocks);
        isLoading = false;
      });
      
      print('Successfully loaded ${stocks.length} stocks');
      
    } catch (e) {
      print('Error loading stock data: $e');
      setState(() => isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Map<String, dynamic> _generateMockFundamentals(String symbol, double price, Random random) {
    return {
      'marketCap': (price * (100 + random.nextInt(1000))) / 1000, // In billions
      'peRatio': 5 + random.nextDouble() * 40,
      'pbRatio': 0.5 + random.nextDouble() * 10,
      'psRatio': 0.5 + random.nextDouble() * 15,
      'pegRatio': 0.5 + random.nextDouble() * 3,
      'epsGrowth': -10 + random.nextDouble() * 100,
      'revenueGrowth': -5 + random.nextDouble() * 50,
      'roe': -10 + random.nextDouble() * 60,
      'roa': -5 + random.nextDouble() * 30,
      'grossMargin': 10 + random.nextDouble() * 70,
      'netMargin': -10 + random.nextDouble() * 40,
      'smaPosition': random.nextBool() ? 'Above' : 'Below',
      'rsi': 20 + random.nextDouble() * 60,
      'beta': -1 + random.nextDouble() * 3,
      'volatility': 10 + random.nextDouble() * 80,
      'changePercent': -5 + random.nextDouble() * 10,
      'weekHigh52': price * (1 + random.nextDouble() * 0.5),
      'weekLow52': price * (0.5 + random.nextDouble() * 0.3),
    };
  }

  double _val(Map s, String k) => (s[k] ?? 0).toDouble();
  bool _passesRange(double v, RangeValues r) => v >= r.start && v <= r.end;

  List<Map<String, dynamic>> applyAllFilters(List<Map<String, dynamic>> input) {
    return input.where((stock) {
      for (var entry in selectedFilters.entries) {
        final key = entry.key;
        final val = entry.value;
        if (val == null) continue;
        
        if (val is String) {
          if (stock[key] != val) return false;
        }
        if (val is RangeValues) {
          if (!_passesRange(_val(stock, key), val)) return false;
        }
      }
      return true;
    }).toList();
  }

  void performSearch(String text) {
    final base = applyAllFilters(allStocks);
    setState(() {
      filteredStocks = text.isEmpty
          ? base
          : base
              .where((s) =>
                  s['symbol'].toLowerCase().contains(text.toLowerCase()) ||
                  s['name'].toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  void showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (c) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        builder: (c2, ctrl) => Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Stock Filters',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilters.clear();
                          filteredStocks = List.from(allStocks);
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Clear All', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('${filteredStocks.length} stocks match your criteria', 
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  children: filterCategories.entries.expand((cat) {
                    return [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(cat.key,
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      ...cat.value.map(buildFilterItem),
                    ];
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filteredStocks = applyAllFilters(allStocks);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Show ${applyAllFilters(allStocks).length} Stocks'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 48)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterItem(Map<String, dynamic> f) {
    final key = f['key'] as String;
    final title = f['title'] as String;
    final type = f['type'] as String;
    final hasActiveFilter = selectedFilters.containsKey(key) && selectedFilters[key] != null;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasActiveFilter)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('✓', style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: () {
          if (type == 'select') {
            final options = List<String>.from(f['options']);
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.black,
              builder: (_) => Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    ...options.map((o) {
                      return ListTile(
                        title: Text(o, style: TextStyle(color: Colors.white)),
                        trailing: selectedFilters[key] == o 
                            ? Icon(Icons.check, color: Colors.blue) 
                            : null,
                        onTap: () {
                          setState(() => selectedFilters[key] = o);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          } else if (type == 'range') {
            RangeValues current = selectedFilters[key] ??
                RangeValues((f['min'] as num).toDouble(), (f['max'] as num).toDouble());
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.black,
              builder: (_) => StatefulBuilder(builder: (ctx, setM) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('${current.start.toStringAsFixed(1)} – ${current.end.toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.grey)),
                    RangeSlider(
                      values: current,
                      min: (f['min'] as num).toDouble(),
                      max: (f['max'] as num).toDouble(),
                      divisions: 100,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      onChanged: (r) => setM(() => current = r),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedFilters[key] = current);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: Text('Apply'),
                          ),
                        ),
                      ],
                    )
                  ]),
                );
              }),
            );
          }
        },
      ),
    );
  }

  Widget buildMiniChart(String trend) {
    return Container(
      width: 60,
      height: 30,
      child: CustomPaint(
        painter: MiniChartPainter(
          trend == "up" ? Colors.green : Colors.red, 
          trend == "up"
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        title: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Text("Stock Screener", style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchStockData,
          ),
          Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info section
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("${filteredStocks.length} stocks • Updated now", 
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by symbol or name',
                fillColor: Colors.grey[850],
                filled: true,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), 
                  borderSide: BorderSide.none
                ),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: performSearch,
            ),
          ),
          
          SizedBox(height: 12),
          
          // Add filter button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: showFilterSheet,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text("Add filter", style: TextStyle(color: Colors.white, fontSize: 14)),
                    if (selectedFilters.values.any((v) => v != null))
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${selectedFilters.values.where((v) => v != null).length}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Table header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[900],
            child: Row(
              children: [
                SizedBox(width: 30),
                Expanded(flex: 2, child: Text("Symbol", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500))),
                Expanded(flex: 2, child: Text("Sector", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500))),
                Expanded(flex: 2, child: Text("Price", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
                Expanded(flex: 2, child: Text("Market Cap", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
              ],
            ),
          ),
          
          // Stock list
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.orange),
                        SizedBox(height: 16),
                        Text("Loading stocks from Alpaca API...", 
                             style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : filteredStocks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sentiment_dissatisfied, color: Colors.grey, size: 52),
                            SizedBox(height: 10),
                            Text("No stocks match your filter", 
                                 style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredStocks.length,
                        itemBuilder: (context, idx) {
                          final stk = filteredStocks[idx];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: idx % 2 == 0 
                                  ? Colors.grey[900]!.withOpacity(0.3) 
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                // Index number
                                SizedBox(
                                  width: 30,
                                  child: Text("${idx + 1}", 
                                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                                ),
                                // Symbol and company name  
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(stk["symbol"], 
                                           style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                      Text(stk["name"].length > 20 
                                           ? stk["name"].substring(0, 20) + "..." 
                                           : stk["name"], 
                                           style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                // Sector
                                Expanded(
                                  flex: 2,
                                  child: Text(stk["sector"], 
                                      style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                                // Price
                                Expanded(
                                  flex: 2,
                                  child: Text("\$${stk["price"].toStringAsFixed(2)}", 
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right),
                                ),
                                // Market Cap
                                Expanded(
                                  flex: 2,
                                  child: Text("\$${stk["marketCap"].toStringAsFixed(1)}B", 
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                      textAlign: TextAlign.right),
                                ),
                              ],
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

// Custom painter for mini stock charts
class MiniChartPainter extends CustomPainter {
  final Color color;
  final bool isUpTrend;

  MiniChartPainter(this.color, this.isUpTrend);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final random = Random();
    
    // Generate points for the chart line
    final points = <Offset>[];
    
    for (int i = 0; i <= 8; i++) {
      final x = (size.width / 8) * i;
      double y;
      
      if (isUpTrend) {
        y = size.height * (0.8 - (i * 0.05) + (random.nextDouble() * 0.3));
      } else {
        y = size.height * (0.2 + (i * 0.05) + (random.nextDouble() * 0.3));
      }
      
      points.add(Offset(x, y.clamp(0.0, size.height)));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
