import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ict/helpers/size.dart';
import 'package:ict/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HodScreen extends StatelessWidget {
  const HodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOD"),
        actions: [IconButton(onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15) ),
                title: Center(child: Row(
                  children: [
                    Image(image: AssetImage("assets/icon/icon.png"),width: 30),
                    SizedBox(width: getWidth(context, 0.05),),
                    Text('ICT-MU',style: TextStyle(fontFamily: "Main",fontWeight: FontWeight.bold)),
                  ],
                )),
                content: Text("Are you sure want to logout?",style: TextStyle(fontFamily: "Main"),),
                actions: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            child: Text('NO'),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              backgroundColor: Color(0xFF0098B5),
                            ),
                          ),
                          SizedBox(width: getWidth(context, 0.05),),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              backgroundColor: Color(0xFF0098B5),
                            ),
                            onPressed: () async {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("isLoginHod", false);
                              Get.off(LoginPage(),curve: Curves.bounceInOut,duration: Duration(seconds: 1));
                            },
                            child: Text('YES'),
                          ),
                        ],
                      ),
                    ),
                  ),],
              ));
        }, icon: Icon(Icons.logout_rounded))],
      ),
    );
  }
}