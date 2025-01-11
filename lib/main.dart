import 'package:eventprimeadmin/app_screen/home_screen.dart';
import 'package:eventprimeadmin/app_screen/login_screen.dart';
import 'package:eventprimeadmin/global/color.dart';
import 'package:eventprimeadmin/global/utils.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper binding
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getDefaultHome() async {
    // Fetch the user type
    String userType = await getUserType();
    if (userType == "general") {
      // If the user type is "general", navigate to HomeScreen
      return const HomeScreen();
    } else {
      // Otherwise, navigate to LoginScreen
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Prime Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu',
        textTheme: TextTheme(
          bodySmall: textTheme(),
          labelLarge: textTheme(),
          labelSmall: textTheme(),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: black,
            fontFamily: "Ubuntu",
            fontSize: 18,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getDefaultHome(), // Call the function to determine the default screen
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the future to complete
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors gracefully
            return Scaffold(
              body: Center(child: Text("An error occurred: ${snapshot.error}")),
            );
          } else {
            // Render the default home screen based on user type
            return snapshot.data!;
          }
        },
      ),
    );
  }

  TextStyle textTheme() {
    return const TextStyle(
      letterSpacing: 1.0,
    );
  }
}
