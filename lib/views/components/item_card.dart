import 'package:flutter/material.dart';
import 'package:order_admin/api/config.dart';

Widget itemCard(BuildContext context, item, {Function()? onTap}) {
  return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3.0,
                        blurRadius: 5.0)
                  ],
                  color: Colors.white),
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeInImage(
                          image: NetworkImage(
                            item!.images.isEmpty
                                ? defaultImage
                                : item.images[0],
                          ),
                          fit: BoxFit.fitHeight,
                          placeholder: const AssetImage("images/default.png"),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    color: Color(0xFF575E67), fontSize: 12.0)),
                            Text("\$${(item.pricing / 100).toString()}",
                                style: const TextStyle(
                                    color: Color(0xFFCC8053), fontSize: 12.0)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ]))));
}
