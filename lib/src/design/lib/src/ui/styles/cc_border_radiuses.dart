import 'package:flutter/material.dart';
import 'package:design/design.dart';

class CCBorderRadiuses extends BorderRadius {
  const CCBorderRadiuses.all(super.radius) : super.all();
  const CCBorderRadiuses.vertical({super.top, super.bottom}) : super.vertical();
  const CCBorderRadiuses.horizontal({super.left, super.right})
      : super.horizontal();
  const CCBorderRadiuses.only({
    super.topLeft,
    super.topRight,
    super.bottomLeft,
    super.bottomRight,
  }) : super.only();

  const CCBorderRadiuses.a8() : super.all(const CCRadiuses.circular8());
  const CCBorderRadiuses.a12() : super.all(const CCRadiuses.circular12());
  const CCBorderRadiuses.a16() : super.all(const CCRadiuses.circular16());
  const CCBorderRadiuses.a20() : super.all(const CCRadiuses.circular20());
  const CCBorderRadiuses.a24() : super.all(const CCRadiuses.circular24());
  const CCBorderRadiuses.a40() : super.all(const CCRadiuses.circular40());
}
