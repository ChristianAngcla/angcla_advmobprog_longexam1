import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/models/post.dart';
import 'package:angcla_advmobprog_longexam1/providers/post_interaction_provider.dart';
import 'package:angcla_advmobprog_longexam1/screens/detail_screen.dart';
import 'package:angcla_advmobprog_longexam1/services/user_service.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_inkwell_button.dart';

class PostCard extends StatefulWidget {
  final Post? post;
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final String profileImageUrl;
  final String adsMarket;
  final bool isAds;

  const PostCard({
    super.key,
    this.post,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.imageUrl = '',
    this.profileImageUrl = '',
    this.adsMarket = '',
    this.isAds = false,
  });

  factory PostCard.fromPost({
    Key? key,
    required Post post,
    String? userName,
    String profileImageUrl = '',
    String imageUrl = '',
  }) {
    final cachedUser = UserService.getCachedUser(post.userId);
    final resolvedUserName = (userName != null && userName.trim().isNotEmpty)
        ? userName
        : (cachedUser?.displayName ??
            (post.userId > 0 ? 'User ${post.userId}' : 'User'));

    final resolvedProfileImage = profileImageUrl.isNotEmpty
        ? profileImageUrl
        : (cachedUser?.image ?? '');

    return PostCard(
      key: key,
      post: post,
      userName: resolvedUserName,
      postContent: post.body,
      date: post.createdAt,
      numOfLikes: post.likes,
      imageUrl: imageUrl,
      profileImageUrl: resolvedProfileImage,
      isAds: false,
    );
  }

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String get _interactionKey {
    if (widget.post != null && widget.post!.id > 0) {
      return 'post_${widget.post!.id}';
    }
    return 'ad_${widget.userName}_${widget.date}';
  }

  void _handleToggleLike(PostInteractionProvider provider) {
    final int initialLikes = widget.post?.likes ?? widget.numOfLikes;
    provider.toggleItemLike(_interactionKey, initialLikes);
  }

  void _navigateToDetail({bool focusComment = false}) {
    final String key = _interactionKey;
    final int initialLikes = widget.post?.likes ?? widget.numOfLikes;
    final int currentLikes =
        context.read<PostInteractionProvider>().getItemLikes(key, initialLikes);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          post: widget.post,
          postKey: key,
          userName: widget.userName,
          postContent: widget.postContent,
          date: widget.date,
          numOfLikes: currentLikes,
          imageUrl: widget.imageUrl,
          profileImageUrl: widget.profileImageUrl,
          focusCommentInput: focusComment,
        ),
      ),
    );
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

    return GestureDetector(
      onTap: () => _navigateToDetail(focusComment: false),
      child: Card(
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (widget.profileImageUrl == '')
                      ? Icon(Icons.person, color: secondaryTextColor)
                      : ClipOval(
                          child: (widget.profileImageUrl.startsWith('http'))
                              ? CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: 30,
                                  height: 30,
                                  imageUrl: widget.profileImageUrl,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                            color: FB_DARK_PRIMARY,
                                            value: downloadProgress.progress,
                                          ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.person, size: 20.sp, color: secondaryTextColor),
                                )
                              : Image.asset(
                                  widget.profileImageUrl,
                                  fit: BoxFit.cover,
                                  width: 30,
                                  height: 30,
                                ),
                        ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.date.isNotEmpty) ...[
                            CustomFont(
                              text: widget.date,
                              fontSize: ScreenUtil().setSp(12),
                              color: secondaryTextColor,
                            ),
                            SizedBox(width: ScreenUtil().setWidth(3)),
                          ],
                          Icon(
                            Icons.public,
                            size: ScreenUtil().setSp(15),
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
              SizedBox(height: ScreenUtil().setHeight(15)),
              CustomFont(
                text: widget.postContent,
                fontSize: ScreenUtil().setSp(12),
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              (widget.imageUrl == '')
                  ? SizedBox(height: ScreenUtil().setHeight(0.1))
                  : (widget.imageUrl.startsWith('http'))
                      ? CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                    color: FB_DARK_PRIMARY,
                                    value: downloadProgress.progress,
                                  ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, size: 100.sp),
                        )
                      : Image.asset(
                          widget.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error, size: 100.sp),
                        ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              (widget.isAds)
                  ? const SizedBox()
                  : Row(
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
                            text: (currentLikes == 0)
                                ? 'Like'
                                : currentLikes.toString(),
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w600,
                            color: actionColor,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              _navigateToDetail(focusComment: true),
                          icon: Icon(
                            Icons.comment,
                            color: actionColor,
                          ),
                          label: CustomFont(
                            text: 'Comment',
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w600,
                            color: actionColor,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.redo, color: actionColor),
                          label: CustomFont(
                            text: 'Share',
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w600,
                            color: actionColor,
                          ),
                        ),
                      ],
                    ),
              (widget.isAds)
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () => _navigateToDetail(focusComment: true),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: secondaryTextColor),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setSp(10),
                              0,
                              0,
                              0,
                            ),
                            alignment: Alignment.centerLeft,
                            height: ScreenUtil().setHeight(25),
                            width: ScreenUtil().setWidth(330),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2C2C2C)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setSp(10)),
                              ),
                            ),
                            child: CustomFont(
                              text: 'Write a comment...',
                              fontSize: ScreenUtil().setSp(11),
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
              (widget.isAds)
                  ? Container(
                      padding: EdgeInsets.all(5.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomFont(
                                text: 'MORE DETAILS',
                                fontSize: 17.sp,
                              ),
                              CustomFont(
                                text: widget.adsMarket,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          CustomInkwellButton(
                            width: 90.w,
                            height: 40.h,
                            icon: const Icon(
                              Icons.arrow_right_alt,
                              color: FB_LIGHT_PRIMARY,
                            ),
                            onTap: () => _navigateToDetail(focusComment: false),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (widget.isAds)
                  ? const SizedBox()
                  : SizedBox(height: ScreenUtil().setHeight(10)),
              (widget.isAds)
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () => _navigateToDetail(focusComment: false),
                      child: CustomFont(
                        text: 'View comments',
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
