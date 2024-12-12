import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frazello/features/app/presentation/pages/language_list_page.dart';
import 'package:frazello/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isProgressBar = false;

  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (event.session != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LanguageListPage()),
            (e) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isProgressBar
            ? const CircularProgressIndicator()
            : SizedBox(
                width: 300,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "E-mail",
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Password",
                        ),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        child: const Text("Login"),
                        onPressed: () async {
                          try {
                            setState(() => isProgressBar = true);

                            final email = emailController.text;
                            final password = passwordController.text;

                            await Supabase.instance.client.auth
                                .signInWithPassword(
                              password: password,
                              email: email,
                            );
                          } catch (e) {
                            logger.w(e);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            setState(() => isProgressBar = false);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
