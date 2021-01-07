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



class ContainerFormCard extends StatefulWidget {
  const ContainerFormCard({ Key key }) : super(key: key);

  // final String title;

  @override
  State<StatefulWidget> createState() => _ContainerFormCardState();
}

class _ContainerFormCardState extends State<ContainerFormCard> with TickerProviderStateMixin {
  bool _isLoading = false;
  double _height;
  double _width;

  Map<DateTime, List> _holidays;
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    // final _selectedDay = DateTime.now();

    _holidays = {
      
    };

    _events = {
      // convertDateFromString('2020-01-09') : [['Event A0','08:00 AM','Hasan'],['Event B0','10:00 AM','Udin']],
    };

    Future loadEvents() async {
        setState(() {
          _isLoading = true;
        });

        var result = await http.get(api_url+'ecalendar/getEvents/'+user_organization.toString()+'?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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
              // final countJsonResponse = respID.length;
              // print(countJsonResponse);

              for(var item in respID){
                String respEvent = item['events'];
                var decoded = json.decode(respEvent);
                // print(decoded);
                _events[convertDateFromString(item["date"].toString())] = decoded;
              }
              
              // Events dataEvent = new Events.fromJson(jsonResponse[0]);
              
              setState(() {
                _isLoading = false;
              });

            }else{
              // Fluttertoast.showToast(msg: pesan);
              setState(() {
                _isLoading = false;
              });
            }
          }else{
            Fluttertoast.showToast(msg: "There is an error occured.");
            setState(() {
              _isLoading = false;
            });
          }
      
    }

    Future loadHolidays() async {
        setState(() {
          _isLoading = true;
        });

        var result = await http.get(api_url+'ecalendar/getHoliday?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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
            // final countJsonResponse = respID.length;
            // print(countJsonResponse);

            for(var item in respID){
              _holidays[convertDateFromString(item["date"].toString())] = [item["desc"].toString()];
            }
            
            // Events dataEvent = new Events.fromJson(jsonResponse[0]);
            
            setState(() {
              _isLoading = false;
            });

            loadEvents();

          }else{
            // Fluttertoast.showToast(msg: pesan);
            setState(() {
              _isLoading = false;
            });
          }
        }else{
          Fluttertoast.showToast(msg: "There is an error occured.");
          setState(() {
            _isLoading = false;
          });
        }
    }

    // _events[convertDateFromString('2020-01-13')] = ['Event A0'];
    loadHolidays();

    _selectedEvents = _events[_selectedEvents] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400)
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: __onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context){
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

      return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: _height / 8),
      child: new Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(770),
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
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child:  
                Text("eCalendar",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              ),
              GestureDetector(
                child: Align(
                  alignment: Alignment.center,
                  child:  
                  Text("Tap here to refresh",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(21),
                        fontFamily: "Poppins-Bold",
                        color: Colors.green,
                        letterSpacing: .6)),
                ),
                onTap: (){
                  
                  // Navigator.pushReplacementNamed(context, '/home');
                  _holidays = {
      
                  };

                  _events = {
                    // convertDateFromString('2020-01-09') : [['Event A0','08:00 AM','Hasan'],['Event B0','10:00 AM','Udin']],
                  };

                  Future loadEvents() async {
                      setState(() {
                        _isLoading = true;
                      });

                      var result = await http.get(api_url+'ecalendar/getEvents/'+user_organization.toString()+'?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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
                            // final countJsonResponse = respID.length;
                            // print(countJsonResponse);

                            for(var item in respID){
                              String respEvent = item['events'];
                              var decoded = json.decode(respEvent);
                              // print(decoded);
                              _events[convertDateFromString(item["date"].toString())] = decoded;
                            }
                            
                            // Events dataEvent = new Events.fromJson(jsonResponse[0]);
                            
                            setState(() {
                              _isLoading = false;
                            });

                          }else{
                            // Fluttertoast.showToast(msg: pesan);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }else{
                          Fluttertoast.showToast(msg: "There is an error occured.");
                          setState(() {
                            _isLoading = false;
                          });
                        }
                    
                  }

                  Future loadHolidays() async {
                      setState(() {
                        _isLoading = true;
                      });

                      var result = await http.get(api_url+'ecalendar/getHoliday?X-AUTH=77b4bf55570398c939ed6988d9149bec3a5df32b',
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
                          // final countJsonResponse = respID.length;
                          // print(countJsonResponse);

                          for(var item in respID){
                            _holidays[convertDateFromString(item["date"].toString())] = [item["desc"].toString()];
                          }
                          
                          // Events dataEvent = new Events.fromJson(jsonResponse[0]);
                          
                          setState(() {
                            _isLoading = false;
                          });

                          loadEvents();

                        }else{
                          // Fluttertoast.showToast(msg: pesan);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }else{
                        Fluttertoast.showToast(msg: "There is an error occured.");
                        setState(() {
                          _isLoading = false;
                        });
                      }
                  }

                  // _events[convertDateFromString('2020-01-13')] = ['Event A0'];
                  loadHolidays();

                  _selectedEvents = _events[_selectedEvents] ?? [];
                  _calendarController = CalendarController();

                  _animationController = AnimationController(
                    vsync: this,
                    duration: const Duration(milliseconds: 400)
                  );

                  _animationController.forward();


                },
              ),
              _isLoading ? Center(
                child: LinearProgressIndicator(),
              ) :
              _buildTableCalendarWithBuilders(),
              Expanded(child: _buildEventList())
              
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: ''
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.red[800])
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600])
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _){
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.lightBlue[100],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if(events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if(holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(date,holidays),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date) ? Colors.brown[500] : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(color: Colors.white,fontSize: 12.0),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker(DateTime date, List holidays) {
    // print(holidays);
    if(_calendarController.isSelected(date)){
      // print(holidays[0]);kk
      Fluttertoast.showToast(msg: 'Public Holiday : '+holidays[0]);
    }
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 Weeks'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0,),
        RaisedButton(
          child: Text('Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
        .map((event) => Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.7),
              borderRadius: BorderRadius.circular(12.0)
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: Icon(Icons.event_available,color: Colors.green,),
              title: Text(event[0].toString()),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(event[1].toString(),
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  Text(event[2].toString(),
                  style: TextStyle(fontSize: 12,color: Colors.blue),
                  ),
                ],
              ),
              onTap: () => print('$event tapped!'),
            ),
        )).toList(),
    );
  }
}
