import 'package:contact_app/controller/contact_controller.dart';
import 'package:contact_app/controller/navbar_controller.dart';
import 'package:contact_app/firebase_options.dart';
import 'package:contact_app/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ContactFormProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contact App',
        theme: ThemeData(
          brightness: Brightness.dark,
          cardTheme: const CardTheme(color: Color.fromARGB(220, 32, 32, 32)),
          scaffoldBackgroundColor: const Color.fromARGB(255, 22, 22, 22),
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 22, 22, 22),
            iconTheme: IconThemeData(
              color: Color.fromARGB(255, 252, 252, 252),
            ),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 235, 235, 235),
          ),

          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
          ),

          // Text theme
          // textTheme: TextTheme(
          //    TextStyle(color: Colors.white),  // Body text set to white
          //   bodyText2: TextStyle(color: Colors.white),  // Secondary text set to white
          // ),
        ),
        home: NavBar(),
      ),
    );
  }
}
