class AppUserModel {
  const AppUserModel({required this.uid, required this.email});

  final String uid;
  final String email;

  factory AppUserModel.fromFirebase({
    required String uid,
    required String? email,
  }) {
    return AppUserModel(uid: uid, email: email ?? '');
  }
}
