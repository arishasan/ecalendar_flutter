import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

convertDateFromString(String strDate){
   DateTime todayDate = DateTime.parse(strDate);
  //  print(todayDate);
   return todayDate;
  //  print(formatDate(todayDate, [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));
 }


// class AuthenticatedUser{
//   int id;
//   String username;
//   String email;
//   String nama;

//   AuthenticatedUser(this.id,this.username,this.email,this.nama);
// }

// List<AuthenticatedUser> authUser;