import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';

// ENHANCEMENT 2: user preferences and the Sign Out button.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Clears the saved session and returns to sign-in.
  Future<void> _signOut(BuildContext context) async {
    await UserService().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: CustomFont(
          text: 'Settings',
          fontSize: 20.sp,
          color: brandColor(context),
          fontFamily: 'Klavika',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          _heading('Appearance'),
          Card(
            child: SwitchListTile(
              title: CustomFont(
                text: 'Dark Mode',
                fontSize: 14.sp,
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              subtitle: CustomFont(
                text: themeProvider.isDark
                    ? 'Dark theme is on'
                    : 'Light theme is on',
                fontSize: 11.sp,
                color: scheme.onSurfaceVariant,
              ),
              secondary: Icon(
                themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                color: FB_PRIMARY,
              ),
              activeThumbColor: FB_PRIMARY,
              value: themeProvider.isDark,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          SizedBox(height: 20.h),
          _heading('Account'),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: scheme.error),
              title: CustomFont(
                text: 'Sign Out',
                fontSize: 14.sp,
                color: scheme.error,
                fontWeight: FontWeight.w600,
              ),
              subtitle: CustomFont(
                text: 'Clears the saved session and returns to sign-in',
                fontSize: 11.sp,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () => customOptionDialog(
                context,
                title: 'Sign out?',
                content: 'You will need to sign in again next time.',
                onYes: () => _signOut(context),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          _heading('About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.pets, color: FB_PRIMARY),
                  title: CustomFont(
                    text: APP_NAME,
                    fontSize: 14.sp,
                    color: scheme.onSurface,
                  ),
                  subtitle: CustomFont(
                    text: 'Long Exam 1 - Facebook Replication',
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: CustomFont(
                    text: 'Jorge Fuertes',
                    fontSize: 14.sp,
                    color: scheme.onSurface,
                  ),
                  subtitle: CustomFont(
                    text: 'INF231',
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section label above each card.
  Widget _heading(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomFont(
        text: text,
        fontSize: 13.sp,
        color: FB_PRIMARY,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
