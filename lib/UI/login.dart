import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:e_calendar/Templates/custom_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_calendar/Templates/form_card.dart';
import 'package:e_calendar/Templates/social_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_calendar/Cores/textfield_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:e_calendar/Cores/constant_vars.dart';
import 'package:device_info/device_info.dart';


double _height;
double _width;

class Login extends StatefulWidget {
  const Login({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login>{

  bool _isLoading = false;
  bool _isSelected = false;

  void initState() {
    super.initState();
    void _radio() {
    setState((){
        _isSelected = !_isSelected;
      });
    }

    Widget radioButton(bool isSelected) => Container(
      width: 16.0,
      height: 16.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Colors.black)
      ),
      child: isSelected ? Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      ) : Container(),
    );

    Widget horizontalLine() {
      var edgeInsets = EdgeInsets.symmetric(horizontal: 16.0);
      return Padding(
        padding: edgeInsets,
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
    );
    }

    void checkLogin() async {
      setState((){
        _isLoading = true;
      });
      Map<String, String> _headers = {
        HttpHeaders.authorizationHeader: api_token
      };

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        var result = await http.post(
          api_url+'auth/authentication/checkDevice_login',
          headers: headers_global,
          body: {
            "name" : nameController.text,
            "device_id" : androidInfo.androidId,
            "organization" : organization.toString()
          }
        );
        if(result.body.length > 0){
          var parsedData = jsonDecode(result.body);
          var stat = parsedData['status'].toString();

          if(stat == '200'){
            var jsonData = parsedData['data'];
            user_id = jsonData['id'];
            user_username = '-';
            user_organization = jsonData['organization'];
            user_nama = jsonData['name'];
            // print(parsedData);
            nameController = new TextEditingController(text: user_nama);
            setState((){
                _isLoading = false;
              });
          }else{
            setState((){
                _isLoading = false;
              });
          }

        }
        

      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        var result = await http.post(
          api_url+'auth/authentication/checkDevice_login',
          headers: headers_global,
          body: {
            "name" : nameController.text,
            "device_id" : iosInfo.identifierForVendor,
            "organization" : organization.toString()
          }
        );
        if(result.body.length > 0){
          var parsedData = jsonDecode(result.body);
          var stat = parsedData['status'].toString();

          if(stat == '200'){
            var jsonData = parsedData['data'];
            user_id = jsonData['id'];
            user_username = '-';
            user_organization = jsonData['organization'];
            user_nama = jsonData['name'];
            nameController = new TextEditingController(text: user_nama);
            setState((){
                _isLoading = false;
              });
          }else{
            setState((){
                _isLoading = false;
              });
          }

        }
      }

      
    }

    checkLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1000, allowFontScaling: true);

    Widget _loginScreen() {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Image.asset("assets/image_01.png"),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/image_02.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0, bottom: 30.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                      "assets/logo_cal.png",
                      width: ScreenUtil.getInstance().setWidth(110),
                      height: ScreenUtil.getInstance().setHeight(110),
                      ),
                      Text
                      ("eCalendar",
                        style: TextStyle(
                          fontFamily: "Poppins-Bold",
                          fontSize: ScreenUtil.getInstance().setSp(46),
                          letterSpacing: .6,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(160),
                  ),
                  FormCard(),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          alignment: Alignment(0.0, 0.0),
                          width: ScreenUtil.getInstance().setWidth(500),
                          height: ScreenUtil.getInstance().setHeight(100),
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

                                if(user_id.toString() == '0'){

                                  if(nameController.text.length == 0){
                                    Fluttertoast.showToast(msg: 'You must provide your name!');
                                  }else{
                                    // Fluttertoast.showToast(msg: 'Terisi!');

                                    setState(() {
                                      _isLoading = true;
                                    });
                                    
                                    // var url = "http://localhost/restCI-absensi/index.php/auth/authentication/auth_login";
                                    void post() async {
                                      
                                      Map<String, String> _headers = {
                                        HttpHeaders.authorizationHeader: api_token
                                      };

                                      // print(api_token+'auth/authentication/auth_login');

                                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                      if (Platform.isAndroid) {
                                        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                        var result = await http.post(
                                          api_url+'auth/authentication/auth_login',
                                          headers: headers_global,
                                          body: {
                                            "name" : nameController.text,
                                            "device_id" : androidInfo.androidId,
                                            "organization" : organization.toString()
                                          }
                                        );
                                        if(result.body.length > 0){
                                          var parsedData = jsonDecode(result.body);
                                          var pesan = parsedData['message'].toString();
                                          var stat = parsedData['status'].toString();

                                          Future.delayed(const Duration(seconds: 1), (){
                                            setState(() {
                                              _isLoading = false;
                                            });

                                            if(stat == '200'){
                                              // Navigator.of(context).pushReplacementNamed('/home');
                                              print(parsedData);
                                              // print(parsedData['data'].toString());
                                              var jsonData = parsedData['data'];
                                              user_id = jsonData['id'];
                                              user_username = '-';
                                              user_organization = jsonData['organization'];
                                              user_nama = jsonData['name'];

                                              Navigator.pushReplacementNamed(context, '/home');

                                            }else{
                                              Fluttertoast.showToast(msg: pesan);
                                            }

                                          });
                                        }else{
                                          Fluttertoast.showToast(msg: "There is an error occured.");
                                        }
                                        

                                      } else if (Platform.isIOS) {
                                        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                                        var result = await http.post(
                                          api_url+'auth/authentication/auth_login',
                                          headers: headers_global,
                                          body: {
                                            "name" : nameController.text,
                                            "device_id" : iosInfo.identifierForVendor,
                                            "organization" : organization.toString()
                                          }
                                        );
                                        if(result.body.length > 0){
                                          var parsedData = jsonDecode(result.body);
                                          var pesan = parsedData['message'].toString();
                                          var stat = parsedData['status'].toString();

                                          Future.delayed(const Duration(seconds: 1), (){
                                            setState(() {
                                              _isLoading = false;
                                            });

                                            if(stat == '200'){
                                              // Navigator.of(context).pushReplacementNamed('/home');
                                              print(parsedData);
                                              // print(parsedData['data'].toString());
                                              var jsonData = parsedData['data'];
                                              user_id = jsonData['id'];
                                              user_username = '-';
                                              user_organization = jsonData['organization'];
                                              user_nama = jsonData['name'];

                                              Navigator.pushReplacementNamed(context, '/home');

                                            }else{
                                              Fluttertoast.showToast(msg: pesan);
                                            }

                                          });
                                        }else{
                                          Fluttertoast.showToast(msg: "There is an error occured.");
                                        }
                                      }

                                      
                                    }

                                    post();

                                    // Future.delayed(const Duration(seconds: 1), (){
                                    //   setState(() {
                                    //     _isLoading = false;
                                    //   });

                                    //     Navigator.of(context).pushReplacementNamed('/home');

                                    // });
                                    

                                  }
                                
                                }else{
                                  Fluttertoast.showToast(msg: "Welcome Back, "+user_nama.toString()+".");
                                  Navigator.pushReplacementNamed(context, '/home');
                                }

                              },
                              child: Center(
                                child: Text("Login",
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
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget _loading(){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: _isLoading ? _loading() : _loginScreen(),
    );

  }

}