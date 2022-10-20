import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transporte_app/main.dart';
import 'package:transporte_app/router_delegate.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen(this.segment, {Key? key}) : super(key: key);

  final LoginSegment segment;

  static final TextEditingController _emailController = TextEditingController(text: "luisurbm@gmail.com");
  static final TextEditingController _passwordController =
      TextEditingController(text: "12345678");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transporte Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Su correo'),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Su contraseña',
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                print(
                    'Email: ${_emailController.text}, Password: ${_passwordController.text}');
                var result = await segment.authService.login(
                    email: _emailController.text,
                    password: _passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result!),
                  ),
                );
                if ('Bienvenido' == result) {
                  ref.read(routerDelegateProvider).navigate([HomeSegment()]);
                }
              },
              child: const Text('Ingresar'),
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextButton(
              onPressed: () {
                ref.read(routerDelegateProvider).navigate([RegisterSegment()]);
              },
              child: const Text('Registrarme'),
            ),
          ],
        ),
      ),
    );
  }
}
