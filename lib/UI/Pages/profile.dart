import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';

import 'package:e_calendar/Cores/textfield_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_format/date_format.dart';
import 'package:e_calendar/Cores/constant_vars.dart';
import 'package:e_calendar/Cores/helpers.dart';
import 'package:e_calendar/Cores/objects.dart';
import 'package:intl/intl.dart';

TextEditingController controllerName;

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  bool _isLoading = false;
  double _height;
  double _width;
  @override
  void initState() {
    super.initState();
    controllerName = new TextEditingController(text: '');
    controllerName = new TextEditingController(text: user_nama);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: ScreenUtil.getInstance().setHeight(220),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 15.0),
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, -10.0),
                          blurRadius: 10.0),
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Change your name",
                          style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(30),
                              fontFamily: "Poppins-Bold",
                              letterSpacing: .6)),
                      Card(
                        child: ListTile(
                          leading:  ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Icon(Icons.person),
                          ), 
                          title: Container(
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  controller: controllerName,
                                  decoration: InputDecoration(
                                      hintText: "Your Name",
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text('Organization : ',style: TextStyle(color: Colors.orange,fontSize: 14)),
                                        Text(user_organization.toString(),style: TextStyle(color: Colors.orange,fontSize: 14,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0,),
                              ],
                            ),
                          ),
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),

              _isLoading ? Center(
                child: LinearProgressIndicator(),
              ) : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          alignment: Alignment(0.0, 0.0),
                          width: ScreenUtil.getInstance().setWidth(350),
                          height: ScreenUtil.getInstance().setHeight(70),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFF17ead9),
                              Color(0xFF6078ea)
                            ]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF6078ea).withOpacity(.3),
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0
                              )
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {

                                if(controllerName.text.length == 0){
                                    Fluttertoast.showToast(msg: 'You must provide your name!');
                                }else{

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  void post() async {
                                      
                                    Map<String, String> _headers = {
                                      HttpHeaders.authorizationHeader: api_token
                                    };

                                    // print(api_token+'auth/authentication/auth_login');

                                    
                                    var result = await http.post(
                                      api_url+'auth/authentication/save_profile',
                                      headers: headers_global,
                                      body: {
                                        "id" : user_id.toString(),
                                        "name" : controllerName.text,
                                      }
                                    );
                                    if(result.body.length > 0){
                                      var parsedData = jsonDecode(result.body);
                                      var pesan = parsedData['message'].toString();
                                      var stat = parsedData['status'].toString();

                                      // print(parsedData);

                                      Future.delayed(const Duration(seconds: 1), (){
                                        setState(() {
                                          _isLoading = false;
                                        });

                                        if(stat == '200'){
                                          var jsonData = parsedData['data'];
                                          user_nama = jsonData['name'];

                                          Fluttertoast.showToast(msg: pesan+' You must re-login to update your session.');
                                          Navigator.pushReplacementNamed(context, '/login');

                                        }else{
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          Fluttertoast.showToast(msg: pesan);
                                        }

                                      });
                                    }else{
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Fluttertoast.showToast(msg: "There is an error occured.");
                                    }
                                    
                                  }

                                  post();

                                }

                              },
                              child: Center(
                                child: Text("Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins-Bold",
                                    fontSize: 18,
                                    letterSpacing: 1.0
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

              // Card(
              //   child: ListView.builder(
              //     itemCount: numItemsCount,
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }

}