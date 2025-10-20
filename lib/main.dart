import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zihin_bahcesi/sayfalar/hos_geldin_sayfasi.dart';

import 'modeller/gorev.dart';
import 'modeller/kullanici_verileri.dart';
import 'modeller/tamamlanmis_gorev.dart';
import 'modeller/tema_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // --- BURAYI KONTROL ET / DÜZELT ---
  if (!Hive.isAdapterRegistered(0)) { // typeId 0 için
    Hive.registerAdapter(GorevAdapter()); // Görev adaptörünü kaydet
  }
  if (!Hive.isAdapterRegistered(2)) { // typeId 2 için
    Hive.registerAdapter(TamamlanmisGorevAdapter()); // Tamamlanmış Görev adaptörünü kaydet
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(KullaniciVerileriAdapter());
  }
  await Hive.openBox<KullaniciVerileri>('kullaniciVerileriKutusu');
  // Tam ekran modu (hemen uygula)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Uygulamayı hemen başlat (sistem splash süresini kısaltmak için init'i erteleyeceğiz)
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(temaProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zihin Bahçesi',
      theme: ThemeData( // AÇIK TEMA
        brightness: Brightness.light,
        primarySwatch: Colors.green, // Ana renk paleti
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Sayfa arka planı
        appBarTheme: const AppBarTheme( // AppBar stili
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black), // Geri butonu rengi
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme), // Fontlar
        cardTheme: CardTheme( // Kartların görünümü
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        // Diğer widget'ların açık tema stillerini buraya ekleyebilirsin
      ),
      darkTheme: ThemeData( // KOYU TEMA
        brightness: Brightness.dark,
        primarySwatch: Colors.teal, // Koyu tema için farklı bir ana renk
        scaffoldBackgroundColor: const Color(0xFF121212), // Koyu arka plan
        appBarTheme: const AppBarTheme( // Koyu AppBar stili
          backgroundColor: Color(0xFF1E1E1E), // Biraz daha açık koyu
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply( // Font renklerini ayarla
          bodyColor: Colors.white70,
          displayColor: Colors.white,
        ),
        cardTheme: CardTheme( // Koyu tema kartları
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xFF1E1E1E), // Kart arka planı
        ),
        // Diğer widget'ların koyu tema stillerini buraya ekleyebilirsin
        // Örneğin, Switch'in aktif rengi
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.tealAccent; // Aktifken
            }
            return Colors.grey; // Pasifken
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.tealAccent.withOpacity(0.5);
            }
            return Colors.grey.shade800;
          }),
        ),
      ),
      // Android 12 sistem splash arka planından sonra hemen tam ekran görsel göstermek için
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Image.asset(
          'assets/splash/splash_image.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> _bootstrap() async {
    // Başlangıç işlemlerini splash sırasında yap, fakat en az 1200ms göster
    final init = _initializeServices();
    final minShow = Future.delayed(const Duration(milliseconds: 1200));
    await Future.wait([init, minShow]);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HosGeldinSayfasi()),
    );
  }

  Future<void> _initializeServices() async {

  }
}