import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  //Instance of Flutter Connectivity
  // final wsController = Get.put(CustomSocketController());
  //Stream to keep listening to network change state
  static RxBool isCheck = true.obs;
  RxInt connectionType = 0.obs;
  late StreamSubscription _streamSubscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    getConnectionType();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);
  }

  // a method to get which connection result, if you we connected to internet or no if yes then which network
  Future<void> getConnectionType() async {
    var connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      print(e);
    }
    return _updateState(connectivityResult);
  }

  // state update, of network, if you are connected to WIFI connectionType will get set to 1,
  // and update the state to the consumer of that variable.
  _updateState(List<ConnectivityResult> connectivityResult) {
    // final List<ConnectivityResult> connectivityResult =
    //     await (Connectivity().checkConnectivity());

// This condition is for demo purposes only to explain every connection type.
// Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      connectionType.value = 2;
      isCheck.value = true;
      update();
      // Get.closeCurrentSnackbar();
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      isCheck.value = true;
      connectionType.value = 1;
      update();
      // Get.closeCurrentSnackbar();
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
      isCheck.value = true;
      connectionType.value = 3;
      update();
      // Get.closeCurrentSnackbar();
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      isCheck.value = true;
      connectionType.value = 4;
      update();
      // Get.closeCurrentSnackbar();
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      isCheck.value = true;
      connectionType.value = 5;
      update();
      // Get.closeCurrentSnackbar();
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      isCheck.value = true;
      connectionType.value = 6;
      update();
      // Get.closeCurrentSnackbar();
      // Get.toNamed(home);

      // Connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      isCheck.value = false;
      connectionType.value = 0;
      // SocketClient.disconnect();
      update();
    //  Get.offAll(() => LostConnection());
      // Get.showSnackbar(NetworkException().disConnectSnackBar2());
    }
    // switch (result) {
    //   case ConnectivityResult.wifi:
    //     break;
    //   case ConnectivityResult.mobile:

    //     break;
    //   case ConnectivityResult.other:

    //     break;
    //   case ConnectivityResult.none:

    //     break;
    //   default:
    //     Get.snackbar('Network Error', 'Failed to get Network Status');
    //     break;
    // }
  }

  @override
  void onClose() {
    //stop listening to network state when app is closed
    _streamSubscription.cancel();
  }
}









// import 'dart:async';
// import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:paramedicsuz_doctor/presentation/widgets/exeptions/message_snack.dart';

// class NetworkController extends GetxController {
//   RxInt connectionType = 0.obs;
//   static RxBool isCheck = true.obs;
//   final Connectivity _connectivity = Connectivity();

//   late StreamSubscription _streamSubscription;
//   @override
//   void onInit() {
//     getConnectionType();
//     super.onInit();

//     _streamSubscription =
//         _connectivity.onConnectivityChanged.listen(_updateState);
//   }

//   Future<void> getConnectionType() async {
//     var connectivityResult;
//     try {
//       connectivityResult = await (_connectivity.checkConnectivity());
//     } on PlatformException catch (e) {
//       log(e.toString());
//     }
//     return _updateState(connectivityResult);
//   }

//   _updateState(ConnectivityResult result) {
//     switch (result) {
//       case ConnectivityResult.wifi:
//         connectionType.value = 1;
//         isCheck.value = true;
//         update();
//         break;
//       case ConnectivityResult.mobile:
//         connectionType.value = 2;
//         isCheck.value = true;
//         update();
//         break;
//       case ConnectivityResult.other:
//         connectionType.value = 3;
//         isCheck.value = true;
//         update();
//         break;
//       case ConnectivityResult.none:
//         connectionType.value = 0;
//         isCheck.value = false;
//         update();
//         break;
//       default:
//         Get.showSnackbar(
//           MessageSnack().customSnack(
//             errorMessage: 'No internet !',
//           ),
//         );
//         break;
//     }
//   }

//   @override
//   void onClose() {
//     _streamSubscription.cancel();
//   }
// }

// // class NetworkController extends GetxController {
// //   RxInt connectionType = 0.obs;
// //   static RxBool isCheck = true.obs;
// //   final Connectivity _connectivity = Connectivity();

// //   late StreamSubscription _streamSubscription;
// //   @override
// //   void onInit() {
// //     getConnectionType();
// //     super.onInit();

// //     _streamSubscription =
// //         _connectivity.onConnectivityChanged.listen(_updateState);
// //   }

// //   Future<void> getConnectionType() async {
// //     var connectivityResult;
// //     try {
// //       connectivityResult = await (_connectivity.checkConnectivity());
// //     } on PlatformException catch (e) {
// //       log(e.toString());
// //     }
// //     return _updateState(connectivityResult);
// //   }

// //   _updateState(ConnectivityResult result) {
// //     switch (result) {
// //       case ConnectivityResult.wifi:
// //         connectionType.value = 1;
// //         isCheck.value = true;
// //         update();
// //         break;
// //       case ConnectivityResult.mobile:
// //         connectionType.value = 2;
// //         isCheck.value = true;
// //         update();
// //         break;
// //       case ConnectivityResult.other:
// //         connectionType.value = 3;
// //         isCheck.value = true;
// //         update();
// //         break;
// //       case ConnectivityResult.none:
// //         connectionType.value = 0;
// //         isCheck.value = false;
// //         update();
// //         break;
// //       default:
// //         Get.showSnackbar(
// //           MessageSnack().customSnack(
// //             errorMessage: 'No internet !',
// //           ),
// //         );
// //         break;
// //     }
// //   }

// //   @override
// //   void onClose() {
// //     _streamSubscription.cancel();
// //   }
// // }
