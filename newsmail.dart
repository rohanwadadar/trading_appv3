import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsMailScreen extends StatefulWidget {
  @override
  _NewsMailScreenState createState() => _NewsMailScreenState();
}

class _NewsMailScreenState extends State<NewsMailScreen> {
  List<dynamic> newsData = [];
  final String apiKey = "XH0MOF8FACW6RR0L"; // Your API Key

  @override
  void initState() {
    super.initState();
    fetchNews();
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

  void _openArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the article')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Latest News"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: newsData.isEmpty
          ? Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: newsData.length,
              itemBuilder: (context, index) {
                var newsItem = newsData[index];
                return GestureDetector(
                  onTap: () => _openArticle(newsItem["url"]),
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: newsItem["banner_image"] != null
                                ? Image.network(
                                    newsItem["banner_image"],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 180,
                                    width: double.infinity,
                                    color: Colors.grey[800],
                                    child: Center(
                                      child: Icon(Icons.image_not_supported,
                                          color: Colors.white70, size: 50),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            newsItem["title"] ?? "No Title",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            newsItem["summary"] ?? "No Summary Available",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                newsItem["source"] ?? "Unknown Source",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 14),
                              ),
                              ElevatedButton(
                                onPressed: () => _openArticle(newsItem["url"]),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text("Read More"),
                              )
                            ],
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
}
