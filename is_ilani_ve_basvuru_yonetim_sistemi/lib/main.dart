import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://kgroxpuezhherunltxee.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtncm94cHVlemhoZXJ1bmx0eGVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NTY1MzIsImV4cCI6MjA5NDQzMjUzMn0.nDcVZp4UxxHXJTafNNkAyMdv106aGUAuIcgeiFnt5-8';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İş İlanı Başvuru Uygulaması',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? session;
  late final StreamSubscription<dynamic> _authSubscription;

  @override
  void initState() {
    super.initState();
    session = Supabase.instance.client.auth.currentSession;

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      setState(() {
        session = Supabase.instance.client.auth.currentSession;
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const SignInPage();
    }

    return const HomePage();
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş / Kayıt')),
      body: const Center(
        child: Text('Supabase API bilgilerini yapıştırdığınızda buradan devam ederiz.'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ana Sayfa')),
      body: const Center(
        child: Text('Supabase bağlantısı kuruldu. Şimdi auth ve veri ekranlarını ekleyelim.'),
      ),
    );
  }
}
