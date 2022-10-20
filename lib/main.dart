import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_navigator/riverpod_navigator.dart';
import 'package:transporte_app/router_delegate.dart';
import 'package:transporte_app/router_delegate.dart' as transporteDelegated;
import 'package:transporte_app/service/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: App()));
}

final counterProvider = StateNotifierProvider<UIPantalla, int>((ref) {
  return UIPantalla();
});

final routerDelegateProvider = Provider<transporteDelegated.RRouterDelegate>(
    (ref) => transporteDelegated.RRouterDelegate(
        ref, [LoginSegment(authService: AuthService())]));

final navigationStackProvider =
    StateProvider<transporteDelegated.TypedPath>((_) => [HomeSegment()]);

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _, WidgetRef ref) => MaterialApp.router(
        title: 'Riverpod Navigator Example',
        routerDelegate: ref.read(routerDelegateProvider),
        routeInformationParser:
            transporteDelegated.RouteInformationParserImpl(),
        debugShowCheckedModeBanner: false,
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(this.title),
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
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
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          // Respond to item press.
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
}

class UIPantalla extends StateNotifier<int> {
  UIPantalla() : super(0);
  void increment(final int pagina) => state = pagina;
}
