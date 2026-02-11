import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constants.dart';

class SingleToneValue {
  var storage = GetStorage();
  String? status;
  String? driverID;
  int? vehicleTypeId;
  int? serviceTypeId;
  String? vehicleType;
  //StreamSubscription<LocationData>? stream;
  String code = Constants.countryCode;
  RxString codeEdit = (Constants.countryCode ?? '').obs;



  String? number;
  bool? orderPlaced = true;

  double currentLat = 31.4643687;
  var currentCity = "Unknown".obs;
  double currentLng = 74.2414678;
  String onlineOffline = 'offline';
  String currentAddress = 'Sigi Technologies lahore Kibria Town Lahore,';
  double pickLat = 0.0;
  double pickLng = 0.0;
  String driverName = '';
  double dropLat = 0.0;
  double dropLng = 0.0;
  String pickAddress = 'Sigi Technologies lahore Kibria Town Lahore';
  String? dropAddress;
  String? deviceToken;
  String? password;
  String city = '';
  String userPhone = '0000000';
  bool login = false;
  int? orderId;
  String customLocation = "";
  String postalCode = "";
  String state = "";
  String firstName = "Muhammad";
  String email = "";
  String lastName = "Bilal";
  String driverDv = "";
  String userEmail = "bilal123@gmail.com";
  String userPhone1 = "+923001234567";
  String userAddress1 = "Bahria Town, Karachi";
  String? flat;
  int? idOrder;
  String? phoneNumber;

  ///store information
  String? storeName;
  String? storeAddress;
  String? storeNumber;

  /// user information
  String? userName;
  String? userAddress;

  ///order detail information
  String? orderNumber;
  String? assignTime;
  double? totalDistance;
  String? earningEst;
  String? userId;
  int? requestId;
  String? recName;
  File? licenceBack;
  File? licenceFront;

  String? total_bill = "N/A";
  String? driver_earning = "N/A";

  String? make = "";
  String? model = "";
  String? color = "";
  String? regNum = "";
  String? year = "";
  String? profilePic = "";

  void clear() {
    code = Constants.countryCode;
  }

  SingleToneValue._privateConstructor();

  static SingleToneValue get instance => _instance;

  static final SingleToneValue _instance =
  SingleToneValue._privateConstructor();

  factory SingleToneValue() {
    return _instance;
  }
}
