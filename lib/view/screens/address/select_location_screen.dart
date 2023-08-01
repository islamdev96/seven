import '../../../all_export.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const SelectLocationScreen({super.key, required this.googleMapController});

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(
      double.parse(Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .branches![0]
          .latitude!),
      double.parse(Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .branches![0]
          .longitude!),
    );
    Provider.of<LocationProvider>(context, listen: false).setPickData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _openSearchDialog(
      BuildContext context, GoogleMapController? mapController) async {
    showDialog(
        context: context,
        builder: (context) =>
            LocationSearchDialog(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    _locationController.text =
        '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
        '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
        '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: getTranslated('select_delivery_address', context),
              isCenter: true)) as PreferredSizeWidget?,
      body: Center(
        child: SizedBox(
          width: 1170,
          child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => Stack(
              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  indoorViewEnabled: true,
                  mapToolbarEnabled: true,
                  onCameraIdle: () {
                    locationProvider.updatePosition(
                        _cameraPosition, false, null, context, false);
                  },
                  onCameraMove: ((position) => _cameraPosition = position),
                  // markers: Set<Marker>.of(locationProvider.markers),
                  onMapCreated: (GoogleMapController controller) {
                    Future.delayed(const Duration(milliseconds: 600))
                        .then((value) {
                      _controller = controller;
                      _controller!.moveCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: locationProvider.pickPosition.longitude
                                              .toInt() ==
                                          0 &&
                                      locationProvider.pickPosition.latitude
                                              .toInt() ==
                                          0
                                  ? _initialPosition
                                  : LatLng(
                                      locationProvider.pickPosition.latitude,
                                      locationProvider.pickPosition.longitude,
                                    ),
                              zoom: 17)));
                    });
                  },
                ),
                locationProvider.pickAddress != null
                    ? InkWell(
                        onTap: () => _openSearchDialog(context, _controller),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE,
                              vertical: 18.0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE,
                              vertical: 23.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.PADDING_SIZE_SMALL)),
                          child: Builder(builder: (context) {
                            if (locationProvider.pickAddress.name != null &&
                                ResponsiveHelper.isMobilePhone()) {
                              locationProvider.locationController.text =
                                  '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}';
                            }
                            return Row(children: [
                              Expanded(
                                  child: Text(
                                      locationProvider.pickAddress.name != null
                                          ? '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}'
                                          : '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                              const Icon(Icons.search, size: 20),
                            ]);
                          }),
                        ),
                      )
                    : const SizedBox.shrink(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => _checkPermission(() {
                          locationProvider.getCurrentLocation(context, false,
                              mapController: _controller);
                        }, context),
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(
                              right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.PADDING_SIZE_SMALL),
                            color: ColorResources.getCardBgColor(context),
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).primaryColor,
                            size: 35,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.PADDING_SIZE_LARGE),
                          child: CustomButton(
                            buttonText:
                                getTranslated('select_location', context),
                            onPressed: () {
                              if (widget.googleMapController != null) {
                                if (ResponsiveHelper.isMobilePhone()) {
                                  widget.googleMapController!.setMapStyle('[]');
                                }
                                widget.googleMapController!.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: LatLng(
                                              locationProvider
                                                  .pickPosition.latitude,
                                              locationProvider
                                                  .pickPosition.longitude,
                                            ),
                                            zoom: 16)));

                                if (ResponsiveHelper.isWeb()) {
                                  locationProvider.setAddAddressData();
                                }
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                    child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 50,
                )),
                locationProvider.loading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)))
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const PermissionDialog());
    } else {
      callback();
    }
  }
}
