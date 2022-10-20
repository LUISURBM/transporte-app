
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transporte_app/main.dart';
import 'package:transporte_app/router_delegate.dart';

class RutasScreen extends ConsumerWidget {
  const RutasScreen(this.segment, {Key? key}) : super(key: key);

  final RutasSegment segment;

  @override
  Widget build(BuildContext _, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: const Text('Riverpod App Rutas'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 1; i < 4; i++) ...[
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => ref.read(routerDelegateProvider).navigate([
                    RutasSegment(),
                    MapaSegment(id: i),
                    if (i > 1) MapaSegment(id: 10 + i),
                    if (i > 2) MapaSegment(id: 100 + i),
                  ]),
                  child: Text(
                      'Go to Book: [$i${i > 1 ? ', 1$i' : ''}${i > 2 ? ', 10$i' : ''}]'),
                ),
              ]
            ],
          ),
        ),
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
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Inicio',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'Mapa',
            icon: Icon(Icons.music_note),
          ),
          BottomNavigationBarItem(
            label: 'Rutas',
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            label: 'Actividad',
            icon: Icon(Icons.library_books),
          ),
        ],
      ),
      );
}
