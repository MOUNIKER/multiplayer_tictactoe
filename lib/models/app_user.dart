import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  AppUser copyWith({String? displayName, String? photoUrl}) {
    return AppUser(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'photoUrl': photoUrl,
  };

  factory AppUser.fromMap(Map<dynamic, dynamic> m) {
    return AppUser(
      uid: m['uid'] as String,
      displayName: m['displayName'] as String?,
      email: m['email'] as String?,
      photoUrl: m['photoUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl];
}
