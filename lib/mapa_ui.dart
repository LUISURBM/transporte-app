import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transporte_app/model/recorrido.dart';
import 'package:transporte_app/service/db.dart';

import 'router_delegate.dart';

class MapaScreen extends ConsumerWidget {
  const MapaScreen(this.segment, {Key? key}) : super(key: key);

  final MapaSegment segment;

  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  static late GoogleMapController mapController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (null != segment.conductor) {
      var database = ref.read(databaseProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text('Rutas ${segment.conductor}'),
        ),
        body: FutureBuilder<List<Recorrido>>(
          // Lets just use a stream builder that will listen to our Database class stream (a list of all documents/movies)
          future: database.getRoutesUser(segment
              .conductor!), // the stream that provides all our data from the firestore database with real time changes
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show a CircularProgressIndicator when the stream is loading
            }
            if (snapshot.error != null) {
              return Center(
                  child: Text(
                      'Some error occurred')); // Show an error just in case(no internet etc)
            }
            return Container(
              height: height,
              width: width,
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                      initialCameraPosition: _kInitialPosition,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      markers:
                          snapshot.data!.map((e) => e.marcador).reduce((v, e) {
                        v.addAll(e);
                        return v;
                      }).toSet(),
                      polylines: snapshot.data!.map((e) => e.ruta).toSet(),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.orange.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.orange, // inkwell color
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.my_location),
                          ),
                          onTap: () {
                            // TODO: Add the operation to be performed
                            // on button tap
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductores'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
      ),
    );
  }
}
