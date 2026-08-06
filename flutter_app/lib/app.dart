import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/login_screen.dart';
import 'features/collection/collection_screen.dart';
import 'theme/horoteca_theme.dart';

class HorotecaApp extends StatelessWidget {
  const HorotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horoteca',
      debugShowCheckedModeBanner: false,
      theme: HorotecaTheme.light,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;
    return StreamBuilder<AuthState>(
      stream: auth.onAuthStateChange,
      initialData:
          AuthState(AuthChangeEvent.initialSession, auth.currentSession),
      builder: (context, snapshot) {
        return snapshot.data?.session == null
            ? const LoginScreen()
            : const CollectionScreen();
      },
    );
  }
}
