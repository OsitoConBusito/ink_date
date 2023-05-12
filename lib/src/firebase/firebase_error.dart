enum FirebaseError {
  emailAlreadyInUse,
}

extension FirebaseErrorExtension on FirebaseError {
  static const String emailAlreadyInUse = 'email-already-in-use';

  String get codeError {
    switch (this) {
      case FirebaseError.emailAlreadyInUse:
        return emailAlreadyInUse;
    }
  }
}
