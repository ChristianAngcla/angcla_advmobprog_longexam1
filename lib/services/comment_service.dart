import 'dart:convert';
import 'package:http/http.dart';

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  Future<List<Comment>> getCommentsByPost(int postId) async {
    if (postId <= 0) {
      throw ArgumentError('postId must be greater than 0');
    }

    final uri = Uri.parse('$host/comments/post/$postId');
    final response = await get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final List commentsJson = decoded['comments'] ?? [];
        return commentsJson
            .map((c) => Comment.fromJson(c as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected JSON format from comments API');
      }
    } else {
      throw Exception('Failed to load comments: ${response.statusCode}');
    }
  }

  Future<Comment> addComment({
    required String body,
    required int postId,
    required int userId,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) {
      throw ArgumentError('Comment body cannot be empty');
    }
    if (postId <= 0) {
      throw ArgumentError('postId must be greater than 0');
    }
    if (userId <= 0) {
      throw ArgumentError('userId must be greater than 0');
    }

    final uri = Uri.parse('$host/comments/add');
    final payload = jsonEncode({
      'body': trimmedBody,
      'postId': postId,
      'userId': userId,
    });

    final response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return Comment.fromJson(decoded);
      } else {
        throw Exception('Unexpected JSON response format from add comment API');
      }
    } else {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }
  }
}
