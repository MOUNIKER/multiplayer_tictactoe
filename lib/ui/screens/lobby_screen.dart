import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../models/room_model.dart';
import '../../models/app_user.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  Future<void> _createRoom(
    BuildContext ctx,
    WidgetRef ref,
    AppUser user,
  ) async {
    final vm = ref.read(lobbyViewModelProvider.notifier);
    final room = await vm.createRoom(user.uid);
    Navigator.of(
      ctx,
    ).pushNamed('/game', arguments: {'roomId': room.roomId, 'isHost': true});
  }

  Future<void> _joinRoom(
    BuildContext ctx,
    WidgetRef ref,
    RoomModel room,
    AppUser user,
  ) async {
    final vm = ref.read(lobbyViewModelProvider.notifier);
    await vm.joinRoom(room.roomId, user.uid);
    Navigator.of(
      ctx,
    ).pushNamed('/game', arguments: {'roomId': room.roomId, 'isHost': false});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final lobbyState = ref.watch(lobbyViewModelProvider);

    final user = authState.whenOrNull(data: (u) => u);
    if (user == null) {
      Future.microtask(() => Navigator.of(context).pushReplacementNamed('/'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/leaderboard'),
            icon: const Icon(Icons.leaderboard),
          ),
          IconButton(
            onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(lobbyViewModelProvider.notifier).refresh(),
        child: lobbyState.when(
          data: (rooms) {
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create Room'),
                  onPressed: () => _createRoom(context, ref, user),
                ),
                const SizedBox(height: 12),
                Text(
                  'Open Rooms',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (rooms.isEmpty)
                  const Center(child: Text('No open rooms. Create one!')),
                ...rooms.map(
                  (r) => Card(
                    child: ListTile(
                      title: Text('Room ${r.roomId.substring(0, 6)}'),
                      subtitle: Text('Host: ${r.hostUid}'),
                      trailing: ElevatedButton(
                        child: const Text('Join'),
                        onPressed: () => _joinRoom(context, ref, r, user),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
