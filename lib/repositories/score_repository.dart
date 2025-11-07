import '../services/realtime_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreRepository {
  final RealtimeDbService _db;
  ScoreRepository(this._db);

 Future<void> updateScore(String uid, Map<String, dynamic> data) async {
  final user = FirebaseAuth.instance.currentUser;

  // Step 1: Fetch existing score if present
  final existing = await _db.getScore(uid) ?? {};

  // Step 2: Merge old data with new updates
  final updated = {
    ...existing,
    ...data,
  };

  // Step 3: Attach display name or fallback email
  if (user != null && user.uid == uid) {
    updated['displayName'] = user.displayName?.isNotEmpty == true
        ? user.displayName
        : (user.email ?? 'Anonymous');
  } else {
    // If for some reason currentUser doesn't match, retain old displayName
    updated['displayName'] ??= existing['displayName'] ?? 'Anonymous';
  }

  // Step 4: Compute total score dynamically
  final wins = updated['wins'] as int? ?? 0;
  final draws = updated['draws'] as int? ?? 0;
  updated['total'] = wins * 3 + draws * 1;

  // Step 5: Write merged data back
  await _db.setScore(uid, updated);
}

  Future<Map<String, dynamic>?> getScore(String uid) async {
    final snap = await _db.getScore(uid);
    if (snap == null) return null;
    return snap; // already Map<String, dynamic>
  }
}
