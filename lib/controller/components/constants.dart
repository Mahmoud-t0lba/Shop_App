import 'components.dart';
import '../network/local/cache_helper.dart';

void signOut(context, widget) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      navigateAndFinish(
        context,
        widget,
      );
    }
  });
}

// void printFullText(String text) {
//   final pattern = RegExp('.{1,800}');
//   pattern.allMatches(text).forEach(
//         (match) => print(
//           match.group(0),
//         ),
//       );
// }

String token = '';
