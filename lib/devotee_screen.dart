import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DevoteeScreen extends StatefulWidget {
    @override
    _DevoteeScreenState createState() => _DevoteeScreenState();
}

class _DevoteeScreenState extends State<DevoteeScreen> {

    @override
    void initState() {
        getDevotees();
        super.initState();
    }

    late Stream<QuerySnapshot> devotees;
    TextEditingController textCon = TextEditingController();
    String query = "";
    static List<String> fields = [
        "Name",
        "Phone",
        "Email",
        "Address line1",
        "Address line2",
        "Locality",
        "City",
        "Pincode",
        "Birthday",
        "Anniversary date",
        "Comments",
    ];

    Future getDevotees() async {
        devotees = FirebaseFirestore.instance.collection("Devotees").snapshots();
    }

    @override
    Widget build(BuildContext context) {

        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
        ]);

        return Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    showSheet(context, null);
                },
                child: Icon(Icons.add),
            ),
            body: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        Container(
                            height: ScreenUtil().setHeight(80),
                            color: Colors.lightBlue,
                            padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(10),
                                    ScreenUtil().setHeight(10),
                                    ScreenUtil().setWidth(10),
                                    ScreenUtil().setHeight(0)
                            ),
                            child: Row(
                                children: [
                                    Container(
                                        width: ScreenUtil().setWidth(360),
                                        padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(0),
                                                ScreenUtil().setWidth(20),
                                                ScreenUtil().setHeight(0)
                                        ),
                                        child: TextFormField(
                                                controller: textCon,
                                                keyboardType: TextInputType.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil().setSp(17),
                                                ),
                                                cursorColor: Colors.white,
                                                onChanged: (s) {
                                                    setState(() {
                                                        query = textCon.text;
                                                    });
                                                },
                                                decoration: InputDecoration(
                                                    hintText: 'Search',
                                                    hintStyle: TextStyle(
                                                        color: Colors.white38,
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white),
                                                    ),
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white),
                                                    ),
                                                )
                                        ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                            setState(() {
                                                query = "";
                                                textCon.text = "";
                                            });
                                        },
                                        child: Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(645)),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: devotees,
                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                            child: Container(
                                                width: ScreenUtil().setWidth(20),
                                                height: ScreenUtil().setWidth(20),
                                                child: CircularProgressIndicator(),
                                            ),
                                        );
                                    } else {
                                        return ListView.builder(
                                            itemCount: snapshot.data!.docs.length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.all(0),
                                            itemBuilder: (context, pos) {

                                                bool visible = false;
                                                
                                                (snapshot.data!.docs[pos].data() as Map).forEach((key, value) {
                                                    if(key == "Birthday" || key == "Anniversary date") {
                                                        var date;
                                                        if(value != null){
                                                            var d = DateTime.fromMillisecondsSinceEpoch(
                                                                (snapshot.data!.docs[pos].data() as Map)['Birthday'].seconds * 1000,
                                                            );
                                                            // date = DateFormat.yMMMd().format(d);
                                                            date = d.day.toString() + "/" + d.month.toString() + "/" + d.year.toString();
                                                        }
                                                        if(date.toString().toLowerCase().contains(query.toLowerCase()))
                                                            visible = true;
                                                    } else if(value.toString().toLowerCase().contains(query.toLowerCase()))
                                                        visible = true;
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
                                                                "Phone: " + (snapshot.data!.docs[pos].data() as Map)["Phone"].toString(),
                                                            ),
                                                        ),

                                                        ListView.builder(
                                                            itemCount: fields.length,
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemBuilder: (context, index) {
                                                                //print(snapshot.data.docs[pos].data().isEmpty.toString());

                                                                var key = _DevoteeScreenState.fields[index];
                                                                var value = (snapshot.data!.docs[pos].data() as Map)[key];

                                                                var date;
                                                                if(value.runtimeType == Timestamp){
                                                                    var d = DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000);
                                                                    // date = DateFormat.yMMMd().format(d);
                                                                    date = d.day.toString() + "/" + d.month.toString() + "/" + d.year.toString();
                                                                }
                                                                return (key == "Name" || key == "Phone" || value == null)
                                                                        ?Container()
                                                                        :Container(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        ScreenUtil().setWidth(10),
                                                                        ScreenUtil().setHeight(10),
                                                                        ScreenUtil().setWidth(10),
                                                                        ScreenUtil().setHeight(10),
                                                                    ),
                                                                    child: (value.runtimeType != Timestamp)?Text(
                                                                        key.toString() + ": " + value.toString(),
                                                                    ):Text(
                                                                        key.toString() + ": " + date.toString(),
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
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                            ),
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
                                                                                        Container(
                                                                                            width: ScreenUtil().setWidth(300),
                                                                                            child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                    FlatButton(
                                                                                                        child: Text("Cancel"),
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
                                                                                                        child: Text(
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
                                                                            showSheet(context, snapshot.data!.docs[pos]);
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
            ),
        );
    }
}

showSheet(BuildContext context, QueryDocumentSnapshot? snapshot){

    final nameKey = GlobalKey<FormState>();
    final phoneKey = GlobalKey<FormState>();

    Map<String, dynamic> ss;
    ss = (snapshot != null)?(snapshot.data() as Map<String, dynamic>):{};

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
                                                child: Icon(Icons.clear),
                                            ),
                                        ),
                                    ),
                                    ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(475)),
                                        child: SingleChildScrollView(
                                            child: Column(
                                                children: [
                                                    Form(
                                                        key: nameKey,
                                                        child: TextFormField(
                                                            keyboardType: TextInputType.text,
                                                            initialValue: (ss["Name"] != null)?ss["Name"]:"",
                                                            style: TextStyle(
                                                                //color: Colors.white,
                                                                fontSize: ScreenUtil().setSp(17),
                                                            ),
                                                            decoration: InputDecoration(
                                                                labelText: "Name*",
                                                            ),
                                                            onChanged: (s){
                                                                ss["Name"] = s;
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
                                                            initialValue: (ss["Phone"] != null)?ss["Phone"].toString():"",
                                                            style: TextStyle(
                                                                //color: Colors.white,
                                                                fontSize: ScreenUtil().setSp(17),
                                                            ),
                                                            decoration: InputDecoration(
                                                                    labelText: "Phone*"
                                                            ),
                                                            onChanged: (s){
                                                                ss["Phone"] = s;
                                                                phoneKey.currentState?.validate();
                                                            },
                                                            validator: (String? value) => ((value ?? "").trim().isEmpty
                                                                    ? 'Name cannot be empty':null),
                                                        ),
                                                    ),
                                                    ListView.builder(
                                                        itemCount: _DevoteeScreenState.fields.length,
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemBuilder: (context, pos) {

                                                            //var key = ss.keys.toList()[pos];
                                                            //var value = ss[key];
                                                            var date, d;

                                                            if((_DevoteeScreenState.fields[pos] == "Birthday"
                                                                    || _DevoteeScreenState.fields[pos] == "Anniversary date")){

                                                                if(ss[_DevoteeScreenState.fields[pos]] != null){
                                                                    d = DateTime.fromMillisecondsSinceEpoch(
                                                                        ss[_DevoteeScreenState.fields[pos]].seconds * 1000,
                                                                    );
                                                                    // date = DateFormat.yMMMd().format(d);
                                                                    date = d.day.toString() + "/" + d.month.toString() + "/" + d.year.toString();
                                                                }

                                                                return Container(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        ScreenUtil().setWidth(0),
                                                                        ScreenUtil().setHeight(15),
                                                                        ScreenUtil().setWidth(7.5),
                                                                        ScreenUtil().setHeight(15),
                                                                    ),
                                                                    child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Row(
                                                                                children: [
                                                                                    (date!=null)?Text(
                                                                                        _DevoteeScreenState.fields[pos]
                                                                                                .toString() + ": " + date.toString(),
                                                                                        style: TextStyle(
                                                                                            fontSize: ScreenUtil().setSp(16),
                                                                                        ),
                                                                                    ):Text(
                                                                                        _DevoteeScreenState.fields[pos]
                                                                                                .toString() + ": ",
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
                                                                                                if(f.difference(d).isNegative)
                                                                                                    f = DateTime(d.year + 1);
                                                                                                if(d.difference(l).isNegative)
                                                                                                    l = DateTime(d.year - 1);
                                                                                            }

                                                                                            final DateTime? picked = await showDatePicker(
                                                                                                context: context,
                                                                                                initialDate: (d != null)?d:DateTime.now(),
                                                                                                firstDate: l,
                                                                                                lastDate: f,
                                                                                            );
                                                                                            if(picked != null)
                                                                                                setState((){
                                                                                                    ss[_DevoteeScreenState.fields[pos]] = Timestamp
                                                                                                            .fromDate(picked);
                                                                                                });
                                                                                        },
                                                                                        child: Container(
                                                                                            padding: EdgeInsets.fromLTRB(
                                                                                                ScreenUtil().setWidth(10),
                                                                                                ScreenUtil().setHeight(10),
                                                                                                ScreenUtil().setWidth(0),
                                                                                                ScreenUtil().setHeight(10),
                                                                                            ),
                                                                                            child: Icon(Icons.calendar_today),
                                                                                        ),
                                                                                    ),
                                                                                ],
                                                                            ),

                                                                        ],
                                                                    ),
                                                                );
                                                            }
                                                            else {
                                                                return (_DevoteeScreenState.fields[pos] == "Name"
                                                                        || _DevoteeScreenState.fields[pos] == "Phone")?Container():TextFormField(
                                                                    keyboardType: (_DevoteeScreenState.fields[pos] == "Address Line1"
                                                                            || _DevoteeScreenState.fields[pos] == "Address Line1"
                                                                            || _DevoteeScreenState.fields[pos] == "Comments"
                                                                    ) ?TextInputType.multiline
                                                                            :TextInputType.text,
                                                                    minLines: (_DevoteeScreenState.fields[pos] == "Address Line1"
                                                                            || _DevoteeScreenState.fields[pos] == "Address Line1"
                                                                            || _DevoteeScreenState.fields[pos] == "Comments"
                                                                    ) ?2 :1,
                                                                    maxLines: (_DevoteeScreenState.fields[pos] == "Address Line1"
                                                                            || _DevoteeScreenState.fields[pos] == "Address Line1"
                                                                            || _DevoteeScreenState.fields[pos] == "Comments"
                                                                    ) ?null:1,
                                                                    style: TextStyle(
                                                                        //color: Colors.white,
                                                                        fontSize: ScreenUtil().setSp(16),
                                                                    ),
                                                                    initialValue: (ss[_DevoteeScreenState.fields[pos]] != null)
                                                                            ?ss[_DevoteeScreenState.fields[pos]]:"",
                                                                    decoration: InputDecoration(
                                                                        labelText: _DevoteeScreenState.fields[pos].toString(),
                                                                    ),
                                                                    onChanged: (s){
                                                                        ss[_DevoteeScreenState.fields[pos]] = s;
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
                                                    if(snapshot == null){
                                                        FirebaseFirestore.instance
                                                                .collection("Devotees").add(ss).then((value) {
                                                            Navigator.pop(context);
                                                        });
                                                    } else {
                                                        snapshot.reference.set(ss).then((
                                                                value) {
                                                            Navigator.pop(context);
                                                        });
                                                    }
                                                }
                                            },
                                            child: (snapshot != null)?Text(
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