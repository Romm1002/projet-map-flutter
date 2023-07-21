

import 'package:cloud_firestore/cloud_firestore.dart';

import '../globale.dart';

class MyUser {
  late String id;
  late String nom;
  late String prenom;
  Map? messages;
  String? avatar;
  double latitude = 48.8035403;
  double longitude = 2.1266886;

  String get fullName {
    return "$prenom $nom";
  }

  MyUser.defaut(){
    id = "upX4ECje0x3UY28cd9iU";
  }

  MyUser(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    nom = map["NOM"];
    prenom = map["PRENOM"];
    avatar = map["AVATAR"] ?? defaultImage;
    latitude = map["LATITUDE"] ?? 0.0;
    longitude = map["LONGITUDE"] ?? 0.0;
    messages = map["MESSAGES"];
  }


}