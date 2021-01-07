import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async' show Future;
import 'dart:convert';

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

class Nakama extends StatefulWidget {
  const Nakama({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NakamaState();
}

class _NakamaState extends State<Nakama>{
  bool _isLoading = false;
  double _height;
  double _width;
  final _biggerFont = const TextStyle(fontSize: 15.0);
  var numItemsCount = nakamaList.length;

  Widget _buildRow(int idx){
      int index = idx;
      final item = nakamaList[index];

      DateTime tgl = DateTime.parse(item.lastLogin.toString());
      String formattedDate = DateFormat('dd/MMMM/yyyy - hh:mm a').format(tgl);

      return Card(
        child: ListTile(
          leading:  ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Icon(Icons.person),
          ), 
          title: Container(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  item.name,
                  style: _biggerFont,
                ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Text('Last Login : ',style: TextStyle(color: Colors.orange,fontSize: 14)),
                        Text(formattedDate.toString(),style: TextStyle(color: Colors.orange,fontSize: 14,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        ),
      );
    }

  @override
  void initState() {
    super.initState();

    nakamaList.clear();

    Future loadNakama() async {
        setState(() {
          _isLoading = true;
        });

        var result = await http.get(api_url+'ecalendar/getNakama/'+user_organization.toString()+'?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
        headers: { 'accept':'application/json' }
        );
          if(result.body.length > 0){
            var parsedData = jsonDecode(result.body);
            var pesan = parsedData['message'].toString();
            var stat = parsedData['status'].toString();
            var data = parsedData['data'];
            if(stat == '200'){
              // final encodeJson = json.encode(data)
              final jsonResponse = json.decode(data);
              List respID;
              // print(jsonResponse['inner']);
              respID = json.decode(jsonResponse['inner']);
              final countJsonResponse = respID.length;
              numItemsCount = countJsonResponse;

              for(var item in respID){
                
                nakamaList.add(
                  new NakamaClass(
                    int.parse(item['id']),
                    item['name'],
                    item['device_id'],
                    DateTime.parse(item['registered_at']),
                    DateTime.parse(item['last_login']),
                    item['organization']
                  )
                );


              }
              
              print(nakamaList.length);
              
              setState(() {
                _isLoading = false;
              });

            }else{
              setState(() {
                _isLoading = false;
              });
              // Fluttertoast.showToast(msg: pesan);
            }
          }else{
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(msg: "There is an error occured.");
          }
      
    }

    loadNakama();
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
        title: Text("List of Nakama"),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: <Widget>[
              
              Card(
                child: ListTile(
                  title: Container(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'You can find people from the same community as you are, in here. And their last login of course.',
                            style: TextStyle(fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),

              _isLoading ? Center(
                child: LinearProgressIndicator(),
              ) : Card(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: ListView.builder(
                        itemCount: numItemsCount * 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        itemBuilder: (BuildContext context, int i){
                          if(i.isOdd) return const SizedBox(height: 2.0,);
                          final index = i ~/ 2 + 1 - 1;
                          return _buildRow(index);
                        },
                      ),
                    ),
                  ),
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