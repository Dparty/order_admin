import 'package:flutter/material.dart';
import 'package:order_admin/api/utils.dart';
import 'package:order_admin/restaurantPage.dart';
import 'package:path/path.dart';
import 'signinPage.dart';

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
      title: "和食云",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void toSigninPage() async {
    Navigator.pushReplacement(this.context,
        MaterialPageRoute(builder: (context) => const SigninPage()));
  }

  @override
  void initState() {
    super.initState();
  }

  void init() {
    getToken().then((token) {
      if (token == "") {
        Navigator.pushReplacement(this.context,
            MaterialPageRoute(builder: (context) => const SigninPage()));
      } else {
        Navigator.pushReplacement(this.context,
            MaterialPageRoute(builder: (context) => const RestaurantsPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return const Scaffold(
      body: Text('Loading..'),
    );
  }
}
