import 'package:flutter/material.dart';

class CCPaddings extends EdgeInsets {
  static const CCPaddings zero = CCPaddings.only();
  const CCPaddings.all(super.value) : super.all();

  const CCPaddings.symmetric({super.vertical, super.horizontal})
      : super.symmetric();

  const CCPaddings.fromLTRB(super.left, super.top, super.right, super.bottom)
      : super.fromLTRB();

  const CCPaddings.only({
    super.left,
    super.top,
    super.right,
    super.bottom,
  }) : super.only();

  const CCPaddings.a8() : super.all(8);
  const CCPaddings.a16() : super.all(16);
  const CCPaddings.a20() : super.all(20);
  const CCPaddings.a24() : super.all(24);

  const CCPaddings.h12() : super.symmetric(horizontal: 12);
  const CCPaddings.h16() : super.symmetric(horizontal: 16);
  const CCPaddings.h20() : super.symmetric(horizontal: 20);

  const CCPaddings.v16() : super.symmetric(vertical: 16);

  const CCPaddings.h16v20() : super.symmetric(horizontal: 16, vertical: 20);
  const CCPaddings.h20v16() : super.symmetric(horizontal: 20, vertical: 16);
  const CCPaddings.h16v24() : super.symmetric(horizontal: 16, vertical: 24);
  const CCPaddings.h20v24() : super.symmetric(horizontal: 20, vertical: 24);
  const CCPaddings.h20v32() : super.symmetric(horizontal: 20, vertical: 32);
  const CCPaddings.h24v32() : super.symmetric(horizontal: 24, vertical: 32);

  const CCPaddings.sheetDefault() : super.fromLTRB(20, 24, 20, 20);
}
