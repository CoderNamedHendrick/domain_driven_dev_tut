import 'package:domain_driven_tut/domain/auth/user.dart';
import 'package:domain_driven_tut/domain/core/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_auth;

extension FirebaseUserDomainX on f_auth.User? {
  User? toDomain() {
    if (this == null) {
      return null;
    }

    return User(
      id: UniqueId.fromUniqueString(this!.uid),
    );
  }
}
