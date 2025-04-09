import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'buy.dart';
import 'sell.dart';
import 'newsmail.dart';
import 'news.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Tracker',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
      ),
      home: StockDetailsPage(stockName: 'AAPL'),
    );
  }
}

// Candlestick data model
class CandlestickData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  CandlestickData({
    required this.time, 
    required this.open, 
    required this.high, 
    required this.low, 
    required this.close
  });
}


class StockDetailsPage extends StatefulWidget {
  final String stockName;

  StockDetailsPage({required this.stockName});

  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  //List<FlSpot> earningsData = [];
 // List<FlSpot> quarterlyEarningsData = [];
//List<FlSpot> stockData = [];
  
  List<dynamic> newsData = [];
 //  List<FlSpot> returnOnEquityData = [];  // ✅ Define missing fields
 // List<FlSpot> debtEquityRatioData = []; // ✅ Define missing fields
  //List<FlSpot> netProfitMarginData = []; // ✅ Define missing fields
  final String apiKey = 'CF7H37OIS5NWDTN3';
List<FlSpot> earningsData = [
    FlSpot(1, 2.5), FlSpot(2, 3.0), FlSpot(3, 3.5), FlSpot(4, 4.2),
    FlSpot(5, 4.8), FlSpot(6, 5.1), FlSpot(7, 5.5), FlSpot(8, 6.0),
  ];

  List<FlSpot> quarterlyEarningsData = [
    FlSpot(1, 2.0), FlSpot(2, 2.8), FlSpot(3, 3.2), FlSpot(4, 3.6),
    FlSpot(5, 4.0), FlSpot(6, 4.3), FlSpot(7, 4.7), FlSpot(8, 5.2),
  ];

  List<FlSpot> stockData = [
    FlSpot(1, 150), FlSpot(2, 155), FlSpot(3, 160), FlSpot(4, 165),
    FlSpot(5, 170), FlSpot(6, 175), FlSpot(7, 180), FlSpot(8, 190),
  ];

  List<FlSpot> returnOnEquityData = [
    FlSpot(1, 12.5), FlSpot(2, 13.0), FlSpot(3, 14.2), FlSpot(4, 15.5),
    FlSpot(5, 16.0), FlSpot(6, 16.8), FlSpot(7, 17.5), FlSpot(8, 18.0),
  ];

  List<FlSpot> debtEquityRatioData = [
    FlSpot(1, 1.2), FlSpot(2, 1.4), FlSpot(3, 1.3), FlSpot(4, 1.5),
    FlSpot(5, 1.6), FlSpot(6, 1.8), FlSpot(7, 1.7), FlSpot(8, 1.9),
  ];

  List<FlSpot> netProfitMarginData = [
    FlSpot(1, 8.0), FlSpot(2, 8.5), FlSpot(3, 9.0), FlSpot(4, 9.8),
    FlSpot(5, 10.5), FlSpot(6, 11.0), FlSpot(7, 11.8), FlSpot(8, 12.5),
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStockAndEarningsData();
    fetchNews();
  }

  Future<void> fetchStockAndEarningsData() async {
    final String symbol = widget.stockName;
    final String earningsUrl =
        'https://www.alphavantage.co/query?function=EARNINGS&symbol=$symbol&apikey=$apiKey';
    final String stockUrl =
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$apiKey';

    try {
      final earningsResponse = await http.get(Uri.parse(earningsUrl));
      final stockResponse = await http.get(Uri.parse(stockUrl));

      if (earningsResponse.statusCode == 200 && stockResponse.statusCode == 200) {
        final Map<String, dynamic> earningsDataJson = json.decode(earningsResponse.body);
        final Map<String, dynamic> stockDataJson = json.decode(stockResponse.body);
        final List<dynamic> annualEarnings = earningsDataJson['annualEarnings'];
        final List<dynamic> quarterlyEarnings = earningsDataJson['quarterlyEarnings'];
        final Map<String, dynamic> timeSeries = stockDataJson['Time Series (Daily)'];

        List<FlSpot> tempAnnualData = [];
        List<FlSpot> tempQuarterlyData = [];
        List<FlSpot> tempStockData = [];
        List<FlSpot> returnOnEquityData = [];
List<FlSpot> debtEquityRatioData = [];
List<FlSpot> netProfitMarginData = [];

        int annualIndex = 0;
        int quarterlyIndex = 0;
        int stockIndex = 0;

        for (var entry in annualEarnings.reversed) {
          double eps = double.parse(entry['reportedEPS']);
          tempAnnualData.add(FlSpot(annualIndex.toDouble(), eps));
          annualIndex++;
        }

        for (var entry in quarterlyEarnings.reversed) {
          double eps = double.parse(entry['reportedEPS']);
          tempQuarterlyData.add(FlSpot(quarterlyIndex.toDouble(), eps));
          quarterlyIndex++;
        }

        timeSeries.forEach((date, values) {
          double closePrice = double.parse(values['4. close']);
          tempStockData.add(FlSpot(stockIndex.toDouble(), closePrice));
          stockIndex++;
        });

        setState(() {
          earningsData = tempAnnualData;
          quarterlyEarningsData = tempQuarterlyData;
          stockData = tempStockData.reversed.toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load stock or earnings data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
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


  Future<void> fetchNews() async {
    final url = Uri.parse(
        "https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=AAPL&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        newsData = data["feed"] ?? [];
      });
    } else {
      print("Failed to load news");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stockName),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement stock search functionality
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StockGraph(
                    stockData: stockData,
                    stockName: widget.stockName,
                  ),
                  TimeRangeSelector(),
                  SizedBox(height: 20),
                  PerformanceSection(),
                  SizedBox(height: 20),
                  ExpertsRatingSection(),
                  SizedBox(height: 20),
                 FinancialSection(
  earningsData: earningsData,
  quarterlyEarningsData: quarterlyEarningsData,
  stockData: stockData,
  returnOnEquityData: returnOnEquityData,
  debtEquityRatioData: debtEquityRatioData,
  netProfitMarginData: netProfitMarginData,
),

                  SizedBox(height: 20),
                  CompanySellHistorySection(),
                  SizedBox(height: 20),
                  _buildRecommendationsSection(),
                  SizedBox(height: 30),
                   SizedBox(height: 24),
               // Latest News
              _buildSectionHeadernews('Latest News'),
              // Call the updated Vertical News List function here
    _buildVerticalNewsList(context), 
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: TradeButtons(),
      ),
    );
  }
}







class StockGraph extends StatefulWidget {
  final List<FlSpot> stockData;
  final String stockName;

  StockGraph({
    required this.stockData,
    required this.stockName,
  });

  @override
  _StockGraphState createState() => _StockGraphState();
}
// Update the _StockGraphState class

class _StockGraphState extends State<StockGraph> {
  double selectedValue = 0;
  String selectedTime = "";
  double? touchX;
  double? touchY;
  bool showCandlestick = false;
  
  // Add zoom-related state variables
  double zoomLevel = 1.0;
  double panOffset = 0.0;
  double maxZoom = 3.0;
  bool isZooming = false;
  
  // For candlestick selection
  CandlestickData? selectedCandlestick;

  @override
  void initState() {
    super.initState();
    if (widget.stockData.isNotEmpty) {
      selectedValue = widget.stockData.last.y;
    }
  }

  String getFormattedTime(double x) {
    final times = [
      "9:30 AM", "10:15 AM", "11:00 AM", "11:45 AM",
      "12:30 PM", "1:15 PM", "2:00 PM", "2:45 PM",
      "3:30 PM", "4:00 PM"
    ];
    int index = (x * 2).round();
    return index < times.length ? times[index] : times.last;
  }

  String getFormattedDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  double calculateDayChange(double currentValue) {
    if (widget.stockData.isEmpty) return 0;
    return currentValue - widget.stockData.first.y;
  }

  double calculatePercentageChange(double currentValue) {
    if (widget.stockData.isEmpty || widget.stockData.first.y == 0) return 0;
    return ((currentValue - widget.stockData.first.y) / widget.stockData.first.y) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final dayChange = calculateDayChange(selectedValue);
    final percentageChange = calculatePercentageChange(selectedValue);
    final isPositive = dayChange >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.stockName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Add row of buttons for chart controls
                  Row(
                    children: [
                      // Zoom controls
                      IconButton(
                        icon: Icon(Icons.zoom_in, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            if (zoomLevel < maxZoom) {
                              zoomLevel += 0.5;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.zoom_out, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            if (zoomLevel > 1.0) {
                              zoomLevel -= 0.5;
                            } else {
                              zoomLevel = 1.0;
                              panOffset = 0.0;
                            }
                          });
                        },
                      ),
                      // Chart type toggle
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showCandlestick = !showCandlestick;
                          });
                        },
                        icon: Icon(
                          showCandlestick ? Icons.show_chart : Icons.candlestick_chart,
                          color: Colors.white70,
                        ),
                        label: Text(
                          showCandlestick ? 'Line' : 'Candlestick',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '\$${selectedValue.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    'Day Change',
                    '${isPositive ? "+" : ""}\$${dayChange.toStringAsFixed(2)}',
                    isPositive,
                  ),
                  _buildStatItem(
                    '% Change',
                    '${isPositive ? "+" : ""}${percentageChange.toStringAsFixed(2)}%',
                    isPositive,
                  ),
                  _buildStatItem(
                    'Day\'s Low',
                    '\$${widget.stockData.map((e) => e.y).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)}',
                    true,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        GestureDetector(
          onHorizontalDragStart: (details) {
            setState(() {
              isZooming = true;
            });
          },
          onHorizontalDragUpdate: (details) {
            if (zoomLevel > 1.0) {
              setState(() {
                // Adjust panOffset based on drag, but limit to valid range
                panOffset += details.delta.dx;
                
                // Calculate the maximum allowed pan based on zoom level
                double maxPan = (widget.stockData.length * (zoomLevel - 1)).clamp(0.0, double.infinity);
                
                // Constrain panOffset to valid range
                panOffset = panOffset.clamp(-maxPan, 0.0);
              });
            }
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              isZooming = false;
            });
          },
          onScaleStart: (details) {
            setState(() {
              isZooming = true;
            });
          },
          onScaleUpdate: (details) {
            if (details.scale != 1.0) {
              setState(() {
                // Calculate new zoom level
                double newZoom = (zoomLevel * details.scale).clamp(1.0, maxZoom);
                
                // If we're zooming out completely, reset pan
                if (newZoom == 1.0) {
                  panOffset = 0.0;
                }
                
                zoomLevel = newZoom;
              });
            }
          },
          onScaleEnd: (details) {
            setState(() {
              isZooming = false;
            });
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                height: 250,
                child: showCandlestick
                    ? _buildCandlestickChart(isPositive)
                    : _buildLineChart(isPositive),
              ),
              if (touchX != null && touchY != null && selectedTime.isNotEmpty)
                Positioned(
                  left: touchX! - 80,
                  top: touchY! - 60,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedTime,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (selectedCandlestick != null && showCandlestick)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "O: \$${selectedCandlestick!.open.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                              Text(
                                "H: \$${selectedCandlestick!.high.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                              Text(
                                "L: \$${selectedCandlestick!.low.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                              Text(
                                "C: \$${selectedCandlestick!.close.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              // Zoom indicator
              if (zoomLevel > 1.0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${zoomLevel.toStringAsFixed(1)}x",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(bool isPositive) {
    // Apply zoom and pan to the data
    List<FlSpot> visibleData = [];
    if (zoomLevel > 1.0) {
      // Calculate visible range based on zoom and pan
      int totalPoints = widget.stockData.length;
      int visiblePoints = (totalPoints / zoomLevel).floor();
      
      // Calculate start index with panOffset
      int startIndex = (panOffset / zoomLevel).abs().floor();
      startIndex = startIndex.clamp(0, totalPoints - visiblePoints);
      
      // Get the visible subset
      List<FlSpot> zoomedData = widget.stockData.sublist(
        startIndex, 
        (startIndex + visiblePoints).clamp(0, totalPoints)
      );
      
      // Remap x values to start from 0
      for (int i = 0; i < zoomedData.length; i++) {
        visibleData.add(FlSpot(i.toDouble(), zoomedData[i].y));
      }
    } else {
      visibleData = widget.stockData;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: visibleData,
            isCurved: true,
            color: isPositive ? Colors.green : Colors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  (isPositive ? Colors.green : Colors.red).withOpacity(0.2),
                  (isPositive ? Colors.green : Colors.red).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
        lineTouchData: _getLineTouchData(),
      ),
    );
  }

  Widget _buildCandlestickChart(bool isPositive) {
    // Convert FlSpot data to candlestick format
    List<CandlestickData> candlestickData = [];
    
    // For demonstration, generate some sample candlestick data from line chart data
    if (widget.stockData.isNotEmpty) {
      for (int i = 0; i < widget.stockData.length; i++) {
        final value = widget.stockData[i].y;
        // Create OHLC data from the single value with some randomization
        final open = value * (1 - 0.005 * (i % 3 == 0 ? 1 : -1));
        final close = value * (1 + 0.003 * (i % 2 == 0 ? 1 : -1));
        final high = value * (1 + 0.01);
        final low = value * (1 - 0.01);
        
        candlestickData.add(CandlestickData(
          time: DateTime.now().subtract(Duration(days: widget.stockData.length - i - 1)),
          open: open,
          high: high,
          low: low,
          close: close,
        ));
      }
    }
    
    // Apply zoom and pan to the candlestick data
    List<CandlestickData> visibleCandlesticks = [];
    if (zoomLevel > 1.0) {
      // Calculate visible range based on zoom and pan
      int totalPoints = candlestickData.length;
      int visiblePoints = (totalPoints / zoomLevel).floor();
      
      // Calculate start index with panOffset
      int startIndex = (panOffset / zoomLevel).abs().floor();
      startIndex = startIndex.clamp(0, totalPoints - visiblePoints);
      
      // Get the visible subset
      visibleCandlesticks = candlestickData.sublist(
        startIndex, 
        (startIndex + visiblePoints).clamp(0, totalPoints)
      );
    } else {
      visibleCandlesticks = candlestickData;
    }

    return GestureDetector(
      onTapDown: (details) {
        _handleCandlestickTap(details.localPosition, visibleCandlesticks);
      },
      onPanUpdate: (details) {
        _handleCandlestickTap(details.localPosition, visibleCandlesticks);
      },
      onPanEnd: (details) {
        setState(() {
          selectedCandlestick = null;
          selectedTime = "";
          touchX = null;
          touchY = null;
        });
      },
      child: Container(
        height: 200,
        child: CustomPaint(
          size: Size.infinite,
          painter: CandlestickPainter(
            candlestickData: visibleCandlesticks,
            textColor: Colors.white70,
            onCandlestickSelected: (candlestick, x, y) {
              setState(() {
                selectedCandlestick = candlestick;
                selectedValue = candlestick.close;
                selectedTime = getFormattedDate(candlestick.time);
                touchX = x;
                touchY = y;
              });
            },
          ),
        ),
      ),
    );
  }

  void _handleCandlestickTap(Offset localPosition, List<CandlestickData> candlesticks) {
    // Calculate which candlestick was tapped based on x position
    final double containerWidth = 200; // Estimate of container width
    final double candleWidth = containerWidth / candlesticks.length;
    
    int index = (localPosition.dx / candleWidth).floor();
    if (index >= 0 && index < candlesticks.length) {
      CandlestickData tapped = candlesticks[index];
      setState(() {
        selectedCandlestick = tapped;
        selectedValue = tapped.close;
        selectedTime = getFormattedDate(tapped.time);
        touchX = localPosition.dx;
        touchY = localPosition.dy;
      });
    }
  }

 LineTouchData _getLineTouchData() {
  return LineTouchData(
    enabled: true,
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      showOnTopOfTheChartBoxArea: false,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          return LineTooltipItem(
            getFormattedTimeFromData(spot.x),
            TextStyle(color: Colors.white),
          );
        }).toList();
      },
    ),
    getTouchedSpotIndicator: (barData, spotIndexes) {
      return spotIndexes.map((index) {
        return TouchedSpotIndicatorData(
          FlLine(
            color: Colors.white.withOpacity(0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
          FlDotData(show: true),
        );
      }).toList();
    },
    touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
      if (event is FlPanDownEvent ||
          event is FlPanUpdateEvent ||
          event is FlTapDownEvent) {
        if (response?.lineBarSpots != null &&
            response!.lineBarSpots!.isNotEmpty &&
            event.localPosition != null) {
          final spot = response.lineBarSpots![0];
          setState(() {
            selectedValue = spot.y;
            selectedTime = getFormattedTimeFromData(spot.x);
            touchX = event.localPosition?.dx;
            touchY = event.localPosition?.dy;
          });
        }
      } else if (event is FlPanEndEvent || event is FlTapUpEvent) {
        setState(() {
          selectedValue = widget.stockData.last.y;
          selectedTime = "";
          touchX = null;
          touchY = null;
        });
      }
    },
  );
}

String getFormattedTimeFromData(double x) {
  int index = x.toInt();
  if (index >= 0 && index < widget.stockData.length) {
    // Assuming stockData contains real-time values as x values (e.g., timestamps)
    return DateTime.fromMillisecondsSinceEpoch(
            widget.stockData[index].x.toInt() * 1000)
        .toLocal()
        .toString();
  }
  return "N/A";
}


  Widget _buildStatItem(String label, String value, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 12)
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: label == 'Day\'s Low' ? Colors.white :
            (isPositive ? Colors.greenAccent : Colors.redAccent),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Updated CandlestickPainter with correct hitTest method
class CandlestickPainter extends CustomPainter {
  final List<CandlestickData> candlestickData;
  final Color textColor;
  final Function(CandlestickData, double, double)? onCandlestickSelected;
  late Size _size; // Store the size from the paint method
  
  CandlestickPainter({
    required this.candlestickData,
    required this.textColor,
    this.onCandlestickSelected,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    _size = size; // Store the size for use in hitTest
    
    if (candlestickData.isEmpty) return;
    
    final double width = size.width;
    final double height = size.height;
    final int dataLength = candlestickData.length;
    
    // Find min and max values for scaling
    double minPrice = double.infinity;
    double maxPrice = -double.infinity;
    
    for (var data in candlestickData) {
      if (data.low < minPrice) minPrice = data.low;
      if (data.high > maxPrice) maxPrice = data.high;
    }
    
    // Add padding (10% on top and bottom)
    final padding = (maxPrice - minPrice) * 0.1;
    minPrice -= padding;
    maxPrice += padding;
    
    // Scale factor
    final double verticalScale = height / (maxPrice - minPrice);
    final double candleWidth = width / dataLength * 0.8; // 80% of available width
    final double spacing = width / dataLength * 0.2 / 2; // 20% spacing, divided by 2 for each side
    
    // Function to convert price to Y position
    double priceToY(double price) => height - (price - minPrice) * verticalScale;
    
    // Draw grid lines (optional)
    final Paint gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;
      
    // Horizontal grid lines
    int gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      double y = height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    
    // Draw each candlestick
    for (int i = 0; i < dataLength; i++) {
      final data = candlestickData[i];
      final bool isBullish = data.close >= data.open;
      final Color candleColor = isBullish ? Colors.green : Colors.red;
      
      final double x = i * (candleWidth + spacing * 2) + spacing;
      final double openY = priceToY(data.open);
      final double closeY = priceToY(data.close);
      final double highY = priceToY(data.high);
      final double lowY = priceToY(data.low);
      
      // Draw the wick (high to low line)
      final Paint wickPaint = Paint()
        ..color = candleColor
        ..strokeWidth = 1;
      
      canvas.drawLine(
        Offset(x + candleWidth / 2, highY),
        Offset(x + candleWidth / 2, lowY),
        wickPaint,
      );
      
      // Draw the body (open to close rectangle)
      final Paint bodyPaint = Paint()
        ..color = candleColor
        ..style = PaintingStyle.fill;
      
      final bodyRect = Rect.fromLTRB(
        x,
        isBullish ? closeY : openY,
        x + candleWidth,
        isBullish ? openY : closeY,
      );
      
      canvas.drawRect(bodyRect, bodyPaint);
    }
    
    // Draw price labels
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    
    // Draw max price
    textPainter.text = TextSpan(
      text: '\$${maxPrice.toStringAsFixed(2)}',
      style: TextStyle(color: textColor, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(5, 0));
    
    // Draw min price
    textPainter.text = TextSpan(
      text: '\$${minPrice.toStringAsFixed(2)}',
      style: TextStyle(color: textColor, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(5, height - textPainter.height));
    
    // Draw middle price
    double middlePrice = (maxPrice + minPrice) / 2;
    textPainter.text = TextSpan(
      text: '\$${middlePrice.toStringAsFixed(2)}',
      style: TextStyle(color: textColor, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(5, height / 2 - textPainter.height / 2));
  }
  
  @override
  bool shouldRepaint(covariant CandlestickPainter oldDelegate) => 
    oldDelegate.candlestickData != candlestickData;
    
  // Corrected hitTest method with proper override signature
  @override
  bool? hitTest(Offset position) {
    if (candlestickData.isEmpty) return null;
    
    final double width = _size.width;
    final int dataLength = candlestickData.length;
    final double candleWidth = width / dataLength * 0.8;
    final double spacing = width / dataLength * 0.2 / 2;
    
    for (int i = 0; i < dataLength; i++) {
      final data = candlestickData[i];
      final double x = i * (candleWidth + spacing * 2) + spacing;
      
      if (position.dx >= x && position.dx <= x + candleWidth) {
        if (onCandlestickSelected != null) {
          onCandlestickSelected!(data, position.dx, position.dy);
        }
        return true;
      }
    }
    
    return null;
  }
}

class TimeRangeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ["1D", "5D", "1M", "6M", "YTD", "1Y", "5Y", "MAX"].map((label) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextButton(
              onPressed: () {},
              child: Text(label, style: TextStyle(color: Colors.white54)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TradeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellPage()),
              );
            },
            child: Text("SELL 140.23"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuyPage()),
              );
            },
            child: Text("BUY 140.13"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}






class PerformanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Performance & Key Stats", style: TextStyle(color: Colors.white70, fontSize: 18)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildPerformanceRow("Today's Low", "188.51", "Today's High", "189.51"),
              Divider(color: Colors.white24),
              _buildPerformanceRow("52 Week Low", "168.21", "52 Week High", "189.51"),
              Divider(color: Colors.white24),
              _buildPerformanceRow("Open", "188.01", "Prev. Close", "Rp4,600.00"),
              Divider(color: Colors.white24),
              _buildPerformanceRow("Lower Circuit", "188.01", "Upper Circuit", "188.01"),
              Divider(color: Colors.white24),
              _buildPerformanceRow("Day Range", "Rp4,560.00", "Rp4,630.00", "-"),
              Divider(color: Colors.white24),
              _buildPerformanceRow("Year Range", "Rp3,960.00", "Rp4,980.00", "-"),
              Divider(color: Colors.white24),
              _buildPerformanceRow("Market Cap", "694.707 IDR", "AVG Volume", "167.58M"),
              Divider(color: Colors.white24),
              _buildPerformanceRow("P/E Ratio", "15.50", "Volume", "1001"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text(value1, style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label2, style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text(value2, style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildVolumeInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Volume", style: TextStyle(color: Colors.white54, fontSize: 12)),
          Text("1001", style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}




class ExpertsRatingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Experts rating", style: TextStyle(color: Colors.white70, fontSize: 18)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildRatingBar("Buy", 83.0, Colors.green),
              _buildRatingBar("Hold", 0.02, Colors.yellow),
              _buildRatingBar("Sell", 17.08, Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(String label, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.white54, fontSize: 12)),
          SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(width: 10),
          Text("$percentage%", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}



class FinancialSection extends StatelessWidget {
  final List<FlSpot> earningsData;
  final List<FlSpot> quarterlyEarningsData;
  final List<FlSpot> stockData;
  final List<FlSpot> returnOnEquityData;
  final List<FlSpot> debtEquityRatioData;
  final List<FlSpot> netProfitMarginData;

  FinancialSection({
    required this.earningsData,
    required this.quarterlyEarningsData,
    required this.stockData,
    required this.returnOnEquityData,
    required this.debtEquityRatioData,
    required this.netProfitMarginData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Financial Overview", style: TextStyle(color: Colors.white70, fontSize: 18)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildFinancialChart(),
              SizedBox(height: 10),
              _buildPerformanceMetrics(),
            ],
          ),
        ),
      ],
    );
  }

  // Financial Chart (Annual EPS, Quarterly EPS, Stock Price)
  Widget _buildFinancialChart() {
    return _buildMetricChart("Earnings & Stock Prices", [
      LineChartBarData(spots: earningsData, color: Colors.blue),
      LineChartBarData(spots: quarterlyEarningsData, color: Colors.green),
      LineChartBarData(spots: stockData, color: Colors.red),
    ]);
  }

  // Performance Metrics (ROE, Debt/Equity, Net Profit Margin)
  Widget _buildPerformanceMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricChart("Return on Equity (ROE) %", [
          LineChartBarData(spots: returnOnEquityData, color: Colors.orange),
        ]),
        SizedBox(height: 10),
        _buildMetricChart("Debt/Equity Ratio", [
          LineChartBarData(spots: debtEquityRatioData, color: Colors.purple),
        ]),
        SizedBox(height: 10),
        _buildMetricChart("Net Profit Margin (QoQ) %", [
          LineChartBarData(spots: netProfitMarginData, color: Colors.cyan),
        ]),
      ],
    );
  }

  // Generic function to build financial graphs
  Widget _buildMetricChart(String title, List<LineChartBarData> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white70)),
        SizedBox(height: 5),
        Container(
          height: 200,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: lines,
              lineTouchData: LineTouchData(enabled: true),
            ),
          ),
        ),
      ],
    );
  }
}

class ComparedStocks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Compared to", style: TextStyle(color: Colors.white70, fontSize: 18)),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StockComparisonTile("BUKA", "Bukalapak Tbk", "Rp276.00", "+2.82%", Colors.green),
              SizedBox(width: 10),
              StockComparisonTile("BBRI", "Bank Rakyat Indonesia", "Rp4,630.00", "+0.82%", Colors.green),
              SizedBox(width: 10),
              StockComparisonTile("SIDO", "PT Indofood", "Rp741.00", "-1.2%", Colors.red),
            ],
          ),
        ),
      ],
    );
  }
}


class StockComparisonTile extends StatelessWidget {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final Color changeColor;

  StockComparisonTile(this.symbol, this.name, this.price, this.change, this.changeColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(symbol, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(name, style: TextStyle(color: Colors.white70, fontSize: 12)),
          Text(price, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(change, style: TextStyle(color: changeColor, fontSize: 14)),
        ],
      ),
    );
  }
}



// class KeyStatsSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Keystats", style: TextStyle(color: Colors.white70, fontSize: 18)),
//         SizedBox(height: 10),
//         Container(
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.grey[900],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               KeyStatRow("Previous Close", "Rp4,600.00"),
//               Divider(color: Colors.white24),
//               KeyStatRow("Day Range", "Rp4,560.00 - Rp4,630.00"),
//               Divider(color: Colors.white24),
//               KeyStatRow("Year Range", "Rp3,960.00 - Rp4,980.00"),
//               Divider(color: Colors.white24),
//               KeyStatRow("Market Cap", "694.707 IDR"),
//               Divider(color: Colors.white24),
//               KeyStatRow("AVG Volume", "167.58M"),
//               Divider(color: Colors.white24),
//               KeyStatRow("P/E Ratio", "15.50"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class KeyStatRow extends StatelessWidget {
//   final String title;
//   final String value;

//   KeyStatRow(this.title, this.value);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),
//           Text(value, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//}
class CompanySellHistorySection extends StatelessWidget {
  final List<Map<String, String>> transactionHistory = [
    {"date": "2024-03-01", "volume": "100", "high": "Rp4,600.00", "low": "Rp4,550.00", "price": "Rp4,580.00"},
    {"date": "2024-03-02", "volume": "50", "high": "Rp4,610.00", "low": "Rp4,560.00", "price": "Rp4,590.00"},
    {"date": "2024-03-03", "volume": "200", "high": "Rp4,620.00", "low": "Rp4,570.00", "price": "Rp4,600.00"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("User Transaction History", style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: transactionHistory.map((transaction) => Column(
              children: [
                _buildTransactionRow(transaction),
                Divider(color: Colors.white24),
              ],
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(Map<String, String> transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date: ${transaction['date']}", style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text("Volume: ${transaction['volume']} Shares", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Text("High: ${transaction['high']}", style: TextStyle(color: Colors.greenAccent, fontSize: 14)),
              // Text("Low: ${transaction['low']}", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
              Text("Price: ${transaction['price']}", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}










//recomendation    
  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildRecommendationCard(
                'NFLX',
                'Netflix, Inc',
                '2,122.340',
                '-0.201%',
                Colors.red,
                false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildRecommendationCard(
                'META',
                'Meta Platforms',
                '987.890',
                '+1.29%',
                Colors.blue,
                true,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildRecommendationCard(
                'AMZN',
                'Amazon.com, Inc',
                '1,001.333',
                '-8.20%',
                Colors.orange,
                false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    String symbol,
    String name,
    String price,
    String change,
    Color tagColor,
    bool isPositive,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              symbol,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }