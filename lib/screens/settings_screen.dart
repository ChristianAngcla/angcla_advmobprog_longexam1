import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/providers/post_interaction_provider.dart';
import 'package:angcla_advmobprog_longexam1/providers/theme_provider.dart';
import 'package:angcla_advmobprog_longexam1/screens/signin_screen.dart';
import 'package:angcla_advmobprog_longexam1/services/user_service.dart';
import 'package:angcla_advmobprog_longexam1/widgets/custom_font.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  bool _isSigningOut = false;

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      await _signOut();
    }
  }

  Future<void> _signOut() async {
    if (_isSigningOut) return;

    setState(() {
      _isSigningOut = true;
    });

    try {
      context.read<PostInteractionProvider>().clearSession();
      await _userService.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSigningOut = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to sign out. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomFont(
          text: 'Settings',
          fontSize: ScreenUtil().setSp(20),
          fontWeight: FontWeight.bold,
          color: FB_DARK_PRIMARY,
        ),
        elevation: 1,
      ),
      body: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final headerColor = isDark ? Colors.grey[400] : Colors.grey.shade700;
          return ListView(
            padding: EdgeInsets.all(ScreenUtil().setSp(16)),
            children: [
              // PREFERENCES SECTION
              CustomFont(
                text: 'Preferences',
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
                color: headerColor,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return SwitchListTile(
                      title: CustomFont(
                        text: 'Dark Mode',
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitle: CustomFont(
                        text: themeProvider.isDarkMode
                            ? 'Dark theme enabled'
                            : 'Light theme enabled',
                        fontSize: ScreenUtil().setSp(12),
                        color: headerColor,
                      ),
                      secondary: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: FB_DARK_PRIMARY,
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.setDarkMode(value);
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(25)),

              // ACCOUNT SECTION
              CustomFont(
                text: 'Account',
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
                color: headerColor,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Log out of your active session',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: _isSigningOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: _isSigningOut ? null : _confirmSignOut,
            ),
          ),
        ],
      );
    },
  ),
);
  }
}
