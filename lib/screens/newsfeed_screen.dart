import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/models/post.dart';
import 'package:angcla_advmobprog_longexam1/services/post_service.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';
import 'package:angcla_advmobprog_longexam1/widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PostService _postService = PostService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    _postsFuture = _postService.getPosts();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _loadPosts();
    });
    await _postsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: FB_DARK_PRIMARY,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10.h),
                  CustomFont(
                    text: 'Failed to load posts',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _loadPosts();
                      });
                    },
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

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Center(
            child: CustomFont(
              text: 'No posts available',
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey.shade700,
            ),
          );
        }

        return RefreshIndicator(
          color: FB_DARK_PRIMARY,
          onRefresh: _refreshPosts,
          child: ListView.builder(
            itemCount: posts.length + 1, // +1 for the advertisement carousel
            itemBuilder: (context, index) {
              if (index == 1) {
                return _buildAdCarousel(context);
              }
              final postIndex = index > 1 ? index - 1 : index;
              return PostCard.fromPost(post: posts[postIndex]);
            },
          ),
        );
      },
    );
  }

  Widget _buildAdCarousel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 5.h),
          child: CustomFont(
            text: 'Advertisement/ Promotion',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey.shade700,
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: 308.h,
            padEnds: false,
          ),
          items: carouselItems(),
        ),
      ],
    );
  }

  List<Widget> carouselItems() {
    return [
      PostCard(
        userName: 'Christian Angcla',
        imageUrl:
            'https://www.boredpanda.com/blog/wp-content/uploads/2025/10/funny-cat-memes-go-hard-cover_675.jpg',
        profileImageUrl:
            'https://scontent.fmnl4-1.fna.fbcdn.net/v/t39.30808-6/615509878_869495876057975_6033171580628204368_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFqf5d5ktAbVR1osTO7byW9YIHVyq0ILw5ggdXKrQgvDiuIh8JGz1Fh_K3WxX3NNNxBsW-CL_tYA1RAHWCccYPv&_nc_ohc=nuFy4TMxZNgQ7kNvwFSDyX0&_nc_oc=Adn9IltXMvNBJ0-cnJrDLlwcKopiUO6_fKWIu6AwNo8tvcgOIl-2njCJ3Seze0r4YOIM14jARoEdm8Hg9cazEAY1&_nc_zt=23&_nc_ht=scontent.fmnl4-1.fna&_nc_gid=IAsHLl3esXWfeWBdI4QCBg&oh=00_AfrS3gkvNk4vWPBmltef52Tf5BRbrjbhhVSP4_-aq1zfeg&oe=697AA37A',
        postContent: 'Meow Meow?',
        date: 'November 20, 2025',
        isAds: true,
        adsMarket: 'Pet Supplies',
      ),
      PostCard(
        userName: 'Tech World',
        imageUrl:
            'https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        profileImageUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
        postContent: 'Upgrade your setup with the latest tech.',
        date: 'Sponsored',
        isAds: true,
        adsMarket: 'Tech Gadgets',
      ),
      PostCard(
        userName: 'Travel Goals',
        imageUrl:
            'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        profileImageUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
        postContent: 'Book your dream vacation today.',
        date: 'Sponsored',
        isAds: true,
        adsMarket: 'Travel Agency',
      ),
      PostCard(
        userName: 'Foodie Heaven',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        profileImageUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
        postContent: 'Delicious meals delivered to your doorstep.',
        date: 'Sponsored',
        isAds: true,
        adsMarket: 'Food Delivery',
      ),
      PostCard(
        userName: 'Fashion Hub',
        imageUrl:
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        profileImageUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
        postContent: 'Stay stylish with our new collection.',
        date: 'Sponsored',
        isAds: true,
        adsMarket: 'Fashion',
      ),
      PostCard(
        userName: 'Music Fest',
        imageUrl:
            'https://images.unsplash.com/photo-1459749411177-0473ef7161cf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        profileImageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
        postContent: 'Get your tickets now!',
        date: 'Sponsored',
        isAds: true,
        adsMarket: 'Events',
      ),
    ];
  }
}
