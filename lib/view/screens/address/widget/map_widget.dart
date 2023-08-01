import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seven/data/model/response/order_model.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/custom_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui';

class MapWidget extends StatefulWidget {
  final DeliveryAddress? address;
  const MapWidget({super.key, required this.address});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _latLng;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address!.latitude!),
        double.parse(widget.address!.longitude!));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('delivery_address', context)),
      body: Stack(children: [
        GoogleMap(
          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
          initialCameraPosition: CameraPosition(target: _latLng, zoom: 17),
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          indoorViewEnabled: true,
          markers: _markers,
        ),
        Positioned(
          left: Dimensions.PADDING_SIZE_LARGE,
          right: Dimensions.PADDING_SIZE_LARGE,
          bottom: Dimensions.PADDING_SIZE_LARGE,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!, spreadRadius: 3, blurRadius: 10)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(
                    widget.address!.addressType == 'Home'
                        ? Icons.home_outlined
                        : widget.address!.addressType == 'Workplace'
                            ? Icons.work_outline
                            : Icons.list_alt_outlined,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.address!.addressType!,
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: ColorResources.getGreyColor(context),
                              )),
                          Text(widget.address!.address!, style: poppinsRegular),
                        ]),
                  ),
                ]),
                Text('- ${widget.address!.contactPersonName}',
                    style: poppinsRegular.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                Text('- ${widget.address!.contactPersonNumber}',
                    style: poppinsRegular),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData =
        await convertAssetToUnit8List(Images.map_marker, width: 70);

    Set<Marker> markers = {}; // Change the type to Set<Marker>
    markers.add(Marker(
      markerId: const MarkerId('marker'),
      position: _latLng,
      icon: BitmapDescriptor.fromBytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
