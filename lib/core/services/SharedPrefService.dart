import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _topicsKey = 'subscribed_topics';

  /// Add a topic to the list of subscribed topics
  static Future<void> addTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final topics = prefs.getStringList(_topicsKey) ?? [];
    if (!topics.contains(topic)) {
      topics.add(topic);
      await prefs.setStringList(_topicsKey, topics);
      print('$topic topic added');
    } else {
      print('$topic topic already existed');
    }
  }

  /// Remove a topic from the list of subscribed topics
  static Future<void> removeTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final topics = prefs.getStringList(_topicsKey) ?? [];
    topics.remove(topic);
    await prefs.setStringList(_topicsKey, topics);
    print('$topic topic removed');
  }

  /// Get all subscribed topics
  static Future<List<String>> getTopics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_topicsKey) ?? [];
  }

  /// Check if a topic is already subscribed
  static Future<bool> isSubscribed(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final topics = prefs.getStringList(_topicsKey) ?? [];
    return topics.contains(topic);
  }

  /// Clear all subscribed topics
  static Future<void> clearTopics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_topicsKey);
  }
}
