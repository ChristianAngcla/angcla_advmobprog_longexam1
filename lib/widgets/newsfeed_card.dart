import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';
import 'package:angcla_advmobprog_longexam1/widgets/icon_text_button.dart';
import 'package:angcla_advmobprog_longexam1/screens/detail_screen.dart';

class NewsFeedCard extends StatelessWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final bool hasImage;
  final String? postImage;
  final String? userAvatar;

  const NewsFeedCard({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.hasImage = false,
    this.postImage,
    this.userAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              userName: userName,
              postContent: postContent,
              date: date,
              numOfLikes: numOfLikes,
              imageUrl: postImage ?? '',
              profileImageUrl: userAvatar ?? '',
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  CircleAvatar(
                    radius: ScreenUtil().setSp(20),
                    backgroundImage: userAvatar != null
                        ? AssetImage(userAvatar!)
                        : null,
                    child: userAvatar == null ? const Icon(Icons.person) : null,
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      CustomFont(
                        text: userName,
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        children: [
                          CustomFont(
                            text: date,
                            fontSize: ScreenUtil().setSp(12),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(3)),
                          Icon(
                            Icons.public,
                            size: ScreenUtil().setSp(14),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(8)),

              /// POST TEXT
              CustomFont(
                text: postContent,
                fontSize: ScreenUtil().setSp(13),
              ),

              SizedBox(height: ScreenUtil().setHeight(8)),

              /// POST IMAGE
              if (hasImage)
                Container(
                  height: ScreenUtil().setHeight(200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
                    image: postImage != null
                        ? DecorationImage(
                            image: AssetImage(postImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[300],
                  ),
                ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              /// ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconTextButton(
                    icon: Icons.favorite,
                    label: numOfLikes.toString(),
                    color: Colors.red,
                    onPressed: () {},
                  ),
                  IconTextButton(
                    icon: Icons.chat_bubble,
                    label: 'Comment',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            userName: userName,
                            postContent: postContent,
                            date: date,
                            numOfLikes: numOfLikes,
                            imageUrl: postImage ?? '',
                            profileImageUrl: userAvatar ?? '',
                            focusCommentInput: true,
                          ),
                        ),
                      );
                    },
                  ),
                  IconTextButton(
                    icon: Icons.share,
                    label: 'Share',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
