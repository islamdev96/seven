// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seven/data/model/response/address_model.dart';
import 'package:seven/data/model/response/base/api_response.dart';
import 'package:seven/data/model/response/base/error_response.dart';
import 'package:seven/data/model/response/response_model.dart';
import 'package:seven/data/repository/location_repo.dart';
import 'package:seven/helper/api_checker.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/utill/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';

import 'splash_provider.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final LocationRepo? locationRepo;

  LocationProvider({required this.sharedPreferences, this.locationRepo});

  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  Position _pickPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  bool _loading = false;
  bool get loading => _loading;
  final TextEditingController _locationController = TextEditingController();

  TextEditingController get locationController => _locationController;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  Placemark _address = Placemark();
  Placemark _pickAddress = Placemark();
  final String _currentAddressText = '';
  String get currentAddressText => _currentAddressText;

  Placemark get address => _address;
  Placemark get pickAddress => _pickAddress;
  final List<Marker> _markers = <Marker>[];

  List<Marker> get markers => _markers;

  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController? _mapController;
  List<Prediction> _predictionList = [];
  bool _updateAddAddressData = true;

  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController? get mapController => _mapController;

  // for get current location
  void getCurrentLocation(BuildContext context, bool fromAddress,
      {GoogleMapController? mapController}) async {
    _loading = true;
    notifyListeners();
    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;
    } catch (e) {
      myPosition = Position(
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
      );
    }
    if (fromAddress) {
      _position = myPosition;
    } else {
      _pickPosition = myPosition;
    }
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(myPosition.latitude, myPosition.longitude),
            zoom: 17),
      ));
    }
    Placemark myPlaceMark;
    try {
      if (!ResponsiveHelper.isWeb()) {
        List<Placemark> placeMarks = await placemarkFromCoordinates(
            myPosition.latitude, myPosition.longitude);
        myPlaceMark = placeMarks.first;
      } else {
        String address = await getAddressFromGeocode(
            LatLng(myPosition.latitude, myPosition.longitude), context);
        myPlaceMark =
            Placemark(name: address, locality: '', postalCode: '', country: '');
      }
    } catch (e) {
      String address = await getAddressFromGeocode(
          LatLng(myPosition.latitude, myPosition.longitude), context);
      myPlaceMark =
          Placemark(name: address, locality: '', postalCode: '', country: '');
    }
    fromAddress ? _address = myPlaceMark : _pickAddress = myPlaceMark;
    if (fromAddress) {
      _locationController.text = placeMarkToAddress(_address);
    }
    _loading = false;
    notifyListeners();
  }

  void updatePosition(CameraPosition? position, bool fromAddress,
      String? address, BuildContext context, bool forceNotify) async {
    if (_updateAddAddressData || forceNotify) {
      _loading = true;
      notifyListeners();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position!.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        } else {
          _pickPosition = Position(
            latitude: position!.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        }
        if (_changeAddress) {
          if (!ResponsiveHelper.isWeb()) {
            List<Placemark> placeMarks = await placemarkFromCoordinates(
                position.target.latitude, position.target.longitude);
            fromAddress
                ? _address = placeMarks.first
                : _pickAddress = placeMarks.first;
          } else {
            String addresss = await getAddressFromGeocode(
                LatLng(position.target.latitude, position.target.longitude),
                context);
            fromAddress
                ? _address = Placemark(name: addresss)
                : _pickAddress = Placemark(name: addresss);
          }
          if (address != null) {
            _locationController.text = address;
          } else if (fromAddress) {
            _locationController.text = placeMarkToAddress(_address);
          }
        } else {
          _changeAddress = true;
        }
      } catch (e) {}
      _loading = false;
      notifyListeners();
    } else {
      _updateAddAddressData = true;
    }
  }

  // End Address Position
  void draggableAddress() async {
    try {
      _loading = true;
      notifyListeners();
      if (ResponsiveHelper.isMobilePhone()) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _position.latitude, _position.longitude);
        _address = placemarks.first;
        _locationController.text = placeMarkToAddress(_address);
      }
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
    }
  }

  // delete usser address
  void deleteUserAddressByID(int? id, int index, Function callback) async {
    ApiResponse apiResponse = await locationRepo!.removeAddressByID(id);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _addressList!.removeAt(index);
      callback(true, 'Deleted address successfully');
      notifyListeners();
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      callback(false, errorMessage);
    }
  }

  final bool _isAvaibleLocation = false;

  bool get isAvaibleLocation => _isAvaibleLocation;

  // user address
  List<AddressModel>? _addressList;

  List<AddressModel>? get addressList => _addressList;

  Future<ResponseModel?> initAddressList(BuildContext context) async {
    ResponseModel? responseModel;
    ApiResponse apiResponse = await locationRepo!.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _addressList = [];
      apiResponse.response!.data.forEach(
          (address) => _addressList!.add(AddressModel.fromJson(address)));
      responseModel = ResponseModel(true, 'successful');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return responseModel;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _errorMessage = '';
  String? get errorMessage => _errorMessage;
  String? _addressStatusMessage = '';
  String? get addressStatusMessage => _addressStatusMessage;
  updateAddressStatusMessage({String? message}) {
    _addressStatusMessage = message;
  }

  updateErrorMessage({String? message}) {
    _errorMessage = message;
  }

  Future<ResponseModel> addAddress(
      AddressModel addressModel, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse = await locationRepo!.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      initAddressList(context);
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for address update screen
  Future<ResponseModel> updateAddress(BuildContext context,
      {required AddressModel addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse =
        await locationRepo!.updateAddress(addressModel, addressId);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      initAddressList(context);
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for save user address Section
  Future<void> saveUserAddress({Placemark? address}) async {
    String userAddress = jsonEncode(address);
    try {
      await sharedPreferences!
          .setString(AppConstants.USER_ADDRESS, userAddress);
    } catch (e) {
      rethrow;
    }
  }

  String getUserAddress() {
    return sharedPreferences!.getString(AppConstants.USER_ADDRESS) ?? "";
  }

  // for Label Us
  List<String> _getAllAddressType = [];

  List<String> get getAllAddressType => _getAllAddressType;
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  initializeAllAddressType({BuildContext? context}) {
    if (_getAllAddressType.isEmpty) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo!.getAllAddressType(context: context);
    }
  }

  void setLocation(String? placeID, String? address,
      GoogleMapController? mapController) async {
    _loading = true;
    notifyListeners();
    PlacesDetailsResponse detail;
    ApiResponse response = await locationRepo!.getPlaceDetails(placeID);
    detail = PlacesDetailsResponse.fromJson(response.response!.data);

    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lat,
      latitude: detail.result.geometry!.location.lng,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
    );

    _pickAddress = Placemark(name: address);
    _changeAddress = false;

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng,
          ),
          zoom: 17)));
    }
    _loading = false;
    notifyListeners();
  }

  void disableButton() {
    _buttonDisabled = true;
    notifyListeners();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress;
    _locationController.text = placeMarkToAddress(_address);
    _updateAddAddressData = false;
    notifyListeners();
  }

  void initialAddressData(BuildContext context) {
    _position = Position(
        longitude: double.parse(
            Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .ecommerceLocationCoverage!
                    .longitude ??
                '0'),
        latitude: double.parse(
            Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .ecommerceLocationCoverage!
                    .latitude ??
                '0'),
        timestamp: DateTime.now(),
        heading: 1,
        accuracy: 1,
        altitude: 1,
        speedAccuracy: 1,
        speed: 1);
    _address = _pickAddress;
    _locationController.text = placeMarkToAddress(_address);
    _updateAddAddressData = false;
    notifyListeners();
  }

  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
    _locationController.text = placeMarkToAddress(_address);
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<String> getAddressFromGeocode(
      LatLng latLng, BuildContext context) async {
    ApiResponse response = await locationRepo!.getAddressFromGeocode(latLng);
    String address = 'Unknown Location Found';
    if (response.response!.statusCode == 200 &&
        response.response!.data['status'] == 'OK') {
      address =
          response.response!.data['results'][0]['formatted_address'].toString();
    } else {
      ApiChecker.checkApi(context, response);
    }
    return address;
  }

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text.isNotEmpty) {
      ApiResponse response = await locationRepo!.searchLocation(text);
      if (response.response!.statusCode == 200 &&
          response.response!.data['status'] == 'OK') {
        _predictionList = [];
        response.response!.data['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(context, response);
      }
    }
    return _predictionList;
  }

  String placeMarkToAddress(Placemark placeMark) {
    return '${placeMark.name ?? ''}'
        ' ${placeMark.subAdministrativeArea ?? ''}'
        ' ${placeMark.isoCountryCode ?? ''}';
  }
}
