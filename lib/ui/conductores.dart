import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transporte_app/main.dart';
import 'package:transporte_app/model/conductor.dart';
import 'package:transporte_app/router_delegate.dart';
import 'package:transporte_app/service/db.dart';

class ConductoresList extends StatelessWidget {
  final List<QueryDocumentSnapshot> _conductoresList;
  final WidgetRef ref;
  final DatabaseService db;
  const ConductoresList(this._conductoresList, this.ref, this.db, {Key? key})
      : super(key: key); // the list of movies we get via the Homescreen widget.

  static final routes = [HomeSegment(), MapaSegment(id: 1)];

  @override
  Widget build(BuildContext context) {
    return _conductoresList.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: _conductoresList.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              Conductor conductor =
                  Conductor.fromJson(_conductoresList[index].data());

              return Card(
                  elevation: 20,
                  child: ListTile(
                      // leading: Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Image.network(_conductoresList[index].get(
                      //       'celular')), // for displaying the movie poster image
                      // ),
                      minLeadingWidth: 10,
                      title: Text(
                        conductor.nombres,
                      ),
                      subtitle: Text(conductor.cedula),
                      trailing: Container(
                          height: 50,
                          width: 150,
                          color: Colors.amber[500],
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                IconButton(
                                  icon: const Icon(Icons.call_end_rounded),
                                  onPressed: () {
                                    ref.read(routerDelegateProvider).navigate([
                                      HomeSegment(),
                                      LlamadaSegment(
                                          id: 1,
                                          ref: ref,
                                          db: db,
                                          conductor: conductor)
                                    ]);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.route_rounded),
                                  onPressed: () {
                                    ref.read(routerDelegateProvider).navigate([
                                      HomeSegment(),
                                      MapaSegment(
                                          id: 1,
                                          ref: ref,
                                          db: db,
                                          conductor: _conductoresList[index].id)
                                    ]);
                                  },
                                )
                              ])))));
            })
        : const Center(child: Text('No Conductores registrados'));
  }
}
