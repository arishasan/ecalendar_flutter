import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

final api_url = "http://10.0.2.2/ecalendar_api/index.php/";
// final api_url = "https://xreacthosting.000webhostapp.com/index.php/";
final api_token = "77b4bf55570398c939ed6988d9149bec3a5df32b";
final headers_global = { "X-AUTH" : api_token };

String user_id = '0';
String user_username = '';
String user_organization = '';
String user_nama = '';




// class AuthenticatedUser{
//   int id;
//   String username;
//   String email;
//   String nama;

//   AuthenticatedUser(this.id,this.username,this.email,this.nama);
// }

// List<AuthenticatedUser> authUser;