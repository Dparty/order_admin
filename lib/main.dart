import 'package:flutter/material.dart';
import 'package:order_admin/api/utils.dart';
import 'package:order_admin/provider/selected_printer_provider.dart';
import 'package:order_admin/views/restaurant_page.dart';
import 'package:path/path.dart';
import 'package:order_admin/views/signin/signin_page.dart';
import 'package:provider/provider.dart';
import 'provider/selection_button_provider.dart';
import 'provider/restaurant_provider.dart';
import 'provider/selected_table_provider.dart';
import 'provider/shopping_cart_provider.dart';

import 'configs/theme.dart';

void main() {
  // runApp(const App());
  runApp(MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectionButtonProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => SelectedTableProvider()),
        ChangeNotifierProvider(create: (_) => SelectedPrinterProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),

        // ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ],
      child: MaterialApp(
        title: "和食云",
        theme: AppTheme.lightTheme(context),
        home: HomePage(),
      ),
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
