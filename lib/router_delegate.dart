import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transporte_app/actividad_ui.dart';
import 'package:transporte_app/create_cuenta.dart';
import 'package:transporte_app/home_ui.dart';
import 'package:transporte_app/login.dart';
import 'package:transporte_app/main.dart';
import 'package:transporte_app/mapa_ui.dart';
import 'package:transporte_app/model/conductor.dart';
import 'package:transporte_app/rutas_ui.dart';
import 'package:transporte_app/screen/llamada.dart';
import 'package:transporte_app/service/auth.dart';
import 'package:transporte_app/service/db.dart';

class RRouterDelegate extends RouterDelegate<TypedPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TypedPath> {
  RRouterDelegate(this.ref, this.homePath) {
    final unlisten =
        ref.listen(navigationStackProvider, (_, __) => notifyListeners());
    ref.onDispose(unlisten.close);
  }

  final Ref ref;
  final TypedPath homePath;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  TypedPath get currentConfiguration => ref.read(navigationStackProvider);

  @override
  Widget build(BuildContext context) {
    final navigationStack = currentConfiguration;
    if (navigationStack.isEmpty) return const SizedBox();

    Widget screenBuilder(TypedSegment segment) {
      if (segment is HomeSegment) return HomeScreen(segment);
      if (segment is LoginSegment) return LoginScreen(segment);
      if (segment is RegisterSegment) return CreateAccount(segment);
      if (segment is MapaSegment) return MapaScreen(segment);
      if (segment is RutasSegment) return RutasScreen(segment);
      if (segment is ActividadSegment) return ActividadScreen(segment);
      if (segment is LlamadaSegment) return LlamadaScreen(segment);
      throw UnimplementedError();
    }

    return Navigator(
        key: navigatorKey,
        pages: ref
            .read(navigationStackProvider)
            .map((segment) => MaterialPage(
                key: ValueKey(segment.toString()),
                child: screenBuilder(segment)))
            .toList(),
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          final notifier = ref.read(navigationStackProvider.notifier);
          if (notifier.state.length <= 1) return false;
          notifier.state = [
            for (var i = 0; i < notifier.state.length - 1; i++)
              notifier.state[i]
          ];
          return true;
        });
  }

  @override
  Future<void> setNewRoutePath(TypedPath configuration) {
    if (configuration.isEmpty) configuration = homePath;
    ref.read(navigationStackProvider.notifier).state = configuration;
    return SynchronousFuture(null);
  }

  void navigate(TypedPath newPath) =>
      ref.read(navigationStackProvider.notifier).state = newPath;
}

typedef JsonMap = Map<String, dynamic>;

abstract class TypedSegment {
  factory TypedSegment.fromJson(JsonMap json) =>
      json['runtimeType'] == 'BookSegment'
          ? MapaSegment(id: json['id'])
          : HomeSegment();

  JsonMap toJson() => <String, dynamic>{'runtimeType': runtimeType.toString()};
  @override
  String toString() => jsonEncode(toJson());
}

typedef TypedPath = List<TypedSegment>;

class HomeSegment with TypedSegment {}

class LoginSegment with TypedSegment {
  LoginSegment({required this.authService});
  final AuthService authService;
}

class RegisterSegment with TypedSegment {}

class RutasSegment with TypedSegment {}

class ActividadSegment with TypedSegment {}

class MapaSegment with TypedSegment {
  MapaSegment({required this.id, this.ref, this.db, this.conductor});
  final int id;
  WidgetRef? ref;
  DatabaseService? db;
  String? conductor;
  
  @override
  JsonMap toJson() => super.toJson()..['id'] = id;
}

class LlamadaSegment with TypedSegment {
  LlamadaSegment({required this.id, this.ref, this.db, this.conductor});
  final int id;
  WidgetRef? ref;
  DatabaseService? db;
  Conductor? conductor;
  
  @override
  JsonMap toJson() => super.toJson()..['id'] = id;
}

class RouteInformationParserImpl extends RouteInformationParser<TypedPath> {
  @override
  Future<TypedPath> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(path2TypedPath(routeInformation.location));

  @override
  RouteInformation restoreRouteInformation(TypedPath configuration) =>
      RouteInformation(location: typedPath2Path(configuration));

  static String typedPath2Path(TypedPath typedPath) => typedPath
      .map((s) => Uri.encodeComponent(jsonEncode(s.toJson())))
      .join('/');

  static String debugTypedPath2Path(TypedPath typedPath) =>
      typedPath.map((s) => jsonEncode(s.toJson())).join('/');

  static TypedPath path2TypedPath(String? path) {
    if (path == null || path.isEmpty) return [];
    return [
      for (final s in path.split('/'))
        if (s.isNotEmpty) TypedSegment.fromJson(jsonDecode(Uri.decodeFull(s)))
    ];
  }
}
