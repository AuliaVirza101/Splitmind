import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_colors.dart';

class ShellPage extends StatelessWidget {
  final Widget child;
  const ShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = location == '/analytics' ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/analytics');
          }
        },
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: AppColors.divider,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Groups',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
