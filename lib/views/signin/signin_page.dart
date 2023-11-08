import 'package:flutter/material.dart';
import 'package:order_admin/components/responsive.dart';
import 'signin_form.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          title: const Text('登入管理員帳號'),
          automaticallyImplyLeading: false,
        ),
        body: DefaultTextStyle.merge(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            child: Center(
              child: Container(
                  margin: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Image.asset(
                              "images/favicon.png",
                              width: 200,
                            ),
                          ])),
                      const Expanded(
                        child: SigninForm(),
                      )
                    ],
                  )),
            )),
      ),
      desktop: Row(
        children: [
          Expanded(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "images/favicon.png",
              width: 300,
            ),
          ])),
          Expanded(
            child: Material(
              color: Colors.white,
              child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(150.0),
                      child: const SigninForm(),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
