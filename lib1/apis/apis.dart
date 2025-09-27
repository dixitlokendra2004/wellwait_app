// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:wellwait_app/utils/util.dart';
//
// class Apis {
//   static Future<Object> apiCall(
//     String url,
//     String apiType,
//     Function method, {
//     var headers,
//     var body,
//     Map<dynamic, dynamic>? queryParams,
//     Map<String, String>? fields,
//     bool showSnackBar = true,
//     bool showSnackBarOnUserError = true,
//     bool applicationJson = true,
//     bool showSuccessSnackBar = false,
//     String successSnackBarContent = "",
//     bool isMultipart = false,
//     Map<String, dynamic>? multipartFiles,
//     int delayMilli = 0,
//   }) async {
//     checkInternet();
//     // try {
//     headers ??= (apiType == "PUT" || !applicationJson)
//         ? {
//             'authorization': "Bearer ${Util.accessToken}",
//           }
//         : {
//             'Content-Type': 'application/json',
//             'authorization': "Bearer ${Util.accessToken}",
//           };
//
//     if (queryParams != null) {
//       String queryString = queryParams.entries.map((entry) {
//         return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}';
//       }).join('&');
//       url = "$url?$queryString";
//     }
//
//     var request = http.Request(apiType, Uri.parse(url));
//     request.headers.addAll(headers);
//
//     printLog("------- API START ---------");
//     printLog("url: ${request.url}");
//     printLog("headers: ${request.headers}");
//     printLog("fields: $fields");
//     printLog("queryParams: $queryParams");
//     printLog("multipartFiles: $multipartFiles");
//
//     if (isMultipart) {
//       var multipartRequest = http.MultipartRequest(apiType, Uri.parse(url));
//       multipartRequest.headers.addAll(headers);
//
//       multipartFiles?.forEach((key, value) async {
//         if (value is PlatformFile) {
//           Uint8List? bytes;
//           if (isWeb) {
//             bytes = value.bytes;
//           } else {
//             File file = File(value.path ?? "");
//             bytes = await file.readAsBytes();
//           }
//           printLog("bytes $bytes");
//           if (bytes != null) {
//             multipartRequest.files.add(
//               http.MultipartFile.fromBytes(key, bytes, filename: value.name),
//             );
//           }
//         } else if (value is File) {
//           multipartRequest.files.add(http.MultipartFile(
//             key,
//             value.readAsBytes().asStream(),
//             value.lengthSync(),
//             filename: value.fileName,
//           ));
//         } else if (value is Uint8List) {
//           multipartRequest.files.add(
//             http.MultipartFile.fromBytes(
//               key,
//               value,
//             ),
//           );
//         } else if (value is List<File>) {
//           for (var file in value) {
//             multipartRequest.files.add(http.MultipartFile(
//               key,
//               file.readAsBytes().asStream(),
//               file.lengthSync(),
//               filename: file.fileName,
//             ));
//           }
//         }
//       });
//
//       printLog("multipartRequest.files ${multipartRequest.files}");
//       print(multipartRequest.files);
//       if (fields != null) {
//         fields.forEach((key, value) {
//           multipartRequest.fields[key] = value;
//         });
//       }
//
//       var response = await multipartRequest.send();
//       String responseBody = await response.stream.bytesToString();
//       printLog("${request.url} == $responseBody\nbody:");
//       printLog("Status Code: ${response.statusCode}");
//
//       var jsonRes = json.decode(responseBody);
//       if (response.statusCode == 200) {
//         if (jsonRes['status'] == 1) {
//           if (showSuccessSnackBar) {
//             if (successSnackBarContent.isNotEmpty) {
//               Util.getSnackBar(
//                 successSnackBarContent,
//                 icon: Icons.check_circle_outline,
//                 color: Colors.green,
//                 delayMilli: delayMilli,
//               );
//             } else {
//               Util.getSnackBar(
//                 jsonRes['message'].toString(),
//                 icon: Icons.check_circle_outline,
//                 color: Colors.green,
//                 delayMilli: delayMilli,
//               );
//             }
//           }
//           return Success(200, method(responseBody));
//         } else {
//           var userError = UserError(response.statusCode,
//               ErrorResponse.fromJson(json.decode(responseBody)));
//           if (showSnackBarOnUserError &&
//               userError.errorResponse.message.isNotEmpty) {
//             Util.getSnackBar(userError.errorResponse.message,
//                 icon: Icons.info_outline);
//           }
//           return userError;
//         }
//       } else {
//         var userError = UserError(response.statusCode,
//             ErrorResponse.fromJson(json.decode(responseBody)));
//         if (showSnackBarOnUserError &&
//             userError.errorResponse.message.isNotEmpty) {
//           Util.getSnackBar(userError.errorResponse.message,
//               icon: Icons.info_outline);
//         }
//         return userError;
//       }
//     } else {
//       if (body != null) {
//         request.body = json.encode(body);
//         printLog("body: ${request.body}");
//       }
//       if (fields != null) {
//         request.bodyFields = fields;
//         printLog("fields: $fields");
//       }
//
//       http.StreamedResponse response = await request.send();
//       String responseBody = await response.stream.bytesToString();
//
//       if (body != null) {
//         var bodyStr = json.encode(body);
//         printLog("body: $bodyStr");
//       }
//       if (fields != null) {
//         printLog("fields: $fields");
//       }
//       printLog("${request.url} == $responseBody\nbody==$body\nfields==$fields");
//       printLog("Status Code: ${response.statusCode}");
//
//       var jsonRes = json.decode(responseBody);
//       // printLog("Response Status: ${jsonRes['status']}");
//       printLog("------- API END ---------");
//       if (response.statusCode == 200) {
//         if (showSuccessSnackBar) {
//           if (successSnackBarContent.isNotEmpty) {
//             Util.getSnackBar(successSnackBarContent,
//                 icon: Icons.check_circle_outline,
//                 color: Colors.green,
//                 delayMilli: delayMilli);
//           } else {
//             Util.getSnackBar(jsonRes['message'].toString(),
//                 icon: Icons.check_circle_outline,
//                 color: Colors.green,
//                 delayMilli: delayMilli);
//           }
//         }
//         return Success(200, method(responseBody));
//       } else {
//         if (response.statusCode == 401) {
//           Get.toNamed('/login');
//         }
//         var userError = UserError(
//           response.statusCode,
//           ErrorResponse.fromJson(
//             json.decode(responseBody),
//           ),
//         );
//         if (showSnackBarOnUserError) {
//           if (jsonRes['message'] != null) {
//             Util.getSnackBar(jsonRes['message'].toString(),
//                 delayMilli: delayMilli);
//           } else {
//             Util.getSnackBar(AppStrings.somethingWentWrongPleaseTryAgainLater,
//                 delayMilli: delayMilli);
//           }
//         }
//         return userError;
//       }
//     }
//     // } on HttpException {
//     //   printLog("------ HttpException -------");
//     //   if (showSnackBar) {
//     //     Util.getSnackBar(AppStrings.noInternet, icon: Icons.info_outline);
//     //   }
//     //   return Failure(NO_INTERNET, AppStrings.noInternet);
//     // } on SocketException {
//     //   printLog("------- SocketException ---------");
//     //   if (showSnackBar) {
//     //     Util.getSnackBar(AppStrings.noInternet, icon: Icons.info_outline);
//     //   }
//     //   return Failure(NO_INTERNET, AppStrings.noInternet);
//     // } on FormatException {
//     //   printLog("-------- FormatException ----------");
//     //   if (showSnackBar) {
//     //     Util.getSnackBar(AppStrings.invalidFormat, icon: Icons.info_outline);
//     //   }
//     //   return Failure(INVALID_FORMAT, "Invalid Format");
//     // } catch (e) {
//     //   printLog("----------- exception: $e -----------");
//     //   if (showSnackBar) {
//     //     Util.getSnackBar(AppStrings.somethingWentWrongPleaseTryAgainLater,
//     //         icon: Icons.info_outline);
//     //   }
//     //   return Failure(
//     //     UNKNOWN_ERROR,
//     //     AppStrings.somethingWentWrongPleaseTryAgainLater,
//     //   );
//     // }
//   }
//
//   static Future<bool> checkInternet(
//       {bool showSnackBar = true,
//       String snackBarText = AppStrings.noInternet}) async {
//     /*
//     print("1");
//     try {
//       print("2");
//       final result = await InternetAddress.lookup('google.com');
//       print("3");
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         print("true");
//         return true;
//       }
//       if (showSnackBar)
//         Util.getSnackBar(snackBarText, icon: Icons.info_outline);
//       return false;
//     } catch (e) {
//       print("No Internet");
//       if (showSnackBar)
//         Util.getSnackBar(snackBarText, icon: Icons.info_outline);
//       return false;
//     }
//   */
//     return true;
//   }
// }
