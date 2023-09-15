import 'package:flutter/material.dart';
import "api/account.dart";
import "api/config.dart";

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登入管理者帳號')),
      // Inherit MaterialApp text theme and override font size and font weight.
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
  void signin(BuildContext context) {
    signinApi(email.text, password.text).then((session) {
      Navigator.pop(context);
      setState(() {
        setToken(session.token);
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
