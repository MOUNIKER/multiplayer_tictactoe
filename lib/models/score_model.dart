class ScoreModel {
  final String uid;
  final String displayName;
  final int wins;
  final int losses;
  final int draws;
  final int total;

  ScoreModel({
    required this.uid,
    required this.displayName,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
  }) : total = wins * 3 + draws;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'displayName': displayName,
        'wins': wins,
        'losses': losses,
        'draws': draws,
        'total': total,
      };

  factory ScoreModel.fromMap(Map<dynamic, dynamic> m) {
    return ScoreModel(
      uid: m['uid'] as String,
      displayName: m['displayName'] as String? ?? '',
      wins: m['wins'] as int? ?? 0,
      losses: m['losses'] as int? ?? 0,
      draws: m['draws'] as int? ?? 0,
    );
  }
}
