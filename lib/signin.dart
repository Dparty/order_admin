import 'package:flutter/material.dart';
import "package:order_admin/restaurantPage.dart";
import "package:shared_preferences/shared_preferences.dart";
import "api/account.dart";

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登入管理員帳號')),
      body: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(50.0),
              child: const SigninForm(),
            ),
          )),
    );
  }
}

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  void signin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    signinApi(email.text, password.text).then((session) {
      prefs.setString('token', session.token).then((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RestaurantsPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        key: _formKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
              hintText: '帳號',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return '請輸入帳號';
              }
              return null;
            },
          ),
          TextFormField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '密碼',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return '請輸入密碼';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                signin(context);
              },
              child: const Text('登入'),
            ),
          ),
        ],
      ),
    );
  }
}
