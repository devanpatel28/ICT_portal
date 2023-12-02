import 'package:flutter/material.dart';
import 'package:ict/helpers/size.dart';

Color muColor = Color(0xFF0098B5);
getMainIcon(context,IconButton ib,String str)
{
  return Column(
    children: [
      Container(
        height: getHeight(context, 0.12),
        width: getWidth(context, 0.24),
        decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(getSize(context, 2)),
      ),
        child: ib,
      ),
      SizedBox(height: 5,),
      Text(str,style: TextStyle(fontFamily: "Main",color: Colors.black),)
    ],
  );
}