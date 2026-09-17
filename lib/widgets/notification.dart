import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/providers/post_interaction_provider.dart';
import '../widgets/custom_font.dart';
import '../screens/detail_screen.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    required this.date,
    required this.numOfLikes,
    this.postImageAsset = '',
    this.profileImageAsset,
    this.atProfile = false,
  });

  final String name;
  final String post;
  final String description;
  final String date;
  final int numOfLikes;

  // ✅ ASSET PATHS (NOT URLS)
  final String postImageAsset;
  final String? profileImageAsset;

  final bool atProfile;

  String get _notifKey => 'notif_${name}_$post';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final postInteraction = context.watch<PostInteractionProvider>();
    final notifKey = _notifKey;
    final bool isLiked = postInteraction.isItemLiked(notifKey);
    final int currentLikes = postInteraction.getItemLikes(notifKey, numOfLikes);

    return InkWell(
      onTap: () {
        if (!atProfile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(
                postKey: notifKey,
                userName: name,
                postContent: description,
                date: date,
                numOfLikes: currentLikes,
                imageUrl: postImageAsset, // still passed
                profileImageUrl: profileImageAsset ?? '',
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        child: Row(
          children: [
            CircleAvatar(
              radius: ScreenUtil().setSp(25),
              backgroundImage:
                  (profileImageAsset != null && profileImageAsset!.isNotEmpty)
                  ? AssetImage(profileImageAsset!)
                  : null,
              child: (profileImageAsset == null || profileImageAsset!.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
            ),

            SizedBox(width: ScreenUtil().setWidth(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: name,
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.w800,
                  ),
                  CustomFont(
                    text: 'Posted: $post',
                    fontSize: ScreenUtil().setSp(13),
                  ),
                  CustomFont(
                    text: description,
                    fontSize: ScreenUtil().setSp(12),
                    fontStyle: FontStyle.italic,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Row(
                    children: [
                      CustomFont(
                        text: date,
                        fontSize: ScreenUtil().setSp(10),
                        color: isDark ? Colors.grey[400] : Colors.grey.shade700,
                      ),
                      if (isLiked) ...[
                        SizedBox(width: ScreenUtil().setWidth(8)),
                        Icon(
                          Icons.thumb_up,
                          size: ScreenUtil().setSp(11),
                          color: FB_DARK_PRIMARY,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(3)),
                        CustomFont(
                          text: currentLikes.toString(),
                          fontSize: ScreenUtil().setSp(10),
                          color: FB_DARK_PRIMARY,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.more_horiz,
              color: isDark ? Colors.grey[400] : Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
