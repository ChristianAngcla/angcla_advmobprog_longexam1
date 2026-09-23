import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:angcla_advmobprog_longexam1/models/comment.dart';

/// Provider for managing interaction state across screens (NewsFeed, Detail, Profile, Notifications).
///
/// Features persistent storage via [SharedPreferences] so that likes and user-added comments
/// survive across app restarts and user logouts.
class PostInteractionProvider extends ChangeNotifier {
  static const String _prefKeyLikedItems = 'persistent_liked_items';
  static const String _prefKeyLikeCounts = 'persistent_like_counts';
  static const String _prefKeyComments = 'persistent_post_comments';

  final SharedPreferences? _prefs;

  // Key (String) -> isLiked (supports both "post_123" and "notif_user_post")
  final Map<String, bool> _likedItems = {};

  // Key (String) -> total likes count
  final Map<String, int> _likeCounts = {};

  // Post.id -> list of session comments (server comments + locally added comments)
  final Map<int, List<Comment>> _postComments = {};

  PostInteractionProvider({SharedPreferences? prefs}) : _prefs = prefs {
    _loadFromPrefs();
  }

  String _keyFromId(int postId) => 'post_$postId';

  void _loadFromPrefs() {
    final prefs = _prefs;
    if (prefs == null) return;

    // 1. Liked Items
    final likedStr = prefs.getString(_prefKeyLikedItems);
    if (likedStr != null && likedStr.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(likedStr);
        decoded.forEach((key, value) {
          if (value is bool) {
            _likedItems[key] = value;
          }
        });
      } catch (_) {}
    }

    // 2. Like Counts
    final countsStr = prefs.getString(_prefKeyLikeCounts);
    if (countsStr != null && countsStr.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(countsStr);
        decoded.forEach((key, value) {
          if (value is num) {
            _likeCounts[key] = value.toInt();
          }
        });
      } catch (_) {}
    }

    // 3. Comments
    final commentsStr = prefs.getString(_prefKeyComments);
    if (commentsStr != null && commentsStr.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(commentsStr);
        decoded.forEach((key, value) {
          final int? postId = int.tryParse(key);
          if (postId != null && value is List) {
            _postComments[postId] = value
                .map((item) =>
                    Comment.fromJson(Map<String, dynamic>.from(item as Map)))
                .toList();
          }
        });
      } catch (_) {}
    }
  }

  Future<void> _persistLikes() async {
    final prefs = _prefs;
    if (prefs == null) return;
    try {
      await prefs.setString(_prefKeyLikedItems, jsonEncode(_likedItems));
      await prefs.setString(_prefKeyLikeCounts, jsonEncode(_likeCounts));
    } catch (_) {}
  }

  Future<void> _persistComments() async {
    final prefs = _prefs;
    if (prefs == null) return;
    try {
      final Map<String, dynamic> data = {};
      _postComments.forEach((postId, comments) {
        data[postId.toString()] = comments.map((c) => c.toJson()).toList();
      });
      await prefs.setString(_prefKeyComments, jsonEncode(data));
    } catch (_) {}
  }

  // ==========================================
  // LIKES API (String Key & int PostId)
  // ==========================================

  /// Checks if an item (post, notification, or ad) is currently liked by key.
  bool isItemLiked(String key) {
    return _likedItems[key] ?? false;
  }

  /// Checks if a post is currently liked in this session by integer post ID.
  bool isPostLiked(int postId) {
    return isItemLiked(_keyFromId(postId));
  }

  /// Returns current like count for an item by key.
  int getItemLikes(String key, int fallbackLikes) {
    if (_likeCounts.containsKey(key)) {
      return _likeCounts[key]!;
    }
    _likeCounts[key] = fallbackLikes;
    _persistLikes();
    return fallbackLikes;
  }

  /// Returns the current displayed like count for a post by integer post ID.
  int getLikes(int postId, int fallbackLikes) {
    return getItemLikes(_keyFromId(postId), fallbackLikes);
  }

  /// Toggles like state for an item by key and updates the like count.
  void toggleItemLike(String key, int initialLikes) {
    if (!_likeCounts.containsKey(key)) {
      _likeCounts[key] = initialLikes;
    }

    final bool currentlyLiked = _likedItems[key] ?? false;
    if (!currentlyLiked) {
      _likedItems[key] = true;
      _likeCounts[key] = (_likeCounts[key] ?? initialLikes) + 1;
    } else {
      _likedItems[key] = false;
      final int count = _likeCounts[key] ?? initialLikes;
      _likeCounts[key] = (count > 0) ? count - 1 : 0;
    }

    _persistLikes();
    notifyListeners();
  }

  /// Toggles the like state for a post by integer post ID and updates the like count.
  void toggleLike(int postId, int initialLikes) {
    toggleItemLike(_keyFromId(postId), initialLikes);
  }

  // ==========================================
  // COMMENTS API
  // ==========================================

  /// Returns the stored session comments for [postId], or null if not yet loaded.
  List<Comment>? getComments(int postId) {
    return _postComments[postId];
  }

  /// Synchronizes comments loaded from the API into shared state,
  /// preserving any locally added comments during the session without duplicates.
  void syncServerComments(int postId, List<Comment> serverComments) {
    if (!_postComments.containsKey(postId)) {
      _postComments[postId] = List<Comment>.from(serverComments);
    } else {
      final existingList = _postComments[postId]!;
      for (final serverComment in serverComments) {
        final bool alreadyExists = existingList.any(
          (c) =>
              (c.id > 0 && c.id == serverComment.id) ||
              (c.body == serverComment.body &&
                  c.username == serverComment.username),
        );
        if (!alreadyExists) {
          existingList.add(serverComment);
        }
      }
    }
    _persistComments();
    notifyListeners();
  }

  /// Appends a newly created comment to the post's session comment list.
  /// Prevents duplicate insertion.
  void addComment(int postId, Comment newComment) {
    if (!_postComments.containsKey(postId)) {
      _postComments[postId] = [];
    }

    final bool alreadyExists = _postComments[postId]!.any(
      (c) =>
          (c.id > 0 && c.id == newComment.id) ||
          (c.body == newComment.body && c.userId == newComment.userId),
    );

    if (!alreadyExists) {
      _postComments[postId]!.add(newComment);
      _persistComments();
      notifyListeners();
    }
  }

  /// Resets all interaction state. Pass [clearStorage: true] to also clear persistent storage.
  Future<void> clearSession({bool clearStorage = false}) async {
    _likedItems.clear();
    _likeCounts.clear();
    _postComments.clear();
    final prefs = _prefs;
    if (clearStorage && prefs != null) {
      await prefs.remove(_prefKeyLikedItems);
      await prefs.remove(_prefKeyLikeCounts);
      await prefs.remove(_prefKeyComments);
    }
    notifyListeners();
  }
}
