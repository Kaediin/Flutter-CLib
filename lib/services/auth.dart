
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttermclib/shared/globals.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth change user stream
//  Stream<FirebaseUser> get user {
//    return _auth.onAuthStateChanged;
//  }

  Stream<FirebaseUser> get currentUser {
    return _auth.onAuthStateChanged;
  }

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  // Sign in with Google
  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: gSA.idToken, accessToken: gSA.accessToken);
    final AuthResult result = await _auth.signInWithCredential(credential);
    final FirebaseUser user = result.user;

    print("${user.displayName}\n${user.uid}");

    return user;
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future singOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
