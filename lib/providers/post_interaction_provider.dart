import 'package:flutter/foundation.dart';
import 'package:angcla_advmobprog_longexam1/models/comment.dart';

/// Provider for managing session-level interaction state across screens (NewsFeed, Detail, Profile).
///
/// Uses the real API [Post.id] (int) as the key.
/// - Maintains like status (liked/unliked) and adjusted like count per post ID.
/// - Maintains session-level comments per post ID so newly added comments persist during the session.
class PostInteractionProvider extends ChangeNotifier {
  // Key (String) -> isLiked (supports both "post_123" and "notif_user_post")
  final Map<String, bool> _likedItems = {};

  // Key (String) -> total likes count
  final Map<String, int> _likeCounts = {};

  // Post.id -> list of session comments (server comments + locally added comments)
  final Map<int, List<Comment>> _postComments = {};

  String _keyFromId(int postId) => 'post_$postId';

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
      notifyListeners();
    }
  }

  /// Resets all interaction state (e.g. upon user sign-out).
  void clearSession() {
    _likedItems.clear();
    _likeCounts.clear();
    _postComments.clear();
    notifyListeners();
  }
}
