import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DevoteeScreen extends StatefulWidget {
  @override
  _DevoteeScreenState createState() => _DevoteeScreenState();
}

List<String> fields = [
	"Name",
	"Phone",
	"Email",
	"Gothra",
	"Nakshatra",
	"Rashi",
	"Category",
	"Referred by",
	"Address line1",
	"Address line2",
	"Locality",
	"City",
	"Pincode",
	"Birthday",
	"Anniversary date",
	"Comments",
];

List<String> rashi = [
	"",
	"Mesha",
	"Vrishabha",
	"Mithuna",
	"Karkataka",
	"Simha",
	"Kanya",
	"Tula",
	"Vrishchika",
	"Dhanu",
	"Makara",
	"Kumbha",
	"Meena",
];

List<String> nakshatra = [
	"",
	"Ashwini",
	"Bharani",
	"Krittika",
	"Rohini",
	"Mrigashira",
	"Ardra",
	"Punarvasu",
	"Pushya",
	"Ashlesha",
	"Magha",
	"Poorva Phalguni",
	"Uttara Phalguni",
	"Hasta",
	"Chitra",
	"Swati",
	"Vishakha",
	"Anuradha",
	"Jyeshtha",
	"Mula",
	"Poorva Ashadha",
	"Uttara Ashadha",
	"Shravana",
	"Dhanishta",
	"Shatabhisha",
	"Poorva Bhadrapada",
	"Uttara Bhadrapada",
	"Revati",
];

List<String> categories = [
	"",
	"Donor",
	"Family member",
	"General devotee"
];

class _DevoteeScreenState extends State<DevoteeScreen> {

  @override
  void initState() {
    getDevotees();
    super.initState();
  }

  late Stream<QuerySnapshot> devotees;
  TextEditingController textCon = TextEditingController();
  String query = "";

  Future getDevotees() async {
    devotees = FirebaseFirestore.instance.collection("Devotees").snapshots();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StreamBuilder<QuerySnapshot>(
      stream: devotees,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<String> numbers = [];
        if(snapshot.hasData) {
          numbers = snapshot.data!.docs.map((e) => e["Phone"].toString()).toList();
        }
        
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showSheet(context, null, numbers);
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setHeight(10),
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setHeight(10)
                ),
                child: TextFormField(
                    controller: textCon,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(17),
                    ),
                    onChanged: (s) {
                      setState(() {
                        query = textCon.text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: EdgeInsets.fromLTRB(
                       ScreenUtil().setWidth(10),
                       ScreenUtil().setHeight(0),
                       ScreenUtil().setWidth(10),
                       ScreenUtil().setHeight(0)
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            query = "";
                            textCon.text = "";
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    )
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (!snapshot.hasData || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(20),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, pos) {
    
                          bool visible = false;
                          
                          (snapshot.data!.docs[pos].data() as Map).forEach((key, value) {
                            if(key == "Birthday" || key == "Anniversary date") {
                              String date = "";
                              if(value != null){
                                var d = DateTime.fromMillisecondsSinceEpoch(
                                  (snapshot.data!.docs[pos].data() as Map)['Birthday'].seconds * 1000,
                                );
                                // date = DateFormat.yMMMd().format(d);
                                date = "${d.day}/${d.month}/${d.year}";
                              }
                              if(date.toString().toLowerCase().contains(query.toLowerCase())) {
                               visible = true;
                              }
                            } else if(value.toString().toLowerCase().contains(query.toLowerCase())) {
                             visible = true;
                            }
                          });
    
                          return (!visible)?Container():ExpansionTile(
                            title: Text(
                              snapshot.data!.docs[pos]["Name"].toString(),
                            ),
                            children: [
    
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(10),
                                    ScreenUtil().setHeight(10),
                                    ScreenUtil().setWidth(10),
                                    ScreenUtil().setHeight(10)
                                ),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Phone: ${(snapshot.data!.docs[pos].data() as Map)["Phone"]}",
                                ),
                              ),
    
                              ListView.builder(
                                itemCount: fields.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  //print(snapshot.data.docs[pos].data().isEmpty.toString());
    
                                  var key = fields[index];
                                  var value = (snapshot.data!.docs[pos].data() as Map)[key];
    
                                  String date = "";
                                  if(value.runtimeType == Timestamp){
                                    var d = DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000);
                                    // date = DateFormat.yMMMd().format(d);
                                    date = "${d.day}/${d.month}/${d.year}";
                                  }
                                  return (key == "Name" || key == "Phone" || value == null || value == "")
                                      ?Container()
                                      :Container(
                                    padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(10),
                                      ScreenUtil().setHeight(10),
                                      ScreenUtil().setWidth(10),
                                      ScreenUtil().setHeight(10),
                                    ),
                                    child: (value.runtimeType != Timestamp)?Text(
                                      "$key: $value",
                                    ):Text(
                                      "$key: $date",
                                    ),
                                  );
                                },
                              ),
    
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
    
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(10),
                                        ScreenUtil().setHeight(10),
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setHeight(10)
                                    ),
                                    width: ScreenUtil().setWidth(150),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      onPressed: (){
                                        FocusScope.of(context).unfocus();
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              "Are you sure you want to remove this devotee?",
                                              style: TextStyle(
                                                  fontSize:ScreenUtil().setSp(17)
                                              ),
                                            ),
                                            actions: [
                                              SizedBox(
                                                width: ScreenUtil().setWidth(300),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    FlatButton(
                                                      child: const Text("Cancel"),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "Confirm",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: (){
                                                        snapshot.data!.docs[pos].reference.delete();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(13),
                                        ),
                                      ),
                                    ),
                                  ),
    
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(10),
                                        ScreenUtil().setHeight(10),
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setHeight(10)
                                    ),
                                    width: ScreenUtil().setWidth(150),
                                    child: ElevatedButton(
                                      onPressed: (){
                                        FocusScope.of(context).unfocus();
                                        showSheet(context, snapshot.data!.docs[pos], numbers);
                                      },
                                      child: Text(
                                        "Update",
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(13),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
    
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

showSheet(
  BuildContext context, 
  QueryDocumentSnapshot? queryDocumentSnapshot,
  List<String> numbers
  ){

  final nameKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormState>();

  Map<String, dynamic> snapshot;
  snapshot = (queryDocumentSnapshot != null)?(queryDocumentSnapshot.data() as Map<String, dynamic>):{};
	snapshot["Rashi"] = snapshot["Rashi"] ?? "";
	snapshot["Nakshatra"] = snapshot["Nakshatra"] ?? "";
	snapshot["Category"] = snapshot["Category"] ?? "";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    builder: (context) {

      return StatefulBuilder(
          builder: (context, setState) {

            var bottom = MediaQuery.of(context).viewInsets.bottom;

            return Container(
              height: ScreenUtil().setHeight(600),
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(10),
                  ScreenUtil().setHeight(10),
                  ScreenUtil().setWidth(10),
                  ScreenUtil().setHeight(10)
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(10),
                          ScreenUtil().setHeight(10),
                          ScreenUtil().setWidth(10),
                          ScreenUtil().setHeight(10),
                        ),
                        child: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Form(
                          key: nameKey,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            initialValue: (snapshot["Name"] != null)?snapshot["Name"]:"",
                            style: TextStyle(
                              //color: Colors.white,
                              fontSize: ScreenUtil().setSp(17),
                            ),
                            decoration: const InputDecoration(
                              labelText: "Name*",
                            ),
                            onChanged: (s){
                              snapshot["Name"] = s;
                              nameKey.currentState?.validate();
                            },
                            validator: (String? value) => ((value ?? "").trim().isEmpty
                                ? 'Name cannot be empty':null),
                          ),
                        ),
                        Form(
                          key: phoneKey,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            initialValue: (snapshot["Phone"] != null)?snapshot["Phone"].toString():"",
                            style: TextStyle(
                              //color: Colors.white,
                              fontSize: ScreenUtil().setSp(17),
                            ),
                            decoration: const InputDecoration(
                                labelText: "Phone*"
                            ),
                            onChanged: (s){
                              snapshot["Phone"] = s;
                              phoneKey.currentState?.validate();
                            },
                            validator: (String? value) {
                              if((value ?? "").trim().isEmpty){
                                return 'Phone cannot be empty';
                              }
                              else if(numbers.contains(value)){
                                return 'Phone number already exists';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        ListView.builder(
                          itemCount: fields.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, pos) {

                            //var key = ss.keys.toList()[pos];
                            //var value = ss[key];
                            var date, d;
															developer.log(fields[pos].toString());
															// developer.log((snapshot[fields[pos]] == "Rashi").toString());
															if(fields[pos] == "Rashi"
																	|| fields[pos] == "Nakshatra"
																	|| fields[pos] == "Category"){
																		
																		return DropdownButtonFormField(
																			decoration: InputDecoration(
																				labelText: fields[pos],
																			),
																			value: snapshot[fields[pos]],
																			items: (fields[pos] == "Rashi"
																			? rashi
																			: (fields[pos] == "Nakshatra")
																				? nakshatra
																				: categories
																			).map((e) => DropdownMenuItem<String>(
																				value: e,
																				child: Text((e != "")
																				? e
																				: "Select ${fields[pos]}",
																			),
																			)).toList(),
																			onChanged: (s){
																				snapshot[fields[pos]] = s;
																				setState(() {});
																			},
																		);
																		
																	} else if((fields[pos] == "Birthday"
                                || fields[pos] == "Anniversary date")){

                              if(snapshot[fields[pos]] != null){
                                d = DateTime.fromMillisecondsSinceEpoch(
                                  snapshot[fields[pos]].seconds * 1000,
                                );
                                // date = DateFormat.yMMMd().format(d);
                                date = "${d.day}/${d.month}/${d.year}";
                              }

                              return Container(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  ScreenUtil().setHeight(5),
                                  0,
                                  0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        (date!=null)?Text(
                                          "${fields[pos]}: $date",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16),
                                          ),
                                        ):Text(
                                          "${fields[pos]}: ",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(40),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();

                                            DateTime f = DateTime(DateTime.now().year + 1);
                                            DateTime l = DateTime(DateTime.now().year - 100);
                                            if(d != null) {
                                              if(f.difference(d).isNegative) {
                                               f = DateTime(d.year + 1);
                                              }
                                              if(d.difference(l).isNegative) {
                                               l = DateTime(d.year - 1);
                                              }
                                            }

                                            final DateTime? picked = await showDatePicker(
                                              context: context,
                                              initialDate: (d != null)?d:DateTime.now(),
                                              firstDate: l,
                                              lastDate: f,
                                            );
                                            if(picked != null) {
                                             setState((){
                                                snapshot[fields[pos]] = Timestamp
                                                    .fromDate(picked);
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                              ScreenUtil().setWidth(10),
                                              ScreenUtil().setHeight(10),
                                              ScreenUtil().setWidth(0),
                                              ScreenUtil().setHeight(10),
                                            ),
                                            child: const Icon(Icons.calendar_today),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              );
                            }
                            else {
                              return (fields[pos] == "Name"
                                  || fields[pos] == "Phone")?Container():TextFormField(
                                keyboardType: (fields[pos] == "Address Line1"
                                    || fields[pos] == "Address Line1"
                                    || fields[pos] == "Comments"
                                ) ?TextInputType.multiline
                                    :TextInputType.text,
                                minLines: (fields[pos] == "Address Line1"
                                    || fields[pos] == "Address Line1"
                                    || fields[pos] == "Comments"
                                ) ?2 :1,
                                maxLines: (fields[pos] == "Address Line1"
                                    || fields[pos] == "Address Line1"
                                    || fields[pos] == "Comments"
                                ) ?null:1,
                                style: TextStyle(
                                  //color: Colors.white,
                                  fontSize: ScreenUtil().setSp(16),
                                ),
                                initialValue: (snapshot[fields[pos]] != null)
                                    ?snapshot[fields[pos]]:"",
                                decoration: InputDecoration(
                                  labelText: fields[pos].toString(),
                                ),
                                onChanged: (s){
                                  snapshot[fields[pos]] = s;
                                },
                              );
                            }
                          },
                        ),

                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),

                        SizedBox(
                          height: ScreenUtil().setHeight(bottom),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setHeight(0),
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        if((nameKey.currentState?.validate() ?? false) && (phoneKey.currentState?.validate() ?? false)) {
                          if(queryDocumentSnapshot == null){
                            FirebaseFirestore.instance
                                .collection("Devotees").add(snapshot).then((value) {
                              Navigator.pop(context);
                            });
                          } else {
                            queryDocumentSnapshot.reference.set(snapshot).then((
                                value) {
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                      child: (queryDocumentSnapshot != null)?Text(
                        "Update & Exit",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13)
                        ),
                      ):Text(
                        "Add",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13)
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            );
          }
      );
    },
  );
}