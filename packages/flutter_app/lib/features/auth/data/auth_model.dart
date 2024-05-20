import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/servertimestamp_converter.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();
  factory AppUser({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String displayName,
    required String email,

    //photo
    @Default('') String photoURL,
    @ServerTimestampConverter() required dynamic createdAt,
    @Default('active') String status,
  }) = _AppUser;
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    final data = AppUser.fromJson(doc.data() as Map<String, dynamic>);
    return data.copyWith(id: doc.id);
  }
  factory AppUser.fromFirebaseUser(User? user) {
    return AppUser(
      id: user?.uid ?? '',
      displayName: user?.displayName ?? '',
      photoURL: user?.photoURL ?? '',
      email: user?.email ?? '',
      createdAt: FieldValue
          .serverTimestamp(), // You might need to adjust this depending on how you handle timestamps
      status: 'active',
    );
  }

  Map<String, dynamic> toDocument() {
    return toJson()..remove('id');
  }

  factory AppUser.empty() {
    return AppUser(
      createdAt: FieldValue.serverTimestamp(),
      displayName: '',
      email: '',
    );
  }

  bool get isEmpty => displayName.isEmpty;
}
