import 'package:flutter/material.dart';
// import 'package:fluttercookie/bottom_bar.dart';
import 'cookie_page.dart';

class ConfigItem extends StatefulWidget {
  final List itemList;
  // const ConfigItem(this.itemList, {super.key});
  const ConfigItem({Key? key, required this.itemList}) : super(key: key);

  @override
  _ConfigItemState createState() => _ConfigItemState();
}

class _ConfigItemState extends State<ConfigItem>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late List itemList;

  @override
  void initState() {
    super.initState();
    itemList = widget.itemList;
    print(itemList.length);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {},
        ),
        title: const Text('新增品項',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Color(0xFF545D68))),
        actions: <Widget>[
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFF545D68)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.0),
        children: <Widget>[
          // SizedBox(height: 15.0),
          // Text('Categories',
          //     style: TextStyle(
          //         fontFamily: 'Varela',
          //         fontSize: 42.0,
          //         fontWeight: FontWeight.bold)),
          // SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                  flex: 8,
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.transparent,
                      labelColor: Color(0xFFC88D67),
                      isScrollable: true,
                      labelPadding: EdgeInsets.only(right: 45.0),
                      unselectedLabelColor: Color(0xFFCDCDCD),
                      tabs: [
                        Tab(
                          child: Text('所有品項',
                              style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 18.0,
                              )),
                        ),
                        Tab(
                          child: Text('燒鳥',
                              style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 18.0,
                              )),
                        ),
                        Tab(
                          child: Text('炸物',
                              style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 18.0,
                              )),
                        )
                      ])),
              Expanded(
                  child: SizedBox(
                width: 20,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    child: Text("新增品項"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC88D67),
                      elevation: 0,
                    ),
                    onPressed: () {},
                  ),
                  // ),
                ),
              ))
            ],
          ),

          Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: double.infinity,
              child: TabBarView(controller: _tabController, children: [
                CookiePage(itemList: widget.itemList),
                CookiePage(itemList: widget.itemList),
                CookiePage(itemList: widget.itemList),

                // CookiePage(),
                // CookiePage(),
              ]))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xFFF17532),
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      // bottomNavigationBar: BottomBar(),
    );
  }
}
