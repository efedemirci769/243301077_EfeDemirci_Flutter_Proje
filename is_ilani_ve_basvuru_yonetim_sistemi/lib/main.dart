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

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Değişkenler (state'ler)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'job_seeker'; // varsayılan rol
  bool _isLoading = false;
  bool _isSignUp = true; // kayıt mı giriş mi
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Kayıt ol fonksiyonu
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Supabase ile yeni kullanıcı oluştur
      final AuthResponse res = await Supabase.instance.client.auth
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final Session? session = res.session;
      final User? user = res.user;

      if (user != null && session != null) {
        // Kullanıcı profili oluştur
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'full_name': _emailController.text.split('@')[0],
          'role': _selectedRole,
        });

        // Log kaydı
        await Supabase.instance.client.from('logs').insert({
          'user_id': user.id,
          'action': 'sign_up',
          'detail': 'Yeni kullanıcı kayıt oldu. Rol: $_selectedRole',
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kayıt başarılı!')),
          );
        }
      }
    } on AuthException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Bir hata oluştu: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Giriş yap fonksiyonu
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Supabase ile giriş yap
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        // Log kaydı
        await Supabase.instance.client.from('logs').insert({
          'user_id': user.id,
          'action': 'sign_in',
          'detail': 'Kullanıcı giriş yaptı',
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Giriş başarılı!')),
          );
        }
      }
    } on AuthException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Bir hata oluştu: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İş İlanı Başvuru Uygulaması'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Text(
              _isSignUp ? 'Kayıt Ol' : 'Giriş Yap',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Email alanı
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'ornek@email.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Şifre alanı
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

           
            if (_isSignUp)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rol Seç',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'job_seeker',
                        child: Text('İş Arayan'),
                      ),
                      DropdownMenuItem(
                        value: 'employer',
                        child: Text('İşveren'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value ?? 'job_seeker';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Hata mesajı
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : (_isSignUp ? _signUp : _signIn),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(_isSignUp ? 'Kayıt Ol' : 'Giriş Yap'),
            ),
            const SizedBox(height: 16),

            
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUp = !_isSignUp;
                  _errorMessage = null;
                });
              },
              child: Text(
                _isSignUp
                    ? 'Zaten hesabın var mı? Giriş Yap'
                    : 'Hesabın yok mu? Kayıt Ol',
              ),
            ),
          ],
        ),
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
