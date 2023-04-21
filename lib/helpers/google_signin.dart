import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({'email': _user!.email,'admin': false});
      //TODO sve nazive kolekcija "users" u ovom slucaju i posle property po kojima setujes vrednosti trebalo bi izbaciti u neki fajl zato sto ih sigurno ne koristis samo na jednom mestu
      //TODO isto ne bi bilo lose da koristis primer sa servisom koji sam ti poslao na Slack. Tako bi mogao sve iz jednog fajla da hendlujes tako sto ces imati genericke metode kojima ces samo
      //TODO prosledjivati argumente

    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
