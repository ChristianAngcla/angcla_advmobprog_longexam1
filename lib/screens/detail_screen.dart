import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/models/comment.dart';
import 'package:angcla_advmobprog_longexam1/models/post.dart';
import 'package:angcla_advmobprog_longexam1/models/user.dart';
import 'package:angcla_advmobprog_longexam1/providers/post_interaction_provider.dart';
import 'package:angcla_advmobprog_longexam1/services/comment_service.dart';
import 'package:angcla_advmobprog_longexam1/services/user_service.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';

class DetailScreen extends StatefulWidget {
  final Post? post;
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final String profileImageUrl;
  final String? postKey;

  const DetailScreen({
    super.key,
    this.post,
    this.postKey,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.imageUrl = '',
    this.profileImageUrl = '',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();

  List<Comment> _comments = [];
  User? _currentUser;

  bool _isCommentsLoading = false;
  String? _commentsError;
  bool _isSubmittingComment = false;

  final TextEditingController _commentController = TextEditingController();

  String get _interactionKey {
    if (widget.post != null && widget.post!.id > 0) {
      return 'post_${widget.post!.id}';
    }
    if (widget.postKey != null && widget.postKey!.isNotEmpty) {
      return widget.postKey!;
    }
    return 'item_${widget.userName}_${widget.date}';
  }

  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadDetailData() async {
    // 1. Restore authenticated user session (for adding comments)
    try {
      final user = await _userService.getSavedUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (_) {
      // Comments remain readable even if session retrieval fails
    }

    // 2. If this is a typed API post with a valid ID, load/sync comments
    if (widget.post != null && widget.post!.id > 0) {
      if (!mounted) return;
      final int postId = widget.post!.id;
      final provider = context.read<PostInteractionProvider>();

      // Check if session state already holds comments (including previously added ones)
      final cached = provider.getComments(postId);
      if (cached != null && cached.isNotEmpty) {
        if (mounted) {
          setState(() {
            _comments = List<Comment>.from(cached);
            _isCommentsLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isCommentsLoading = true;
            _commentsError = null;
          });
        }
      }

      try {
        final serverComments = await _commentService.getCommentsByPost(postId);
        if (!mounted) return;

        // Synchronize server comments into shared session state without losing locally added comments
        provider.syncServerComments(postId, serverComments);
        final allComments = provider.getComments(postId) ?? serverComments;

        setState(() {
          _comments = List<Comment>.from(allComments);
          _isCommentsLoading = false;
        });
      } catch (e) {
        if (!mounted) return;
        final cached = provider.getComments(postId);
        if (cached != null && cached.isNotEmpty) {
          setState(() {
            _comments = List<Comment>.from(cached);
            _isCommentsLoading = false;
          });
        } else {
          setState(() {
            _isCommentsLoading = false;
            _commentsError = 'Unable to load comments.';
          });
        }
      }
    }
  }

  void _handleToggleLike(PostInteractionProvider provider) {
    final int initialLikes = widget.post?.likes ?? widget.numOfLikes;
    provider.toggleItemLike(_interactionKey, initialLikes);
  }

  Future<void> _submitComment() async {
    if (widget.post == null || widget.post!.id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comments unavailable for this post.')),
      );
      return;
    }

    if (_currentUser == null || _currentUser!.id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to add a comment.')),
      );
      return;
    }

    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (_isSubmittingComment) return;

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      final newComment = await _commentService.addComment(
        body: text,
        postId: widget.post!.id,
        userId: _currentUser!.id,
      );

      if (!mounted) return;

      final provider = context.read<PostInteractionProvider>();
      provider.addComment(widget.post!.id, newComment);

      final updatedComments = provider.getComments(widget.post!.id) ??
          [..._comments, newComment];

      setState(() {
        _comments = List<Comment>.from(updatedComments);
        _commentController.clear();
        _isSubmittingComment = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmittingComment = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to add comment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final postInteraction = context.watch<PostInteractionProvider>();

    final String key = _interactionKey;
    final int initialLikes = widget.post?.likes ?? widget.numOfLikes;
    final bool isLiked = postInteraction.isItemLiked(key);
    final int currentLikes = postInteraction.getItemLikes(key, initialLikes);

    final Color actionColor = isDark ? FB_DARK_PRIMARY : const Color(0xFF2E7D32);
    final Color secondaryTextColor =
        isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomFont(
          text: widget.userName,
          fontSize: ScreenUtil().setSp(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: ScreenUtil().screenHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // POST IMAGE
              if (widget.imageUrl.isNotEmpty)
                (widget.imageUrl.startsWith('http'))
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Image.asset(widget.imageUrl),

              SizedBox(height: ScreenUtil().setHeight(20)),

              // AUTHOR HEADER
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                child: Row(
                  children: [
                    widget.profileImageUrl.isEmpty
                        ? Icon(Icons.person, color: secondaryTextColor)
                        : CircleAvatar(
                            radius: ScreenUtil().setSp(25),
                            backgroundImage:
                                (widget.profileImageUrl.startsWith('http'))
                                    ? CachedNetworkImageProvider(
                                        widget.profileImageUrl,
                                      )
                                    : AssetImage(widget.profileImageUrl)
                                        as ImageProvider,
                          ),
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: widget.userName,
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          children: [
                            if (widget.date.isNotEmpty) ...[
                              CustomFont(
                                text: widget.date,
                                fontSize: ScreenUtil().setSp(15),
                                color: secondaryTextColor,
                              ),
                              SizedBox(width: ScreenUtil().setWidth(5)),
                            ],
                            Icon(
                              Icons.public,
                              size: ScreenUtil().setSp(18),
                              color: secondaryTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.more_horiz, color: secondaryTextColor),
                  ],
                ),
              ),

              // POST CONTENT
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                ),
                child: CustomFont(
                  text: widget.postContent,
                  fontSize: ScreenUtil().setSp(16),
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(20)),
              const Divider(),

              // ACTION BUTTONS (LIKE / COMMENT / SHARE)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () =>
                          _handleToggleLike(postInteraction),
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: actionColor,
                      ),
                      label: CustomFont(
                        text: currentLikes == 0 ? 'Like' : currentLikes.toString(),
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.w600,
                        color: actionColor,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.comment, color: actionColor),
                      label: CustomFont(
                        text: 'Comment',
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.w600,
                        color: actionColor,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.share, color: actionColor),
                      label: CustomFont(
                        text: 'Share',
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.w600,
                        color: actionColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // COMMENTS HEADER
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                  vertical: ScreenUtil().setHeight(5),
                ),
                child: CustomFont(
                  text: 'Comments',
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),

              // COMMENTS LIST OR STATES
              _buildCommentsSection(isDark, secondaryTextColor),

              SizedBox(height: ScreenUtil().setHeight(10)),

              // WRITE A COMMENT INPUT
              _buildCommentInput(isDark, secondaryTextColor),

              SizedBox(height: ScreenUtil().setHeight(30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection(bool isDark, Color secondaryTextColor) {
    if (widget.post == null || widget.post!.id <= 0) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20),
          vertical: ScreenUtil().setHeight(10),
        ),
        child: CustomFont(
          text: 'Comments are not available for this post.',
          fontSize: ScreenUtil().setSp(12),
          color: secondaryTextColor,
        ),
      );
    }

    if (_isCommentsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: FB_DARK_PRIMARY),
        ),
      );
    }

    if (_commentsError != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomFont(
                text: _commentsError!,
                fontSize: ScreenUtil().setSp(13),
                color: secondaryTextColor,
              ),
              TextButton(
                onPressed: _loadDetailData,
                child: const Text(
                  'Retry',
                  style: TextStyle(color: FB_DARK_PRIMARY),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_comments.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20),
          vertical: ScreenUtil().setHeight(10),
        ),
        child: CustomFont(
          text: 'No comments yet.',
          fontSize: ScreenUtil().setSp(13),
          color: secondaryTextColor,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        final authorName = comment.fullName.trim().isNotEmpty
            ? comment.fullName
            : (comment.username.trim().isNotEmpty
                ? comment.username
                : (UserService.getCachedUser(comment.userId)?.displayName ?? (comment.userId > 0 ? 'User ${comment.userId}' : 'User')));

        return Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: ScreenUtil().setSp(16),
                backgroundColor:
                    isDark ? const Color(0xFF2C2C2C) : Colors.grey[300],
                child: Icon(Icons.person, size: 20, color: secondaryTextColor),
              ),
              SizedBox(width: ScreenUtil().setWidth(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFont(
                      text: authorName,
                      fontSize: ScreenUtil().setSp(13),
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(3)),
                    CustomFont(
                      text: comment.body,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                    if (comment.likes > 0) ...[
                      SizedBox(height: ScreenUtil().setHeight(4)),
                      Row(
                        children: [
                          const Icon(
                            Icons.thumb_up,
                            size: 12,
                            color: FB_DARK_PRIMARY,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(4)),
                          CustomFont(
                            text: '${comment.likes}',
                            fontSize: ScreenUtil().setSp(10),
                            color: secondaryTextColor,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentInput(bool isDark, Color secondaryTextColor) {
    final bool isLegacy = widget.post == null || widget.post!.id <= 0;
    final bool isGuest = _currentUser == null || _currentUser!.id <= 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
      child: Row(
        children: [
          CircleAvatar(
            radius: ScreenUtil().setSp(16),
            backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[300],
            child: Icon(Icons.person, size: 20, color: secondaryTextColor),
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(12)),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
              ),
              child: TextField(
                controller: _commentController,
                enabled: !isLegacy && !isGuest && !_isSubmittingComment,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(13),
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                decoration: InputDecoration(
                  hintText: isLegacy
                      ? 'Comments unavailable'
                      : (isGuest ? 'Sign in to comment' : 'Write a comment...'),
                  hintStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(10),
                  ),
                ),
                onSubmitted: (_) => _submitComment(),
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(8)),
          _isSubmittingComment
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: FB_DARK_PRIMARY,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: FB_DARK_PRIMARY),
                  onPressed:
                      (isLegacy || isGuest) ? null : () => _submitComment(),
                ),
        ],
      ),
    );
  }
}
