import 'package:design/design.dart';
import 'package:flutter/material.dart';

String removeAllHtmlTags(String htmlText) {
  final exp = RegExp(r"<[^>]*>", multiLine: true);

  return htmlText.replaceAll(exp, '');
}

FontWeight? weightValidation(CCTextStyle style, FontWeight? fontWeight) {
  if (fontWeight != null) {
    assert(
      (style.style.fontSize ?? 0) <= 16,
      "\n\nONLY ALLOWED FOR LABEL AND PARA FOR NOW\n",
    );
  }

  return fontWeight;
}

FontWeight? resolveFontWeight(
  CCTextStyle? dzTextStyle,
  FontWeight? fontWeight,
) {
  if (dzTextStyle == null) {
    return null;
  }

  final newFontWeight = fontWeight ?? dzTextStyle.style.fontWeight;
  if (newFontWeight == null) {
    return null;
  }

  if (dzTextStyle.fontWeights == null || dzTextStyle.fontWeights!.isEmpty) {
    return newFontWeight;
  }

  final Map<String, FontWeight> weightMapping = {
    'r': FontWeight.w400, // regular
    'md': FontWeight.w500, // medium
    'sb': FontWeight.w600, // semi-bold
    'b': FontWeight.w700, // bold
  };
  final fontWeightPair = _getFontWeightKey(newFontWeight);
  if (fontWeightPair == null) {
    return newFontWeight;
  }

  return weightMapping[dzTextStyle.fontWeights![fontWeightPair.$2]];
}

(String weightKey, int index)? _getFontWeightKey(FontWeight fontWeight) {
  switch (fontWeight.value) {
    case 400:
      return ('r', 0);
    case 500:
      return ('md', 1);
    case 600:
      return ('sb', 2);
    case 700:
      return ('b', 3);
    default:
      return null;
  }
}
