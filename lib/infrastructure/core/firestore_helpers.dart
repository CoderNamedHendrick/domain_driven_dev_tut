import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_driven_tut/domain/auth/i_auth_facade.dart';
import 'package:domain_driven_tut/domain/core/errors.dart';
import 'package:domain_driven_tut/injection.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
