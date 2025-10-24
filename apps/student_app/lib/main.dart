import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cravit/home_page.dart'; // Import the new home_page.dart
import 'package:provider/provider.dart'; // Import provider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cravit/cart_provider.dart'; // Import CartProvider
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider
import 'package:cravit/favorite_provider.dart'; // Import FavoriteProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (context) => CartProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
        ChangeNotifierProvider<FavoriteProvider>(create: (context) => FavoriteProvider()), // Add FavoriteProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( // Use Consumer to listen to theme changes
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CraVIT',
          debugShowCheckedModeBanner: false,
          themeMode: (themeProvider as ThemeProvider).themeMode, // Use themeMode from ThemeProvider
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF70180E)),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF5EEEA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF70180E),
              foregroundColor: Color(0xFFF5EEEA),
              centerTitle: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF70180E),
                foregroundColor: const Color(0xFFF5EEEA),
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF70180E), brightness: Brightness.dark),
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF70180E),
              foregroundColor: Color(0xFFF5EEEA),
              centerTitle: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF70180E),
                foregroundColor: const Color(0xFFF5EEEA),
              ),
            ),
            // Define other dark theme settings here
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Sign in to your account'), // Set MyHomePage as the initial home route
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  // New method for Google Sign-In with Firebase Auth
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User cancelled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      await FirebaseAuth.instance.signInWithCredential(credential);

      // After successful sign-in, navigate to HomePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(googleSignIn: _googleSignIn, userEmail: googleUser.email, userName: googleUser.displayName, userPhotoUrl: googleUser.photoUrl)),
      );
    } catch (error) {
      print('Error during Google Sign-In: $error');
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _signInWithGoogle(); // Call the new _signInWithGoogle method
    } catch (e) {
      print('Error in _handleSignIn: $e');
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      print('Signed out from Google');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Sign in to your account')),
      );
    } catch (error) {
      print('Error signing out from Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text('Sign in to your account'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Log In',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 10),
            Text(
              'Sign into your existing account',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
            ),
            const SizedBox(height: 50),
            // Removed "I'm home" text
            ElevatedButton(
              onPressed: _signInWithGoogle, // Use the new sign-in method
              style: ElevatedButton.styleFrom(
                // Removed hardcoded background and foreground colors as they are now defined in ThemeData
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Sign In", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
