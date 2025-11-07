import 'package:equatable/equatable.dart';

class RoomModel extends Equatable {
  final String roomId;
  final String hostUid;
  final String? guestUid;
  final bool isOpen;

  const RoomModel({
    required this.roomId,
    required this.hostUid,
    this.guestUid,
    this.isOpen = true,
  });

  Map<String, dynamic> toMap() => {
    'roomId': roomId,
    'hostUid': hostUid,
    'guestUid': guestUid,
    'isOpen': isOpen,
  };

  factory RoomModel.fromMap(Map<dynamic, dynamic> m) {
    return RoomModel(
      roomId: m['roomId'] as String,
      hostUid: m['hostUid'] as String,
      guestUid: m['guestUid'] as String?,
      isOpen: m['isOpen'] as bool? ?? true,
    );
  }

  RoomModel copyWith({String? guestUid, bool? isOpen}) {
    return RoomModel(
      roomId: roomId,
      hostUid: hostUid,
      guestUid: guestUid ?? this.guestUid,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  @override
  List<Object?> get props => [roomId, hostUid, guestUid, isOpen];
}
