import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/models/post.dart';
import 'package:angcla_advmobprog_longexam1/models/user.dart';
import 'package:angcla_advmobprog_longexam1/services/post_service.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_info.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_button.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_dialogs.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';
import 'package:angcla_advmobprog_longexam1/widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PostService _postService = PostService();

  List<Post> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final posts = await _postService.getPostsByUser(widget.user.id);
      if (!mounted) return;

      setState(() {
        _posts = posts;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load profile posts.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName =
        (widget.user.firstName.isNotEmpty || widget.user.lastName.isNotEmpty)
        ? '${widget.user.firstName} ${widget.user.lastName}'.trim()
        : widget.user.username;

    final displayAvatar =
        (widget.user.image.isNotEmpty && widget.user.image.startsWith('http'))
        ? widget.user.image
        : 'https://www.shutterstock.com/image-photo/surprised-cat-meme-face-600nw-2503158851.jpg';

    return DefaultTabController(
      length: 3,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                      image: const DecorationImage(
                        image: CachedNetworkImageProvider(
                          'https://i.pinimg.com/236x/e4/b3/05/e4b3052999393732b1b0eabb259871f7.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: ScreenUtil().setWidth(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            displayAvatar,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(55)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomFont(
                          text: displayName,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(20),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: FB_DARK_PRIMARY,
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/settings'),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Row(
                      children: [
                        CustomFont(
                          text: '400m',
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'followers',
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(15),
                          color: isDark ? Colors.grey[400] : Colors.grey.shade700,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        Icon(
                          Icons.circle,
                          color: isDark ? Colors.grey[500] : Colors.grey.shade600,
                          size: ScreenUtil().setSp(5),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        CustomFont(
                          text: '20',
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'following',
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(15),
                          color: isDark ? Colors.grey[400] : Colors.grey.shade700,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Row(
                      children: [
                        CustomButton(buttonName: 'Follow', onPressed: () {}),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomButton(
                          buttonName: 'Message',
                          onPressed: () {},
                          buttonType: 'outlined',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              TabBar(
                indicatorColor: FB_DARK_PRIMARY,
                labelColor: isDark ? Colors.white : Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: CustomFont(
                      text: 'Posts',
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'About',
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'Photos',
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(2000),
                child: TabBarView(
                  children: [
                    _buildPostsTab(),
                    SingleChildScrollView(
                      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFont(
                            text: "About",
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          const CustomInfo(
                            icon: Icons.school,
                            title: "Studies at",
                            subtitle:
                                "National University Philippines\nStarted in 2023",
                          ),
                          const CustomInfo(
                            icon: Icons.home,
                            title: "Lives in",
                            subtitle: "Cainta",
                          ),
                          const CustomInfo(
                            icon: Icons.location_on,
                            title: "From",
                            subtitle: "Cainta",
                          ),
                          const CustomInfo(
                            icon: Icons.favorite_border,
                            title: "Relationship Status",
                            subtitle: "Single",
                          ),
                        ],
                      ),
                    ),
                    _photos(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: FB_DARK_PRIMARY),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              SizedBox(height: 10.h),
              CustomFont(
                text: _errorMessage!,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: _loadProfileData,
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

    if (_posts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: CustomFont(
            text: 'No posts found.',
            fontSize: 15.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return PostCard.fromPost(
          post: post,
          userName: widget.user.username,
          profileImageUrl: widget.user.image,
        );
      },
    );
  }

  Widget _photos() {
    final List<String> photoAssets = [
      'assets/images/lanceprofilepic.webp',
      'assets/images/dyanprofilepic.webp',
      'assets/images/yentinprofilepic.webp',
      'assets/images/intertwine_logo_cats.png',
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
      crossAxisSpacing: ScreenUtil().setWidth(10),
      mainAxisSpacing: ScreenUtil().setHeight(10),
      crossAxisCount: 2,
      children: photoAssets.map((assetPath) {
        return GestureDetector(
          onTap: () => customShowImageDialog(
            context,
            imageUrl: assetPath,
          ),
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(8)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(6)),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 40.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
