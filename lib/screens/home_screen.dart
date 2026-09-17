import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/models/user.dart';
import 'package:angcla_advmobprog_longexam1/screens/newsfeed_screen.dart';
import 'package:angcla_advmobprog_longexam1/screens/notification_screen.dart';
import 'package:angcla_advmobprog_longexam1/screens/profile_screen.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  String get _displayTitle {
    if (_selectedIndex == 0) return 'Intertwine';
    if (_selectedIndex == 1) return 'Notifications';
    return widget.user.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: FB_TEXT_COLOR_WHITE,
        elevation: 2,
        title: CustomFont(
          text: _displayTitle,
          fontSize: ScreenUtil().setSp(25),
          color: FB_DARK_PRIMARY,
          fontFamily: 'Klavika',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          const NewsFeedScreen(),
          const NotificationScreen(),
          ProfileScreen(user: widget.user),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: FB_DARK_PRIMARY,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
