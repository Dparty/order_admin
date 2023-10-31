import 'package:flutter/material.dart';
import 'package:order_admin/views/components/navbar.dart';

class DefaultLayout extends StatelessWidget {
  final Widget? left;
  final Widget center;
  final String centerTitle;
  final Widget? right;

  const DefaultLayout(
      {Key? key,
      this.left,
      required this.center,
      required this.centerTitle,
      this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: left ?? const NavBar(),
        ),
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
        SizedBox(
          // height: MediaQuery.of(context).size.height,
          child: const VerticalDivider(),
        ),
        right != null ? SizedBox(width: 420, child: right) : Container(),
      ],
    );
  }
}
