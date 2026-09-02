import 'package:flutter/material.dart';
import 'package:mealdb_application/core/features/auth/views/profile_page.dart';
import 'package:mealdb_application/core/features/favorites__Local/views/fav_page.dart';
import 'package:mealdb_application/core/features/home/views/home_root.dart';
import 'package:mealdb_application/core/features/settings/views/settings_page.dart';
import 'package:mealdb_application/core/shared/bottom_nav_bar.dart';

class Root extends StatefulWidget {
  final int? H_index;
  final int? navIndex;
  const Root({super.key, this.H_index, this.navIndex});

  @override
  State<Root> createState() => _HomeRootState();
}

class _HomeRootState extends State<Root> {
  // inside _RootState
  int navIndex = 1; // whatever "home"/default tab you want
  void _onNavItemSelected(int index) {
    setState(() {
      navIndex = index;
    });
    // navigate to Settings / Favourites / Profile pages here,
    // e.g. Navigator.push(...) or swap another IndexedStack
  }

  int homeIndex = 0; // default to Home tab
  @override
  void initState() {
    super.initState();
    if (widget.H_index != null) {
      homeIndex = widget.H_index!;
    }
    if (widget.navIndex != null) {
      navIndex = widget.navIndex!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IndexedStack(
          index: navIndex,
          children: [
            FavPage(), // 0 - Favourites
            HomeRoot(count: homeIndex), // 1 - Home
            SettingsPage(), // 2 - Settings
            ProfilePage(), // 3 - Profile
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GlassBottomNav(
            selectedIndex: navIndex,
            onItemSelected: _onNavItemSelected,
          ),
        ),
      ],
    );
  }
}
