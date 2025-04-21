
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nexus_hub/providers/app_state.dart';
import 'package:flutter_nexus_hub/utils/rss_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RssScreen extends StatefulWidget {
  @override
  _RssScreenState createState() => _RssScreenState();
}

class _RssScreenState extends State<RssScreen> {
  final _urlController = TextEditingController(text: 'https://news.google.com/rss');
  bool _isLoading = false;
  String _error = '';
  
  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
  
  Future<void> _fetchRssFeed() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _error = 'Please enter a valid RSS feed URL';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _error = '';
    });
    
    try {
      final items = await RssService.fetchFeed(url);
      Provider.of<AppState>(context, listen: false).updateRssItems(items);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open link: $url')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSS Feed Reader'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter RSS Feed URL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'https://example.com/rss',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => _urlController.clear(),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _fetchRssFeed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('FETCH RSS FEED'),
                    ),
                    if (_error.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text(
                        _error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<AppState>(
              builder: (ctx, appState, _) {
                final items = appState.rssItems;
                
                if (items.isEmpty && !_isLoading) {
                  return Center(
                    child: Text(
                      'No RSS items to display',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, index) {
                    final item = items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          item['title'] ?? 'No Title',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              item['description'] ?? 'No Description',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              item['pubDate'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _openLink(item['link'] ?? ''),
                        trailing: Icon(Icons.open_in_new),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
