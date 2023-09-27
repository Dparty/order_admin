import 'package:flutter/material.dart';
import 'package:order_admin/api/utils.dart';
import 'package:order_admin/restaurantPage.dart';
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
  void toSigninPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SigninPage();
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.data! == "") {
            return const SigninPage();
          }
          return const RestaurantsPage();
        });
  }
}
