import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:e_calendar/UI/login.dart';
import 'package:e_calendar/UI/home.dart';
import 'package:e_calendar/UI/Pages/nakama.dart';
import 'package:e_calendar/UI/Pages/profile.dart';
import 'package:e_calendar/UI/Pages/plans.dart';

// void main() => runApp(MyApp());

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  Widget _default = new Login();
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
    );
    return MaterialApp(
      title: "eCalendar",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: _default,
      routes: <String, WidgetBuilder>{
        '/login' : (BuildContext context) => new Login(),
        '/home' : (BuildContext context) => new Home(),
        '/nakama' : (BuildContext context) => new Nakama(),
        '/profile' : (BuildContext context) => new Profile(),
        '/create-plans' : (BuildContext context) => new CreatePlan(),
        '/vote-plans' : (BuildContext context) => new VotePlan(),
        '/detail-vote-plan' : (BuildContext context) => new DetailVotePlan(),
        '/history-plans' : (BuildContext context) => new HistoryPlan(),
        '/detail-vote-plan-history' : (BuildContext context) => new DetailVotePlanHistory(),
      }
    );
  }

}