import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swananda/Wishes.dart';

import 'devotee_screen.dart';
import 'firebase_options.dart';

// Fields to be added: Nakshatra, Gowthra, Rashi, Category, Referred by

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return ScreenUtilInit(
            designSize: Size(411.4, 866.3),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
            ),
        );
    }
}

class HomeScreen extends StatefulWidget {
    @override
    _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    @override
    Widget build(BuildContext context) {
        return DefaultTabController(
            length: 2,
            child: SafeArea(
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    //resizeToAvoidBottomPadding: false,
                    appBar: AppBar(
                        backgroundColor: Colors.blueAccent,
                        title: Row(
                            children: [
                                Image.asset(
                                    "swananda.jfif",
                                    height: ScreenUtil().setHeight(70),
                                    width: ScreenUtil().setWidth(110),
                                ),

                                SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                ),

                                Text(
                                    "Swananda User Database",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17),
                                        color: Colors.white,
                                    ),
                                ),
                            ],
                        ),
                        bottom: TabBar(
                            tabs: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(0),
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(10),
                                    ),
                                  child: Text("Devotees",
                                      style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20)
                                      ),
                                  ),
                                ),

                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(0),
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(10),
                                    ),
                                  child: Text("Wishes",
                                      style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20)
                                      ),
                                  ),
                                )
                            ],
                        ),
                    ),
                    body: TabBarView(

                        children: [

                            DevoteeScreen(),

                            Wishes(),

                        ],
                    ),
                ),
            ),
        );
    }
}