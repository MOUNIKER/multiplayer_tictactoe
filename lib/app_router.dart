import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/lobby_screen.dart';
import 'ui/screens/game_screen.dart';
import 'ui/screens/leaderboard_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/lobby':
        return MaterialPageRoute(builder: (_) => const LobbyScreen());
      case '/game':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => GameScreen(initParams: args));
      case '/leaderboard':
        return MaterialPageRoute(builder: (_) => const LeaderboardScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(body: Center(child: Text('No route for ${settings.name}'))));
    }
  }
}
