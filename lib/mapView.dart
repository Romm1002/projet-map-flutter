import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_flutter/controller/permissionGps.dart';
import 'package:map_flutter/view/googleCarte.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: FutureBuilder<Position>(
        future: PermissionGps().init(),
          builder: (context, snap){
            if(snap.data == null){
              return Center(child: Text("Aucune donnée"));
            }
            else{
              Position location = snap.data!;
              return CarteGoogle(location: location);
            }
          }
      ),
    );
  }
}
