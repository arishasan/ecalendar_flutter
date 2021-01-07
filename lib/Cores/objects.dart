import 'package:e_calendar/UI/Pages/nakama.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Events {

  final int id;
  final String eventName;
  final DateTime eventDate;
  final DateTime eventTime;
  final int stat;
  final String namaUser;

  Events({this.id, this.eventName, this.eventDate, this.eventTime, this.stat, this.namaUser});

  factory Events.fromJson(Map<String, dynamic> eventsJson){
    return Events(
      id: int.parse(eventsJson["id"]),
      eventName: eventsJson["event_name"],
      eventDate: DateTime.parse(eventsJson["event_date"]),
      eventTime: DateTime.parse(eventsJson["event_date"]+' '+eventsJson["event_time"]),
      stat: int.parse(eventsJson["stat"]),
      namaUser: eventsJson["name"]
    );
  }

}

class NakamaClass {
  final int id;
  final String name;
  final String deviceId;
  final DateTime registeredAt;
  final DateTime lastLogin;
  final String organization;

  NakamaClass( this.id, this.name, this.deviceId, this.registeredAt, this.lastLogin, this.organization );
}

List<NakamaClass> nakamaList = new List<NakamaClass>();

class EventsClass {
  final int id;
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final int stat;
  final int eventBy;
  final String eventByNama;

  EventsClass( this.id, this.eventName, this.eventDate, this.eventTime, this.stat, this.eventBy, this.eventByNama );
}

List<EventsClass> eventsList = new List<EventsClass>();

class DetailPlan {
  final int id;
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final int stat;
  final int eventBy;
  final String eventByNama;

  DetailPlan( this.id, this.eventName, this.eventDate, this.eventTime, this.stat, this.eventBy, this.eventByNama );
}

List<DetailPlan> planEvent = new List<DetailPlan>();

class VotedUsers {
  final int id;
  final int eventId;
  final int userId;
  final String userName;
  final DateTime voteDate;
  final int voteStat;

  VotedUsers( this.id, this.eventId, this.userId, this.userName, this.voteDate, this.voteStat );
}

List<VotedUsers> votedUser = new List <VotedUsers>();


class EventsClassHistory {
  final int id;
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final int stat;
  final int eventBy;
  final String eventByNama;

  EventsClassHistory( this.id, this.eventName, this.eventDate, this.eventTime, this.stat, this.eventBy, this.eventByNama );
}

List<EventsClassHistory> eventsListHistory = new List<EventsClassHistory>();