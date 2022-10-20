import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transporte_app/main.dart';
import 'package:transporte_app/model/conductor.dart';
import 'package:transporte_app/notifier/conductores.dart';
import 'package:transporte_app/router_delegate.dart';
import 'package:transporte_app/service/db.dart';
import 'package:transporte_app/ui/conductores.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen(this.segment, {Key? key}) : super(key: key);

  final HomeSegment segment;

  static final routes = [
    HomeSegment(),
    MapaSegment(id: 1),
    RutasSegment(),
    ActividadSegment(),
  ];

// final todosProvider = StateNotifierProvider<ConductoresNotifier, List<Conductor>>((ref) {
//   return ConductoresNotifier();
// });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
// List<Conductor> conductores = ref.watch(databaseProvider);
    final database = ref.read(databaseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transportadores'),
      ),
      body: Center(
          child: StreamBuilder(
        // Lets just use a stream builder that will listen to our Database class stream (a list of all documents/movies)
        stream: database
            .allConductores, // the stream that provides all our data from the firestore database with real time changes
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
          return ConductoresList((snapshot.data as QuerySnapshot)
              .docs, ref, database); // Finally return a widget that shows a list of movies . (snapshot.data.docs is the list of all documents )
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: ref.watch(counterProvider),
        onTap: (value) {
          // Respond to item press.
          ref.read(counterProvider.notifier).increment(value);
          if (value != 0) {
            ref
                .read(routerDelegateProvider)
                .navigate([routes[0], routes.elementAt(value)]);
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Inicio',
            icon: Icon(Icons.car_rental),
          ),
          BottomNavigationBarItem(
            label: 'Mapa',
            icon: Icon(Icons.map_rounded)
          ),
          BottomNavigationBarItem(
            label: 'Rutas',
            icon: Icon(Icons.route_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Actividad',
            icon: Icon(Icons.library_books),
          ),
        ],
      ),
    );
  }
}
