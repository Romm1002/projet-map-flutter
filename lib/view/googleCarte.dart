import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_flutter/model/user.dart';
import 'package:map_flutter/view/chatView.dart';

import '../globale.dart';

class CarteGoogle extends StatefulWidget {
  final Position location;
  CarteGoogle({Key? key, required this.location}) : super(key: key);

  @override
  State<CarteGoogle> createState() => _CarteGoogleState();
}

class _CarteGoogleState extends State<CarteGoogle> {
  //variable
  Completer<GoogleMapController> completer = Completer();
  late CameraPosition camera;
  List<MyUser> utilisateurs = [];
  BitmapDescriptor myCustomIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  @override
  void initState() {
    // TODO: implement initState
    camera = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 14,
    );
    super.initState();
    recupererUtilisateurs();
  }

  // Méthode pour récupérer les utilisateurs depuis Firebase
  void recupererUtilisateurs() async {
    try {
      // Récupérer la référence de la collection "utilisateurs" dans Firestore
      CollectionReference utilisateursRef = FirebaseFirestore.instance.collection('UTILISATEURS');

      // Récupérer tous les documents (utilisateurs) de la collection
      QuerySnapshot querySnapshot = await utilisateursRef.get();

      // Parcourir les documents récupérés et les ajouter à la liste 'utilisateurs'
      List<MyUser> listeUtilisateurs = [];
      querySnapshot.docs.forEach((document) {
        MyUser user = MyUser(document);
        if(user.id == me.id){
          me = user;
        }else{
          listeUtilisateurs.add(user);
        }
      });

      // Mettre à jour la liste d'utilisateurs dans l'état de notre widget
      setState(() {
        utilisateurs = listeUtilisateurs;
      });
    } catch (e) {
      // Gérer les erreurs éventuelles lors de la récupération des utilisateurs
      print("Erreur lors de la récupération des utilisateurs : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: camera,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (control) async{
        String newStyle = await DefaultAssetBundle.of(context).loadString("lib/mapStyle.json");
        control.setMapStyle(newStyle);
        completer.complete(control);
      },
      markers: utilisateurs.map((user) {
        return Marker(
          markerId: MarkerId(user.id),
          position: LatLng(user.latitude, user.longitude),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(
                builder : (context){
                  return ChatView(otherUser: user);
                }
            ));
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose), // Couleur de l'icône
          alpha: 1, // Transparence de l'icône
          infoWindow: InfoWindow(
            title: "Utilisateur ${user.fullName}",
            snippet: "Position : ${user.latitude}, ${user.longitude}", // Informations supplémentaires dans l'info-bulle
          ),
        );
      }).toSet(),
    );
  }
}
