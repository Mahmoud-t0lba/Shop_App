import 'package:flutter/material.dart';
import 'apis/cache_helper.dart';

import 'components.dart';

void signOut(context, widget) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      navigateAndFinish(context, widget);
    }
  });
}

String? loginToken = '';

const Color defaultColor = Colors.blue;
