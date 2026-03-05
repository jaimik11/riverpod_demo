// import 'package:c2c/router/app_pages.dart' hide Route;
// import 'package:flutter/material.dart';
// export 'app_pages.dart';
//
// extension CustomNavigation on BuildContext {
//   Future push(Route route) => Navigator.of(this).push(route);
//
//   Future pushNamed(String routeName, {Object? arguments}) =>
//       Navigator.of(this).pushNamed(routeName, arguments: arguments);
//
//   Future pushReplacementNamed(String routeName, {Object? arguments}) =>
//       Navigator.of(this).pushReplacementNamed(
//         routeName,
//         arguments: arguments,
//       );
//
//
//   // Future pushNamedAndRemoveUntil(String routeName, {Object? arguments,String? removeUntilRoute = ""}) =>
//   //     Navigator.of(this).pushNamedAndRemoveUntil(
//   //       routeName, (route) {
//   //         if(removeUntilRoute!.isNotEmpty){
//   //           return route.settings.name == removeUntilRoute;
//   //         }else{
//   //           return route.isFirst;
//   //         }
//   //       }, // or any condition you want
//   //       // routeName, (route) => removeUntilRoute ?? route.isFirst, // or any condition you want
//   //       arguments: arguments,
//   //     );
//
//
//   Future popAndPushNamed(String routeName, {Object? arguments}) =>
//       Navigator.of(this).popAndPushNamed(
//         routeName,
//         arguments: arguments,
//       );
//
//   void pop([dynamic result]) => Navigator.of(this).pop(result);
//
//   void popUntil(String routeName) =>
//       Navigator.of(this).popUntil(ModalRoute.withName(routeName));
//
//
//   void popUntilWithArgs(String routeName, {Object? result}) {
//     final navigator = Navigator.of(this);
//
//     navigator.popUntil((route) => route.settings.name == routeName);
//
//     if (result != null) {
//       navigator.pop(result); // ✅ send result back to the awaiting push
//     }
//   }
//
//
//
//   Future popAllAndPush(String newRouteName,{Object? arguments}) => Navigator.of(this)
//       .pushNamedAndRemoveUntil(newRouteName, (route) => false,arguments: arguments);
//
//   /// Clear stack until [baseRouteName] remains, then push [newRouteName]
//   Future<T?> clearUntilAndPush<T extends Object?>(
//       String newRouteName, {
//         required String baseRouteName,
//         Object? arguments,
//       }) {
//     return Navigator.of(this).pushNamedAndRemoveUntil<T>(
//       newRouteName,
//           (route) => route.settings.name == baseRouteName,
//       arguments: arguments,
//     );
//   }
//
// }
