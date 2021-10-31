import 'package:election_exit_poll_07610459/models/election_items.dart';
import 'package:election_exit_poll_07610459/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ElectionItems>> _futureElecList;

  @override
  initState() {
    super.initState();
    // เก็บ Future ที่ได้จาก _loadFoods ลงใน state variable
    // แล้วทำการ build widget จากตัวแปรนี้ โดยใช้ FutureBuilder มาช่วย
    _futureElecList = _loadElec();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
        ),
        child: FutureBuilder<List<ElectionItems>>(
          // ข้อมูลจะมาจาก Future ที่ระบุให้กับ parameter นี้
          future: _futureElecList,
          // ระบุ callback function ซึ่งใน callback นี้เราจะต้อง return widget ที่เหมาะสมออกไป
          // โดยดูจากสถานะของ Future (เช็คสถานะได้จากตัวแปร snapshot)
          builder: (context, snapshot) {
            // กรณีสถานะของ Future ยังไม่สมบูรณ์
            if (snapshot.connectionState != ConnectionState.done) {
              return Column(
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            // กรณีสถานะของ Future สมบูรณ์แล้ว แต่เกิด Error
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('ผิดพลาด: ${snapshot.error}'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureElecList = _loadElec();
                        });
                      },
                      child: Text('RETRY'),
                    ),
                  ],
                ),
              );
            }
            // กรณีสถานะของ Future สมบูรณ์ และสำเร็จ
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var eItem = snapshot.data![index];
                  return Column(
                    children: [
                      index == 0 ? Column(
                          children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/vote_hand.png",
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children : [
                                Text('EXIT POLL',style: TextStyle(fontSize: 30,color: Colors.white),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children : [
                                Text('เลือกตั้ง อบต',style: TextStyle(fontSize: 30,color: Colors.white),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('รายชื่อผู้สมัครรับเลือกตั้ง\nนายกองค์การบริหารส่วยตำบลเขาพระ\nอำเภอเมืองนครนายก จังหวัดนครนายก',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.white),),
                              ],
                            ),
                      ]
                      ):SizedBox.shrink(),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: EdgeInsets.all(8.0),
                        elevation: 5.0,
                        shadowColor: Colors.black.withOpacity(0.2),
                        child: InkWell(
                          onTap: () => _handleClickFoodItem(eItem),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${eItem.number} ${eItem.displayName}',
                                            style: GoogleFonts.prompt(
                                                fontSize: 20.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<List<ElectionItems>> _loadElec() async {
    List list = await Api().fetch('exit_poll');
    var elist = list.map((item) => ElectionItems.fromJson(item)).toList();
    print(list);
    return elist;
  }

  /*Future<List<ElectionItems>> _postElec() async {
    List list = await Api().submit('exit_poll');
    var elist = list.map((item) => ElectionItems.fromJson(item)).toList();
    print(list);
    return elist;
  }*/

  _handleClickFoodItem(ElectionItems ElecItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('บันทึกข้อมูลสำเร็จ',
              style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
