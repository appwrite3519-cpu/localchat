import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

class AuthController {
  AuthController(this._auth);
  final FirebaseAuth _auth;
  String? _verificationId;

  Future<void> sendOtp({
    required String e164Phone,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException e) onFailed,
    required void Function() onAutoVerified,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: e164Phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        onAutoVerified();
      },
      verificationFailed: onFailed,
      codeSent: (id, _) {
        _verificationId = id;
        onCodeSent(id);
      },
      codeAutoRetrievalTimeout: (id) => _verificationId = id,
    );
  }

  Future<UserCredential> confirmOtp(String smsCode, {String? verificationId}) {
    final id = verificationId ?? _verificationId;
    if (id == null) throw StateError('No verification id. Send OTP first.');
    return _auth.signInWithCredential(
      PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode),
    );
  }

  Future<void> signOut() => _auth.signOut();
}

final authControllerProvider = Provider(
  (ref) => AuthController(ref.watch(firebaseAuthProvider)),
);
