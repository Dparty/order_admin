import 'package:flutter/material.dart';

// two column without navbar
class MainLayout extends StatelessWidget {
  final Widget center;
  final String centerTitle;
  final Widget? right;

  const MainLayout(
      {Key? key, required this.center, required this.centerTitle, this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            title: Text(centerTitle,
                style:
                    const TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
          ),
          body: center,
        )),
        const SizedBox(
          child: VerticalDivider(),
        ),
        right != null ? SizedBox(width: 420, child: right) : Container(),
      ],
    );
  }
}
