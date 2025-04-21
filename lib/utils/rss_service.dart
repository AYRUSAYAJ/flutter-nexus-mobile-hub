
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class RssService {
  static Future<List<Map<String, dynamic>>> fetchFeed(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return _parseRssFeed(response.body);
      } else {
        throw Exception('Failed to load RSS feed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching RSS feed: $e');
    }
  }
  
  static List<Map<String, dynamic>> _parseRssFeed(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');
    
    return items.map((item) {
      // Extract required fields
      final title = _getElementText(item, 'title');
      final description = _getElementText(item, 'description');
      final link = _getElementText(item, 'link');
      final pubDate = _getElementText(item, 'pubDate');
      
      return {
        'title': title,
        'description': description,
        'link': link,
        'pubDate': pubDate,
      };
    }).toList();
  }
  
  static String _getElementText(XmlElement element, String tagName) {
    final elements = element.findElements(tagName);
    return elements.isNotEmpty ? elements.first.text : '';
  }
}
