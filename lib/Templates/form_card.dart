import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_calendar/Cores/textfield_controllers.dart';
import 'package:e_calendar/Cores/constant_vars.dart';

class FormCard extends StatefulWidget {
  const FormCard({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  
  static const menuItems = <String>[
    'OMPRENGZ',
    'TBR'
  ];

  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems.map(
    (String value) => DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
  ).toList();

  String _selectedVal = 'OMPRENGZ';

  @override
  Widget build(BuildContext context) {
    organization = _selectedVal;

    if(user_id.toString() == '0'){

      return new Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(350),
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
              Text("Login",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              Text("Only one time",
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(22),
                  color: Colors.red
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Your Name",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Your Name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              ListTile(
                title: Text('Pick Community:'),
                trailing: DropdownButton<String>(
                  value: _selectedVal,
                  onChanged: (String newValue){
                    setState(() {
                      _selectedVal = newValue;
                      organization = _selectedVal;
                    });
                  },
                  items: _dropDownMenuItems,
                ),
              ) 
            ],
          ),
        ),
      );

    }else{
      
      return new Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(250),
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
              Text("Re:Login",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Card(
                child: ListTile(
                  leading:  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Icon(Icons.save),
                  ), 
                  title: Container(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                          user_nama.toString(),
                          style: TextStyle(fontSize: 18.0),
                        ),
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
                      ],
                    ),
                  ),
                  
                ),
              ),
            ],
          ),
        ),
      );

    }
    
  }
}
