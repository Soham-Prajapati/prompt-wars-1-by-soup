import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stadium_iq/features/crowd/presentation/screens/venue_map_screen.dart';
import 'package:stadium_iq/features/orders/presentation/screens/queue_list_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/map',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/map',
          builder: (context, state) => const VenueMapScreen(),
        ),
        GoRoute(
          path: '/queues',
          builder: (context, state) => const QueueListScreen(),
        ),
        GoRoute(
          path: '/incidents',
          builder: (context, state) => const Center(child: Text('Incidents/SOS')),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Center(child: Text('Profile & Tickets')),
        ),
      ],
    ),
  ],
);

class ScaffoldWithBottomNavBar extends StatelessWidget {
  const ScaffoldWithBottomNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Queues'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'SOS'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/map')) return 0;
    if (location.startsWith('/queues')) return 1;
    if (location.startsWith('/incidents')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/map');
        break;
      case 1:
        context.go('/queues');
        break;
      case 2:
        context.go('/incidents');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
