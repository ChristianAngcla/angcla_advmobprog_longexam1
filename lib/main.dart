import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/providers/post_interaction_provider.dart';
import 'package:angcla_advmobprog_longexam1/providers/theme_provider.dart';
import 'package:angcla_advmobprog_longexam1/screens/register_screen.dart';
import 'package:angcla_advmobprog_longexam1/screens/settings_screen.dart';
import 'package:angcla_advmobprog_longexam1/screens/signin_screen.dart';
import 'package:angcla_advmobprog_longexam1/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('dark_mode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initialDarkMode: isDarkMode),
        ),
        ChangeNotifierProvider(
          create: (_) => PostInteractionProvider(prefs: prefs),
        ),
      ],
      child: const AngclaFacebook(),
    ),
  );
}

class AngclaFacebook extends StatelessWidget {
  const AngclaFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Angcla Facebook',
              theme: ThemeData(
                useMaterial3: false,
                brightness: Brightness.light,
                primaryColor: FB_PRIMARY,
                scaffoldBackgroundColor: const Color(0xFFF8FAF8),
                cardColor: Colors.white,
                dividerColor: Colors.grey.shade300,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF1E293B),
                  elevation: 1,
                  iconTheme: IconThemeData(color: FB_DARK_PRIMARY),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  selectedItemColor: FB_DARK_PRIMARY,
                  unselectedItemColor: Colors.grey,
                ),
                colorScheme: const ColorScheme.light(
                  primary: FB_DARK_PRIMARY,
                  secondary: FB_LIGHT_PRIMARY,
                  surface: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: false,
                brightness: Brightness.dark,
                primaryColor: FB_PRIMARY,
                scaffoldBackgroundColor: const Color(0xFF121212),
                cardColor: const Color(0xFF1E1E1E),
                dividerColor: const Color(0xFF2C2C2C),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF1E1E1E),
                  foregroundColor: Colors.white,
                  elevation: 1,
                  iconTheme: IconThemeData(color: FB_DARK_PRIMARY),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Color(0xFF1E1E1E),
                  selectedItemColor: FB_DARK_PRIMARY,
                  unselectedItemColor: Colors.grey,
                ),
                colorScheme: const ColorScheme.dark(
                  primary: FB_DARK_PRIMARY,
                  secondary: FB_LIGHT_PRIMARY,
                  surface: Color(0xFF1E1E1E),
                ),
              ),
              themeMode: themeProvider.themeMode,
              initialRoute: '/splash',
              routes: {
                '/signin': (context) => const SignInScreen(),
                '/register': (context) => const RegisterScreen(),
                '/splash': (context) => const SplashScreen(),
                '/settings': (context) => const SettingsScreen(),
              },
            );
          },
        );
      },
    );
  }
}
