import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登入')),
      // Inherit MaterialApp text theme and override font size and font weight.
      body: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(50.0),
              child: const FormExample(),
            ),
          )),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final account = TextEditingController();
  final password = TextEditingController();
  String good = "init";
  void signin() {
    setState(() {
      good = account.text;
      // Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        key: _formKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(good),
          TextFormField(
            controller: account,
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
                signin();
                if (_formKey.currentState!.validate()) {
                  signin();
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
