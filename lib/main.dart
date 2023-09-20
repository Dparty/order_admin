import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:order_admin/restaurantPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './signin.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(title: "good"),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = "Nikin";

  void toSigninPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SigninPage();
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          WidgetsFlutterBinding.ensureInitialized();
          await availableCameras();
        },
        child: const Icon(Icons.navigation),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(token),
            Text(
              '_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
