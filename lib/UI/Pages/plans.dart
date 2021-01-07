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
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

TextEditingController eventNameController;
TextEditingController eventDateController;
TextEditingController eventTimeController;

class CreatePlan extends StatefulWidget {
  const CreatePlan({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan>{
  bool _isLoading = false;
  double _height;
  double _width;
  @override
  void initState() {
    super.initState();
    eventNameController = new TextEditingController();
    eventDateController = new TextEditingController();
    eventTimeController = new TextEditingController();
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
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("Create a plan"),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(750),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.0),
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
                        Text("Fill the fields below",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(24),
                                letterSpacing: .6)),
                        Divider(),
                        Text("Event Name",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(20))),
                        TextField(
                          controller: eventNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              hintText: "Event name",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                        ),
                        const SizedBox(height: 8.0,),
                        Text("Event Date",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(20))),
                        DateTimeField(
                          controller: eventDateController,
                          format: DateFormat("dd-MM-yyyy"),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              hintText: "Event date",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          onShowPicker: (context, currentVal) {
                            return showDatePicker(
                              context: context,
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2100),
                              initialDate: currentVal ?? DateTime.now(),
                            );
                          },
                        ),
                        const SizedBox(height: 8.0,),
                        Text("Event Time",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(20))),
                        DateTimeField(
                          controller: eventTimeController,
                          format: DateFormat("hh:mm a"),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              hintText: "Event time",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          onShowPicker: (context, currentVal) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(currentVal ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                        ),
                        const SizedBox(height: 8.0,),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("After you create a plan, let all members vote your plans. And you can decide whether you want to publish it or not.",
                                    style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().setSp(24),
                                        letterSpacing: .6)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40.0,),

                        _isLoading ? Center(
                          child: CircularProgressIndicator(),
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

                                          if(eventNameController.text.length == 0 || eventDateController.text.length == 0 || eventTimeController.text.length == 0){
                                            Fluttertoast.showToast(msg: 'Please fill out the fields.');
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
                                                api_url+'ecalendar/save_event',
                                                headers: headers_global,
                                                body: {
                                                  "event_name" : eventNameController.text,
                                                  "event_date" : eventDateController.text,
                                                  "event_time" : eventTimeController.text,
                                                  "user_id" : user_id
                                                }
                                              );
                                              if(result.body.length > 0){
                                                var parsedData = jsonDecode(result.body);
                                                var pesan = parsedData['message'].toString();
                                                var stat = parsedData['status'].toString();

                                                print(parsedData);

                                                Future.delayed(const Duration(seconds: 1), (){
                                                  setState(() {
                                                    _isLoading = false;
                                                  });

                                                  if(stat == '200'){
                                                    var jsonData = parsedData['data'];
                                                    
                                                    setState(() {
                                                      _isLoading = false;
                                                      eventNameController = new TextEditingController(text: '');
                                                      eventDateController = new TextEditingController(text: '');
                                                      eventTimeController = new TextEditingController(text: '');
                                                    });
                                                    Fluttertoast.showToast(msg: pesan);
                                                    Navigator.pushReplacementNamed(context, '/home');

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
                                          child: Text("Create",
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

                // Card(
                //   child: ListView.builder(
                //     itemCount: numItemsCount,
                //   ),
                // ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}

class VotePlan extends StatefulWidget {
  const VotePlan({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VotePlanState();
}

class _VotePlanState extends State<VotePlan> {

  bool _isLoading = false;
  double _height;
  double _width;
  final _biggerFont = const TextStyle(fontSize: 15.0);
  var numItemsCount = 0;
  

  Widget _buildRow(int idx){
      int index = idx;
      final item = eventsList[index];

      DateTime tgl = DateTime.parse(item.eventDate.toString());
      String formattedDate = DateFormat('dd/MMMM/yyyy').format(tgl);

      return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.7),
              borderRadius: BorderRadius.circular(12.0)
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: Icon(Icons.arrow_forward_ios,color: Colors.green,),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(item.eventName.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  const SizedBox(height: 4.0,),
                  Text('Event Date : '+formattedDate.toString(),
                  style: TextStyle(color: Colors.black,fontSize: 13),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  Text(item.eventTime.toString(),
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  Text(item.eventByNama.toString(),
                  style: TextStyle(fontSize: 12,color: Colors.blue),
                  ),
                ],
              ),
              onTap: () {
                // print(item);
                planEvent.clear();
                planEvent.add(
                  new DetailPlan(
                    int.parse(item.id.toString()),
                    item.eventName.toString(),
                    DateTime.parse(item.eventDate.toString()),
                    item.eventTime,
                    int.parse(item.stat.toString()),
                    int.parse(item.eventBy.toString()),
                    item.eventByNama.toString()
                  ),
                );
                Navigator.of(context).pushNamed('/detail-vote-plan');
              },
            ),
        );
    }

  @override
  void initState() {
    super.initState();
    eventsList.clear();

      Future loadEvents() async {
        setState(() {
          _isLoading = true;
        });

        var result = await http.get(api_url+'ecalendar/getEventsList/'+user_organization.toString()+'?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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
                
                eventsList.add(
                  new EventsClass(
                    int.parse(item['id']),
                    item['event_name'],
                    DateTime.parse(item['event_date']),
                    item['time_conv'],
                    int.parse(item['stat']),
                    int.parse(item['event_by']),
                    item['event_by_name']
                  )
                );


              }
              
              print(eventsList.length);
              
              setState(() {
                _isLoading = false;
              });

              numItemsCount = eventsList.length;

            }else{
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(msg: pesan);
            }
          }else{
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(msg: "There is an error occured.");
          }
      
    }

    loadEvents();
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
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("Vote plans"),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(150),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 3.0),
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, -0.0),
                            blurRadius: 3.0),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("You can vote every planned events here. And see who has been voted to every planned events. Remember, you cannot vote your own planned events. And thus accepted or declined events will never be showed here.",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(24),
                                letterSpacing: .6)),
                        const SizedBox(height: 8.0,),

                        _isLoading ? Center(
                          child: LinearProgressIndicator(),
                        ) : const SizedBox(height: 0.0,)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(750),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.0),
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
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListView.builder(
                              itemCount: numItemsCount * 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              itemBuilder: (BuildContext context, int i){
                                if(i.isOdd) return const SizedBox(height: 5.0,);
                                final index = i ~/ 2 + 1 - 1;
                                return _buildRow(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                // Card(
                //   child: ListView.builder(
                //     itemCount: numItemsCount,
                //   ),
                // ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}


class DetailVotePlan extends StatefulWidget{
  const DetailVotePlan({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailVotePlanState();
}

class _DetailVotePlanState extends State<DetailVotePlan>{

  bool _isLoading = false;
  double _height;
  double _width;
  final _biggerFont = const TextStyle(fontSize: 15.0);
  var numItemsCount = 0;

  int _votedNo = 0,_votedYes = 0;

  Widget _buildRow(int idx){
    int index = idx;
    final item = votedUser[index];

    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.7),
          borderRadius: BorderRadius.circular(12.0)
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          leading: 
          planEvent[0].eventBy == item.userId ? Icon(Icons.person_pin,color: Colors.yellow) : Icon(Icons.person_pin,color: Colors.blue),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(item.userName.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Voted',
              style: TextStyle(color: Colors.black,fontSize: 15),
              ),

              item.voteStat == 1 ? Text('YES',
              style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
              ) : Text('NO',
              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
              ),
            ],
          ),
          onTap: () {
            
          },
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    votedUser.clear();

      Future loadVotedUsers() async {
        setState(() {
          _isLoading = true;
        });

        var result = await http.get(api_url+'ecalendar/getVotedUsersByEventID/'+planEvent[0].id.toString()+'?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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

              final outerResp = json.decode(jsonResponse['outer']);

              _votedNo = outerResp['no'];
              _votedYes = outerResp['yes'];

              for(var item in respID){
                
                votedUser.add(
                  new VotedUsers(
                    int.parse(item['id']),
                    int.parse(item['event_id']),
                    int.parse(item['user_id']),
                    item['name'],
                    DateTime.parse(item['vote_date']),
                    int.parse(item['vote_stat'])
                  ),
                );

              }
              
              print(votedUser.length);
              
              setState(() {
                _isLoading = false;
              });

              numItemsCount = votedUser.length;

            }else{
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(msg: pesan);
            }
          }else{
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(msg: "There is an error occured.");
          }
      
    }

    loadVotedUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    DateTime tgl = DateTime.parse(planEvent[0].eventDate.toString());
    String formattedDate = DateFormat('dd MMMM yyyy').format(tgl);
    GlobalKey _scaffold = GlobalKey();

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/vote-plans');
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(planEvent[0].eventName),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(385),
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
                        Text("Event plan detail",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(28),
                                fontFamily: "Poppins-Bold",
                                letterSpacing: .6)),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(13),
                        ),
                        Card(
                          child: ListTile(
                            leading:  ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Icon(Icons.calendar_today),
                            ), 
                            title: Container(
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      formattedDate.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading:  ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Icon(Icons.access_time),
                            ), 
                            title: Container(
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      planEvent[0].eventTime.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
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
                                      planEvent[0].eventByNama.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(175),
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
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Voted Yes',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    _votedYes.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Voted No',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    _votedNo.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(400),
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
                        Text("Users who have already voted",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(28),
                                fontFamily: "Poppins-Bold",
                                letterSpacing: .6)),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(13),
                        ),
                        SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListView.builder(
                                    itemCount: numItemsCount * 2,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    itemBuilder: (BuildContext context, int i){
                                      if(i.isOdd) return const SizedBox(height: 5.0,);
                                      final index = i ~/ 2 + 1 - 1;
                                      return _buildRow(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                _isLoading ? Center(
                    child: CircularProgressIndicator(),
                  ) :
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(120),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 3.0),
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, -0.0),
                            blurRadius: 3.0),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        
                        Align(
                          alignment: Alignment.topCenter,
                          child: InkWell(
                          child: Container(
                              alignment: Alignment(0.0, 0.0),
                              width: ScreenUtil.getInstance().setWidth(300),
                              height: ScreenUtil.getInstance().setHeight(70),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF6078ea),
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

                                    showDialog(
                                      context: _scaffold.currentContext,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: new Text("Confirmation"),
                                          content: new Text("Are you sure ?"),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text('Close'),
                                              onPressed: () {
                                                Navigator.of(dialogContext).pop();
                                              },
                                            ),
                                            new FlatButton(
                                              color: Colors.blue,
                                              child: new Text('Vote Yes'),
                                              onPressed: () {

                                                Navigator.of(dialogContext).pop();
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                void post() async {
                                      
                                                  Map<String, String> _headers = {
                                                    HttpHeaders.authorizationHeader: api_token
                                                  };

                                                  var result = await http.post(
                                                    api_url+'ecalendar/doVote',
                                                    headers: headers_global,
                                                    body: {
                                                      "event_id" : planEvent[0].id.toString(),
                                                      "user_id" : user_id,
                                                      "vote_stat" : "1"
                                                    }
                                                  );

                                                  print(result);

                                                  if(result.body.length > 0){
                                                    var parsedData = jsonDecode(result.body);
                                                    var pesan = parsedData['message'].toString();
                                                    var stat = parsedData['status'].toString();

                                                    Future.delayed(const Duration(seconds: 1), (){
                                                        
                                                      setState(() {
                                                        _isLoading = false;
                                                      });

                                                      if(stat == '200'){
                                                        Fluttertoast.showToast(msg: pesan);
                                                        Navigator.pushReplacementNamed(context, '/vote-plans');
                                                      }else{
                                                        Fluttertoast.showToast(msg: pesan);
                                                      }

                                                    });
                                                  }else{
                                                    Fluttertoast.showToast(msg: "There is an error occured.");
                                                  }
                                                    
                                                }

                                                post();

                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    );

                                  },
                                  child: Center(
                                    child: Text("Vote Yes",
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
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InkWell(
                            child: Container(
                                alignment: Alignment(0.0, 0.0),
                                width: ScreenUtil.getInstance().setWidth(300),
                                height: ScreenUtil.getInstance().setHeight(70),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF6078ea),
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

                                      showDialog(
                                        context: _scaffold.currentContext,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: new Text("Confirmation"),
                                            content: new Text("Are you sure ?"),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text('Close'),
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                color: Colors.red,
                                                child: new Text('Vote No'),
                                                onPressed: () {

                                                  Navigator.of(dialogContext).pop();
                                                  setState(() {
                                                    _isLoading = true;
                                                  });

                                                  void post() async {
                                        
                                                    Map<String, String> _headers = {
                                                      HttpHeaders.authorizationHeader: api_token
                                                    };

                                                    var result = await http.post(
                                                      api_url+'ecalendar/doVote',
                                                      headers: headers_global,
                                                      body: {
                                                        "event_id" : planEvent[0].id.toString(),
                                                        "user_id" : user_id,
                                                        "vote_stat" : "0"
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
                                                          Fluttertoast.showToast(msg: pesan);
                                                          Navigator.pushReplacementNamed(context, '/vote-plans');
                                                        }else{
                                                          Fluttertoast.showToast(msg: pesan);
                                                        }

                                                      });

                                                    }else{
                                                      Fluttertoast.showToast(msg: "There is an error occured.");
                                                    }
                                                      
                                                  }

                                                  post();

                                                },
                                              ),
                                            ],
                                          );
                                        }
                                      );

                                    },
                                    child: Center(
                                      child: Text("Vote No",
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
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}


class HistoryPlan extends StatefulWidget {
  const HistoryPlan({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryPlanState();
}

class _HistoryPlanState extends State<HistoryPlan>{

  
  bool _isLoading = false;
  double _height;
  double _width;
  final _biggerFont = const TextStyle(fontSize: 15.0);
  var numItemsCount = 0;
  int _plansPublished = 0;
  int _plansCanceled = 0;

  Widget _buildRow(int idx){
      int index = idx;
      final item = eventsListHistory[index];

      DateTime tgl = DateTime.parse(item.eventDate.toString());
      String formattedDate = DateFormat('dd/MMMM/yyyy').format(tgl);

      Widget statusPlans(){

        if(item.stat == 1){
          return Text("Published",
                  style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                  );
        }else if(item.stat == 2){
          return Text("Canceled",
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                  );
        }else{
          return Text("Voting",
                  style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold),
                  );
        }

      }

      return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.7),
              borderRadius: BorderRadius.circular(12.0)
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: Icon(Icons.search,color: Colors.green,),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(item.eventName.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  const SizedBox(height: 4.0,),
                  Text('Event Date : '+formattedDate.toString(),
                  style: TextStyle(color: Colors.black,fontSize: 13),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  Text(item.eventTime.toString(),
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  // Text(item.eventByNama.toString(),
                  // style: TextStyle(fontSize: 12,color: Colors.blue),
                  // ),
                  statusPlans(),
                ],
              ),
              onTap: () {
                // print(item);
                planEvent.clear();
                planEvent.add(
                  new DetailPlan(
                    int.parse(item.id.toString()),
                    item.eventName.toString(),
                    DateTime.parse(item.eventDate.toString()),
                    item.eventTime,
                    int.parse(item.stat.toString()),
                    int.parse(item.eventBy.toString()),
                    item.eventByNama.toString()
                  ),
                );
                Navigator.of(context).pushNamed('/detail-vote-plan-history');
              },
            ),
        );
    }

  @override
  void initState() {
    super.initState();
    eventsListHistory.clear();

      Future loadEvents() async {
        setState(() {
          _isLoading = true;
        });

        var result = await http.get(api_url+'ecalendar/getEventsListByUID/'+user_id.toString()+'?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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
              
              final outerResp = json.decode(jsonResponse['outer']);

              _plansPublished = outerResp['publish'];
              _plansCanceled = outerResp['cancel'];

              final countJsonResponse = respID.length;
              numItemsCount = countJsonResponse;

              for(var item in respID){
                
                eventsListHistory.add(
                  new EventsClassHistory(
                    int.parse(item['id']),
                    item['event_name'],
                    DateTime.parse(item['event_date']),
                    item['time_conv'],
                    int.parse(item['stat']),
                    int.parse(item['event_by']),
                    item['event_by_name']
                  )
                );


              }
              
              print(eventsListHistory.length);
              
              setState(() {
                _isLoading = false;
              });

              numItemsCount = eventsListHistory.length;

            }else{
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(msg: pesan);
            }
          }else{
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(msg: "There is an error occured.");
          }
      
    }

    loadEvents();
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
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text("Your plans history"),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(175),
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
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Plans Published',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    _plansPublished.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Plans Canceled',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    _plansCanceled.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                _isLoading ? Center(
                  child: LinearProgressIndicator(),
                ) : const SizedBox(height: 0.0,),
                const SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(750),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.0),
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
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListView.builder(
                              itemCount: numItemsCount * 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              itemBuilder: (BuildContext context, int i){
                                if(i.isOdd) return const SizedBox(height: 5.0,);
                                final index = i ~/ 2 + 1 - 1;
                                return _buildRow(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                // Card(
                //   child: ListView.builder(
                //     itemCount: numItemsCount,
                //   ),
                // ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}


class DetailVotePlanHistory extends StatefulWidget{
  const DetailVotePlanHistory({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailVotePlanHistoryState();
}

class _DetailVotePlanHistoryState extends State<DetailVotePlanHistory>{

  bool _isLoading = false;
  double _height;
  double _width;
  final _biggerFont = const TextStyle(fontSize: 15.0);
  var numItemsCount = 0;

  int _votedNo = 0,_votedYes = 0;

  Widget _buildRow(int idx){
    int index = idx;
    final item = votedUser[index];

    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.7),
          borderRadius: BorderRadius.circular(12.0)
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          leading: 
          planEvent[0].eventBy == item.userId ? Icon(Icons.person_pin,color: Colors.yellow) : Icon(Icons.person_pin,color: Colors.blue),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(item.userName.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Voted',
              style: TextStyle(color: Colors.black,fontSize: 15),
              ),

              item.voteStat == 1 ? Text('YES',
              style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
              ) : Text('NO',
              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
              ),
            ],
          ),
          onTap: () {
            
          },
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    votedUser.clear();

      Future loadVotedUsers() async {
        setState(() {
          _isLoading = true;
        });

        var result = await http.get(api_url+'ecalendar/getVotedUsersByEventID/'+planEvent[0].id.toString()+'?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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

              final outerResp = json.decode(jsonResponse['outer']);

              _votedNo = outerResp['no'];
              _votedYes = outerResp['yes'];

              for(var item in respID){
                
                votedUser.add(
                  new VotedUsers(
                    int.parse(item['id']),
                    int.parse(item['event_id']),
                    int.parse(item['user_id']),
                    item['name'],
                    DateTime.parse(item['vote_date']),
                    int.parse(item['vote_stat'])
                  ),
                );

              }
              
              print(votedUser.length);
              
              setState(() {
                _isLoading = false;
              });

              numItemsCount = votedUser.length;

            }else{
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(msg: pesan);
            }
          }else{
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(msg: "There is an error occured.");
          }
      
    }

    loadVotedUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    DateTime tgl = DateTime.parse(planEvent[0].eventDate.toString());
    String formattedDate = DateFormat('dd MMMM yyyy').format(tgl);
    GlobalKey _scaffold = GlobalKey();

    Widget statusPlans(){

      if(planEvent[0].stat == 1){
        return Text("Published",
                style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                );
      }else if(planEvent[0].stat == 2){
        return Text("Canceled",
                style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                );
      }else{
        return Text("Voting",
                style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold),
                );
      }

    }

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/history-plans');
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(planEvent[0].eventName),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(470),
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
                        Text("Event plan detail",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(28),
                                fontFamily: "Poppins-Bold",
                                letterSpacing: .6)),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(13),
                        ),
                        Card(
                          child: ListTile(
                            leading:  ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Icon(Icons.calendar_today),
                            ), 
                            title: Container(
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      formattedDate.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading:  ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Icon(Icons.access_time),
                            ), 
                            title: Container(
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      planEvent[0].eventTime.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
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
                                      planEvent[0].eventByNama.toString(),
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading:  ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Icon(Icons.share),
                            ), 
                            title: Container(
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: statusPlans(),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(175),
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
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Voted Yes',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    _votedYes.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Voted No',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    _votedNo.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(400),
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
                        Text("Users who have already voted",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(28),
                                fontFamily: "Poppins-Bold",
                                letterSpacing: .6)),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(13),
                        ),
                        SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListView.builder(
                                    itemCount: numItemsCount * 2,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    itemBuilder: (BuildContext context, int i){
                                      if(i.isOdd) return const SizedBox(height: 5.0,);
                                      final index = i ~/ 2 + 1 - 1;
                                      return _buildRow(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                _isLoading ? Center(
                    child: CircularProgressIndicator(),
                  ) :
                Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().setHeight(120),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 3.0),
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, -0.0),
                            blurRadius: 3.0),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        
                        _votedNo > _votedYes || _votedNo == 0 && _votedYes == 0 ? const SizedBox(height: 0.0) :
                        Align(
                          alignment: Alignment.topCenter,
                          child: InkWell(
                          child: Container(
                              alignment: Alignment(0.0, 0.0),
                              width: ScreenUtil.getInstance().setWidth(200),
                              height: ScreenUtil.getInstance().setHeight(70),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF6078ea),
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

                                    showDialog(
                                      context: _scaffold.currentContext,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: new Text("Confirmation"),
                                          content: new Text("Are you sure ?"),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text('Close'),
                                              onPressed: () {
                                                Navigator.of(dialogContext).pop();
                                              },
                                            ),
                                            new FlatButton(
                                              color: Colors.blue,
                                              child: new Text('Publish'),
                                              onPressed: () {

                                                Navigator.of(dialogContext).pop();
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                void post() async {
                                      
                                                  Map<String, String> _headers = {
                                                    HttpHeaders.authorizationHeader: api_token
                                                  };

                                                  var result = await http.post(
                                                    api_url+'ecalendar/processHistory',
                                                    headers: headers_global,
                                                    body: {
                                                      "event_id" : planEvent[0].id.toString(),
                                                      "user_id" : user_id,
                                                      "stuff" : "publish"
                                                    }
                                                  );

                                                  print(result);

                                                  if(result.body.length > 0){
                                                    var parsedData = jsonDecode(result.body);
                                                    var pesan = parsedData['message'].toString();
                                                    var stat = parsedData['status'].toString();

                                                    Future.delayed(const Duration(seconds: 1), (){
                                                        
                                                      setState(() {
                                                        _isLoading = false;
                                                      });

                                                      if(stat == '200'){
                                                        Fluttertoast.showToast(msg: pesan);
                                                        Navigator.pushReplacementNamed(context, '/history-plans');
                                                      }else{
                                                        Fluttertoast.showToast(msg: pesan);
                                                      }

                                                    });
                                                  }else{
                                                    Fluttertoast.showToast(msg: "There is an error occured.");
                                                  }
                                                    
                                                }

                                                post();

                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    );

                                  },
                                  child: Center(
                                    child: Text("Publish",
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
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InkWell(
                            child: Container(
                                alignment: Alignment(0.0, 0.0),
                                width: ScreenUtil.getInstance().setWidth(200),
                                height: ScreenUtil.getInstance().setHeight(70),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF6078ea),
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

                                      showDialog(
                                        context: _scaffold.currentContext,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: new Text("Confirmation"),
                                            content: new Text("Are you sure ?"),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text('Close'),
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                color: Colors.red,
                                                child: new Text('Cancel'),
                                                onPressed: () {

                                                  Navigator.of(dialogContext).pop();
                                                  setState(() {
                                                    _isLoading = true;
                                                  });

                                                  void post() async {
                                        
                                                    Map<String, String> _headers = {
                                                      HttpHeaders.authorizationHeader: api_token
                                                    };

                                                    var result = await http.post(
                                                      api_url+'ecalendar/processHistory',
                                                      headers: headers_global,
                                                      body: {
                                                        "event_id" : planEvent[0].id.toString(),
                                                        "user_id" : user_id,
                                                        "stuff" : "cancel"
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
                                                          Fluttertoast.showToast(msg: pesan);
                                                          Navigator.pushReplacementNamed(context, '/history-plans');
                                                        }else{
                                                          Fluttertoast.showToast(msg: pesan);
                                                        }

                                                      });

                                                    }else{
                                                      Fluttertoast.showToast(msg: "There is an error occured.");
                                                    }
                                                      
                                                  }

                                                  post();

                                                },
                                              ),
                                            ],
                                          );
                                        }
                                      );

                                    },
                                    child: Center(
                                      child: Text("Cancel",
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
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InkWell(
                            child: Container(
                                alignment: Alignment(0.0, 0.0),
                                width: ScreenUtil.getInstance().setWidth(200),
                                height: ScreenUtil.getInstance().setHeight(70),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF6078ea),
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

                                      showDialog(
                                        context: _scaffold.currentContext,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: new Text("Confirmation"),
                                            content: new Text("Are you sure ?"),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text('Close'),
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                color: Colors.red,
                                                child: new Text('Delete Now'),
                                                onPressed: () {

                                                  Navigator.of(dialogContext).pop();
                                                  setState(() {
                                                    _isLoading = true;
                                                  });

                                                  void post() async {
                                        
                                                    Map<String, String> _headers = {
                                                      HttpHeaders.authorizationHeader: api_token
                                                    };

                                                    var result = await http.post(
                                                      api_url+'ecalendar/processHistory',
                                                      headers: headers_global,
                                                      body: {
                                                        "event_id" : planEvent[0].id.toString(),
                                                        "user_id" : user_id,
                                                        "stuff" : "delete"
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
                                                          Fluttertoast.showToast(msg: pesan);
                                                          Navigator.pushReplacementNamed(context, '/history-plans');
                                                        }else{
                                                          Fluttertoast.showToast(msg: pesan);
                                                        }

                                                      });

                                                    }else{
                                                      Fluttertoast.showToast(msg: "There is an error occured.");
                                                    }
                                                      
                                                  }

                                                  post();

                                                },
                                              ),
                                            ],
                                          );
                                        }
                                      );

                                    },
                                    child: Center(
                                      child: Text("Delete",
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
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
