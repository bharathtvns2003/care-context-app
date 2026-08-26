import 'package:flutter/material.dart';

class CCRadiuses extends Radius {
  const CCRadiuses.circular(super.radius) : super.circular();

  const CCRadiuses.circular8() : super.circular(8);
  const CCRadiuses.circular12() : super.circular(12);
  const CCRadiuses.circular16() : super.circular(16);
  const CCRadiuses.circular20() : super.circular(20);
  const CCRadiuses.circular24() : super.circular(24);
  const CCRadiuses.circular40() : super.circular(40);
}
