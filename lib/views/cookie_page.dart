import 'package:flutter/material.dart';
import 'item_detail.dart';

class CookiePage extends StatelessWidget {
  final List itemList;
  const CookiePage({Key? key, required this.itemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
              padding: EdgeInsets.only(right: 15.0),
              width: MediaQuery.of(context).size.width - 30.0,
              height: MediaQuery.of(context).size.height - 50.0,
              child: GridView.count(
                  crossAxisCount: 3,
                  primary: false,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 15.0,
                  // childAspectRatio: 0.8,
                  childAspectRatio: (itemWidth / itemHeight),
                  children: [
                    ...itemList
                        .map(
                          (item) => _buildCard(
                              item.name,
                              "\$${(item.pricing / 100).toString()}",
                              'https://ordering-uat-1318552943.cos.ap-hongkong.myqcloud.com/items/1716281980691156992',
                              false,
                              false,
                              context),
                        )
                        .toList()
                  ])),
          const SizedBox(height: 15.0)
        ],
      ),
    );
  }

  Widget _buildCard(String name, String price, String imgPath, bool added,
      bool isFavorite, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ItemDetail(
                      assetPath: imgPath,
                      cookieprice: price,
                      cookiename: name)));
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isFavorite
                                ? Icon(Icons.delete_forever,
                                    color: Color(0xFFC88D67))
                                : Icon(Icons.delete_outlined,
                                    color: Color(0xFFC88D67))
                          ])),
                  Hero(
                      tag: imgPath,
                      child: Container(
                          height: 75.0,
                          // width: 175.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(imgPath),
                                // image: AssetImage('images/favicon.png'),
                                // fit: BoxFit.cover,
                                onError: (err, stackTrace) =>
                                    AssetImage('images/favicon.png')),
                            // image: DecorationImage(
                            //     image: AssetImage(imgPath),
                            //     fit: BoxFit.contain)
                          ))),
                  SizedBox(height: 7.0),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 55.0, right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(name,
                              style: TextStyle(
                                  color: Color(0xFF575E67),
                                  fontFamily: 'Varela',
                                  fontSize: 12.0)),
                        ),
                        Spacer(),
                        Expanded(
                          child: Text(price,
                              style: TextStyle(
                                  color: Color(0xFFCC8053), fontSize: 12.0)),
                        ),
                      ],
                    ),
                  )
                ]))));
  }
}
