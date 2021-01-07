import 'package:e_calendar/UI/Pages/nakama.dart';
import 'package:flutter/material.dart';
import 'package:e_calendar/Templates/custom_shapes.dart';
import 'package:e_calendar/UI/Parts/container_main.dart';
import 'package:e_calendar/Cores/constant_vars.dart';

class Home extends StatefulWidget{
  const Home({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double _height;
  double _width;

  @override
  Widget build(BuildContext context){
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: _bottomNavBar(),
      key: scaffoldKey,
      drawer: _drawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: _height,
        width: _width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0.75,
            child: Container(
              height: _height / 6,
              padding: EdgeInsets.only(top: _height / 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.greenAccent],
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                title: Text(user_nama.toString()),
                subtitle: Text(user_organization.toString(),style: TextStyle(fontSize: 13),),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.eject),
            title: Text("Logout"),
            onTap: () {
              // Navigator.of(context).pushNamed('/login');
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
    );
  }

  Widget _bottomNavBar() {

    return BottomAppBar(
      color: Colors.white,
      notchMargin: 4,
      shape: AutomaticNotchedShape(RoundedRectangleBorder(),RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child:  Container(
        
        margin: EdgeInsets.only(left: 50, right: 50),
        decoration: BoxDecoration(

            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today,color: Colors.blue[400],),
              tooltip: 'Vote',
              onPressed: () {
                Navigator.of(context).pushNamed('/vote-plans');
              },
            ),
            IconButton(
              icon: Icon(Icons.create,color: Colors.blue[400],),
              tooltip: 'Create a plan',
              onPressed: () {
                // Navigator.pushReplacementNamed(context, '/create-plans');
                Navigator.of(context).pushNamed('/create-plans');
              },
            ),
            IconButton(
              icon: Icon(Icons.event_note,color: Colors.blue[400],),
              tooltip: 'History of your plans',
              onPressed: () {
                Navigator.of(context).pushNamed('/history-plans');
              },
            ),
            IconButton(
              icon: Icon(Icons.supervised_user_circle,color: Colors.blue[400]),
              tooltip: 'Nakama',
              onPressed: () {
                Navigator.of(context).pushNamed('/nakama');
              },
            )
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.greenAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.greenAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.25,
          child: ClipPath(
            clipper: CustomShapeClipper3(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.greenAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.25,
          child: ClipPath(
            clipper: CustomShapeClipper4(),
            child: Container(
              height: _height / 1.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.greenAccent],
                ),
              ),
            ),
          ),
        ),
        ContainerFormCard(),
        Container(
          //color: Colors.blue,
            margin: EdgeInsets.only(left: 20, right: 20, top: _height / 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset(
                          'assets/menubutton.png',
                          height: _height / 40,
                        )),
                  ),
                ),
                // Opacity(
                //   opacity: 0.5,
                //   child: GestureDetector(
                //     onTap: (){
                //       // print('Oya');
                //     },
                //         child: Stack(
                //           children: <Widget>[
                //             Icon(Icons.notifications_none, color: Colors.black,size: _height/25,),
                //             Positioned(
                //               right: 0,
                //               child: Container(
                //                 padding: EdgeInsets.all(1),
                //                 decoration: BoxDecoration(
                //                   color: Colors.red,
                //                   borderRadius: BorderRadius.circular(6),

                //                 ),
                //                 constraints: BoxConstraints(
                //                   minHeight: 12,
                //                   minWidth: 12
                //                 ),
                //                 child: Text("0",style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center),
                //               ),
                //             ),
                //           ],    
                //         ),
                //       ),
                //   ),
                  
              ],
            )),


      ],
    );
  }


}