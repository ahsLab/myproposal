import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'firebase_options.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/firma_viewmodel.dart';
import 'viewmodels/musteri_viewmodel.dart';
import 'viewmodels/teklif_viewmodel.dart';
import 'services/language_service.dart';

import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/demo_home_view.dart';
import 'views/settings_view.dart';
import 'utils/localization_helper.dart';

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
        ChangeNotifierProvider(create: (_) => LanguageService()),
      ],
      child: const ProposalApp(),
    ),
  );
}

class ProposalApp extends StatelessWidget {
  const ProposalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return MaterialApp(
          title: 'Proposal App',
          debugShowCheckedModeBanner: false,
          locale: languageService.appLocale,
          supportedLocales: LanguageService.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const WelcomeView(),
        );
      },
    );
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade600,
              Colors.blue.shade400,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Büyük ve renkli logo container
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    size: 100,
                    color: Colors.blue.shade600,
                  ),
                ),
                const SizedBox(height: 40),
                // Ana başlık
                Text(
                  LocalizationHelper.getString(context, 'appTitle'),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Açıklama
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    LocalizationHelper.getString(context, 'appDescription'),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                // Özellikler listesi
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureItem(Icons.business, 'Firma Yönetimi', 'Firmalarınızı kolayca yönetin'),
                      const SizedBox(height: 12),
                      _buildFeatureItem(Icons.people, 'Müşteri Yönetimi', 'Müşterilerinizi takip edin'),
                      const SizedBox(height: 12),
                      _buildFeatureItem(Icons.description, 'Teklif Oluşturma', 'Profesyonel teklifler hazırlayın'),
                      const SizedBox(height: 12),
                      _buildFeatureItem(Icons.picture_as_pdf, 'PDF Çıktısı', 'Tekliflerinizi PDF olarak kaydedin'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Demo butonu
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.orange.shade600],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DemoHomeView()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          LocalizationHelper.getString(context, 'tryDemoMode'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Giriş butonu
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthWrapper()),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login, color: Colors.blue.shade600, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          LocalizationHelper.getString(context, 'login'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
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
