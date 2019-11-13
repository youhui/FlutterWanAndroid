import 'package:flutter/material.dart';

class StyleUtil {
  static TextStyle getTextStyle(Color colors, double fontsizes, bool isFontWeight) {
    return TextStyle(
      color: colors,
      fontSize: fontsizes,
      fontWeight: isFontWeight == true ? FontWeight.bold : FontWeight.normal,
    );
  }

  static Widget getPadding(Widget w, double all) {
    return Padding(
      child: w,
      padding: EdgeInsets.all(all),
    );
  }

  static Widget getPaddingfromLTRB(Widget w, {double l, double t, double, r, double b}) {
    return Padding(
      child: w,
      padding: EdgeInsets.fromLTRB(l ?? 0, t ?? 0, r ?? 0, b ?? 0),
    );
  }
}
