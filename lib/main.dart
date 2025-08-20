import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/firma_viewmodel.dart';
import 'viewmodels/musteri_viewmodel.dart';
import 'viewmodels/teklif_viewmodel.dart';

import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/demo_home_view.dart';
import 'views/settings_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => FirmaViewModel()),
        ChangeNotifierProvider(create: (_) => MusteriViewModel()),
        ChangeNotifierProvider(create: (_) => TeklifViewModel()),
      ],
      child: const ProposalApp(),
    ),
  );
}

class ProposalApp extends StatelessWidget {
  const ProposalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proposal App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WelcomeView(),
    );
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Proposal App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Teklif oluşturma ve yönetim uygulaması',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DemoHomeView()),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Demo Modunda Dene',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthWrapper()),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _callbackSetup = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Callback'i bir kez kur
        if (!_callbackSetup) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _setupUserCallback();
              setState(() {
                _callbackSetup = true;
              });
            }
          });
        }

        // Auth durumu yükleniyorsa loading göster
        if (authViewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Kullanıcı oturum açmışsa ana sayfaya, açmamışsa login sayfasına yönlendir
        if (authViewModel.user != null) {
          return const HomeView();
        } else {
          return const LoginView();
        }
      },
    );
  }

  void _setupUserCallback() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final firmaViewModel = Provider.of<FirmaViewModel>(context, listen: false);
    final musteriViewModel = Provider.of<MusteriViewModel>(context, listen: false);
    final teklifViewModel = Provider.of<TeklifViewModel>(context, listen: false);

    authViewModel.onUserChanged = (String userId) {
      if (userId.isNotEmpty) {
        firmaViewModel.setCurrentUserId(userId);
        musteriViewModel.setCurrentUserId(userId);
        teklifViewModel.setCurrentUserId(userId);
      } else {
        firmaViewModel.clearCurrentUserId();
        musteriViewModel.clearCurrentUserId();
        teklifViewModel.clearCurrentUserId();
      }
    };

    // Eğer zaten bir user varsa, hemen set et
    if (authViewModel.user != null) {
      firmaViewModel.setCurrentUserId(authViewModel.user!.uid);
      musteriViewModel.setCurrentUserId(authViewModel.user!.uid);
      teklifViewModel.setCurrentUserId(authViewModel.user!.uid);
    }
  }
}
