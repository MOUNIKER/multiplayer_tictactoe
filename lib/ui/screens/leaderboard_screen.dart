import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: state.when(
        data: (list) {
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (ctx, i) {
              final item = list[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(
                  item['displayName'] ?? item['email'] ?? 'Unknown User',
                ),
                subtitle: Text(
                  'Wins: ${item['wins'] ?? 0}  Draws: ${item['draws'] ?? 0}',
                ),
                trailing: Text('${item['total'] ?? 0}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
