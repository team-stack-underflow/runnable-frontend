import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  //debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  //debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  //debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

// Screen height minus status bar and AppBar
double usableHeight(BuildContext context) {
  /*debugPrint('uHeight = ' +
      (displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight
      ).toString()
  );*/
  return displayHeight(context) -
      MediaQuery.of(context).padding.top -
      kToolbarHeight;
}