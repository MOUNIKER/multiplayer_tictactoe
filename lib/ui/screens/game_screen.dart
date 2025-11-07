import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../widgets/game_board.dart';

class GameScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initParams;
  const GameScreen({super.key, this.initParams});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late final String roomId;
  late final bool isHost;
  @override
  void initState() {
    super.initState();
    roomId = widget.initParams?['roomId'] as String;
    isHost = widget.initParams?['isHost'] as bool? ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) => _initGame());
  }

  Future<void> _initGame() async {
    final auth = ref.read(authViewModelProvider).asData?.value;
    if (auth == null) return;

    final roomRepo = ref.read(roomRepositoryProvider);
    final gmVM = ref.read(gameViewModelProvider(roomId).notifier);

    // Listen for room changes so we know when guest joins
    roomRepo.roomStream(roomId).listen((room) async {
      if (room == null) return;

      // Get current game
      final gmState = ref.read(gameViewModelProvider(roomId));
      final game = gmState.asData?.value;

      // Host should start the game when guest joins AND game isn't created
      if (isHost && room.guestUid != null && game == null) {
        await gmVM.createInitialGame(room.hostUid, room.guestUid!);
      }
    });
  }

  void _onCellTap(int index) {
    final auth = ref.read(authViewModelProvider).asData?.value;
    if (auth == null) return;
    ref.read(gameViewModelProvider(roomId).notifier).makeMove(auth.uid, index);
  }

  @override
  Widget build(BuildContext context) {
    final gmState = ref.watch(gameViewModelProvider(roomId));
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: gmState.when(
        data: (model) {
          if (model == null) {
            return const Center(child: Text('Waiting for game to start...'));
          }

          final auth = ref.read(authViewModelProvider).asData?.value;
          final roomRepo = ref.read(roomRepositoryProvider);

          return FutureBuilder(
            future: roomRepo.roomStream(roomId).first,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final room = snapshot.data!;
              String winnerEmail = '';
              String status = '';

              // Determine whose UID matches the winner
              if (model.finished) {
                if (model.winner == 'draw') {
                  status = 'Draw';
                } else {
                  if (model.winner == room.hostUid) {
                    winnerEmail =
                        'Winner: ${room.hostUid == auth?.uid ? auth?.email ?? "" : "Host"}';
                  } else if (model.winner == room.guestUid) {
                    winnerEmail =
                        'Winner: ${room.guestUid == auth?.uid ? auth?.email ?? "" : "Guest"}';
                  }
                  status = winnerEmail;
                }
              } else {
                status =
                    'Turn: ${model.currentTurn == auth?.uid ? "You" : "Opponent"}';
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      status,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    GameBoard(
                      board: model.board,
                      enabled: !model.finished,
                      onCellTap: _onCellTap,
                    ),
                    const SizedBox(height: 16),
                    if (model.finished)
                      Column(
                        children: [
                          const Text('Game Finished'),
                          ElevatedButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushReplacementNamed('/lobby'),
                            child: const Text('Back to Lobby'),
                          ),
                        ],
                      ),
                  ],
                ),
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
