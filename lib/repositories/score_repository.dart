import '../services/realtime_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreRepository {
  final RealtimeDbService _db;
  ScoreRepository(this._db);

  Future<void> updateScore(String uid, Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;

    // ✅ First try getting email from user
    String name = user?.email ?? '';

    // ✅ If no email, try existing stored data
    if (name.isEmpty) {
      final existing = await _db.getScore(uid);
      if (existing != null && existing['email'] != null) {
        name = existing['email'];
      }
    }

    // ✅ Last fallback
    if (name.isEmpty) name = "Unknown User";

    data['displayName'] = name; // ✅ use email as name
    data['email'] = name; // ✅ store email too for safety

    await _db.setScore(uid, data);
  }

  Future<Map<String, dynamic>?> getScore(String uid) async {
    final snap = await _db.getScore(uid);
    if (snap == null) return null;
    return snap; // already Map<String, dynamic>
  }
}
