import 'package:flutter/material.dart';

double getHeight(context,double i)
{
  double result = MediaQuery.of(context).size.height*i;
  return result;
}
double getWidth(context,double i)
{
  double result = MediaQuery.of(context).size.width*i;
  return result;
}