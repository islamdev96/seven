// ignore_for_file: use_build_context_synchronously

import '../../../all_export.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;
  const AddNewAddressScreen(
      {super.key,
      this.isEnableUpdate = true,
      this.address,
      this.fromCheckout = false});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController =
      TextEditingController();
  final TextEditingController _contactPersonNumberController =
      TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  GoogleMapController? _controller;
  CameraPosition? _cameraPosition;
  LatLng? _initialPosition;
  bool _updateAddress = true;
  _initLoading() async {
    final userModel =
        Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
    if (widget.address == null) {
      Provider.of<LocationProvider>(context, listen: false).setAddAddressData();
    }

    if (widget.address != null) {
      _initialPosition = LatLng(double.parse(widget.address!.latitude!),
          double.parse(widget.address!.longitude!));
    } else {
      _initialPosition = LatLng(
        double.parse(Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .branches![0]
                .latitude ??
            '0'),
        double.parse(Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .branches![0]
                .longitude ??
            '0'),
      );
    }

    await Provider.of<LocationProvider>(context, listen: false)
        .initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false)
        .updateAddressStatusMessage(message: '');
    Provider.of<LocationProvider>(context, listen: false)
        .updateErrorMessage(message: '');

    if (widget.isEnableUpdate && widget.address != null) {
      _updateAddress = false;
      Provider.of<LocationProvider>(context, listen: false).updatePosition(
          CameraPosition(
              target: LatLng(double.parse(widget.address!.latitude!),
                  double.parse(widget.address!.longitude!))),
          true,
          widget.address!.address,
          context,
          false);
      _contactPersonNameController.text =
          '${widget.address!.contactPersonName}';
      _contactPersonNumberController.text =
          '${widget.address!.contactPersonNumber}';
      if (widget.address!.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(0, false);
      } else if (widget.address!.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(1, false);
      } else {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(2, false);
      }
    } else {
      _contactPersonNameController.text =
          userModel == null ? '' : '${userModel.fName}' ' ${userModel.lName}';
      _contactPersonNumberController.text =
          userModel == null ? '' : userModel.phone!;
    }
  }

  @override
  void initState() {
    super.initState();
    _initLoading();
    Provider.of<LocationProvider>(context, listen: false)
        .locationController
        .text = '';
    //_checkPermission(() => Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(context, true, mapController: _controller),context);
    if (widget.address != null && !widget.fromCheckout) {
      Provider.of<LocationProvider>(context, listen: false)
          .locationController
          .text = widget.address!.address!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : CustomAppBar(
                  title: widget.isEnableUpdate
                      ? getTranslated('update_address', context)
                      : getTranslated('add_new_address', context)))
          as PreferredSizeWidget?,
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: !ResponsiveHelper.isDesktop(context) &&
                                      height < 600
                                  ? height
                                  : height - 400),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_LARGE),
                            child: Center(
                              child: SizedBox(
                                width: 1170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!ResponsiveHelper.isDesktop(context))
                                      mapView(context, locationProvider),
                                    // for label us
                                    if (!ResponsiveHelper.isDesktop(context))
                                      DetailsView(
                                          locationProvider: locationProvider,
                                          contactPersonNameController:
                                              _contactPersonNameController,
                                          contactPersonNumberController:
                                              _contactPersonNumberController,
                                          addressNode: _addressNode,
                                          nameNode: _nameNode,
                                          numberNode: _numberNode,
                                          fromCheckout: widget.fromCheckout,
                                          address: widget.address,
                                          isEnableUpdate:
                                              widget.isEnableUpdate),
                                    if (ResponsiveHelper.isDesktop(context))
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: mapView(
                                                context, locationProvider),
                                          ),
                                          const SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_DEFAULT),
                                          Expanded(
                                            flex: 4,
                                            child: DetailsView(
                                                locationProvider:
                                                    locationProvider,
                                                contactPersonNameController:
                                                    _contactPersonNameController,
                                                contactPersonNumberController:
                                                    _contactPersonNumberController,
                                                addressNode: _addressNode,
                                                nameNode: _nameNode,
                                                numberNode: _numberNode,
                                                isEnableUpdate:
                                                    widget.isEnableUpdate,
                                                address: widget.address,
                                                fromCheckout:
                                                    widget.fromCheckout),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (ResponsiveHelper.isDesktop(context))
                          const FooterView(),
                      ],
                    ),
                  ),
                ),
              ),
              if (!ResponsiveHelper.isDesktop(context))
                ButtonsView(
                    locationProvider: locationProvider,
                    isEnableUpdate: widget.isEnableUpdate,
                    fromCheckout: widget.fromCheckout,
                    contactPersonNumberController:
                        _contactPersonNumberController,
                    contactPersonNameController: _contactPersonNameController,
                    address: widget.address),
            ],
          );
        },
      ),
    );
  }

  Container mapView(BuildContext context, LocationProvider locationProvider) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                  BoxShadow(
                    color: ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                    blurRadius: 10,
                  )
                ])
          : const BoxDecoration(),
      //margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
      padding: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE,
              vertical: Dimensions.PADDING_SIZE_LARGE)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 130 : 250,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GoogleMap(
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: widget.isEnableUpdate
                          ? LatLng(
                              double.parse(widget.address!.latitude!) ??
                                  double.parse(Provider.of<SplashProvider>(
                                          context,
                                          listen: false)
                                      .configModel!
                                      .branches![0]
                                      .latitude!),
                              double.parse(widget.address!.longitude!) ??
                                  double.parse(
                                      Provider.of<SplashProvider>(context, listen: false)
                                          .configModel!
                                          .branches![0]
                                          .longitude!))
                          : LatLng(
                              locationProvider.position.latitude.toInt() == 0
                                  ? double.parse(
                                      Provider.of<SplashProvider>(context, listen: false)
                                          .configModel!
                                          .branches![0]
                                          .latitude!)
                                  : locationProvider.position.latitude,
                              locationProvider.position.longitude.toInt() == 0
                                  ? double.parse(Provider.of<SplashProvider>(context, listen: false).configModel!.branches![0].longitude!)
                                  : locationProvider.position.longitude),
                      zoom: 8,
                    ),
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: false,
                    onCameraIdle: () {
                      if (widget.address != null && !widget.fromCheckout) {
                        locationProvider.updatePosition(
                            _cameraPosition, true, null, context, true);
                        _updateAddress = true;
                      } else {
                        if (_updateAddress) {
                          locationProvider.updatePosition(
                              _cameraPosition, true, null, context, true);
                        } else {
                          _updateAddress = true;
                        }
                      }
                    },
                    onCameraMove: ((position) => _cameraPosition = position),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      if (!widget.isEnableUpdate && _controller != null) {
                        _checkPermission(() {
                          locationProvider.getCurrentLocation(context, true,
                              mapController: _controller);
                        }, context);
                      }
                    },
                  ),
                  locationProvider.loading
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor)))
                      : const SizedBox(),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: /*Image.asset(
                      Images.restaurant_marker,
                      width: 25,
                      height: 35,
                    )*/
                          Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      )),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: InkWell(
                      onTap: () => _checkPermission(() {
                        locationProvider.getCurrentLocation(context, true,
                            mapController: _controller);
                      }, context),
                      child: Container(
                        width: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                        height: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                        margin: const EdgeInsets.only(
                            right: Dimensions.PADDING_SIZE_LARGE),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.PADDING_SIZE_SMALL),
                          color: ColorResources.WHITE_COL0R,
                        ),
                        child: Icon(
                          Icons.my_location,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteHelper.getSelectLocationRoute(),
                          arguments: SelectLocationScreen(
                              googleMapController: _controller),
                        );
                      },
                      child: Container(
                        width: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                        height: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                        margin: const EdgeInsets.only(
                            right: Dimensions.PADDING_SIZE_LARGE),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.PADDING_SIZE_SMALL),
                          color: ColorResources.WHITE_COL0R,
                        ),
                        child: Icon(
                          Icons.fullscreen,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
                child: Text(
              getTranslated('add_the_location_correctly', context)!,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: ColorResources.getTextColor(context),
                  fontSize: Dimensions.FONT_SIZE_SMALL),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              getTranslated('label_us', context)!,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: ColorResources.getHintColor(context),
                  fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: locationProvider.getAllAddressType.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  locationProvider.updateAddressIndex(index, true);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_DEFAULT,
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  margin: const EdgeInsets.only(right: 17),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.PADDING_SIZE_SMALL,
                      ),
                      border: Border.all(
                          color: locationProvider.selectAddressIndex == index
                              ? Theme.of(context).primaryColor
                              : ColorResources.BORDER_COLOR),
                      color: locationProvider.selectAddressIndex == index
                          ? Theme.of(context).primaryColor
                          : ColorResources.SEARCH_BG),
                  child: Text(
                    getTranslated(
                        locationProvider.getAllAddressType[index].toLowerCase(),
                        context)!,
                    style: poppinsRegular.copyWith(
                        color: locationProvider.selectAddressIndex == index
                            ? Theme.of(context).cardColor
                            : ColorResources.getHintColor(context)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Provider.of<LocationProvider>(context, listen: false)
          .locationController
          .text = '';
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      Provider.of<LocationProvider>(context, listen: false)
          .locationController
          .text = '';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const PermissionDialog());
    } else {
      callback();
    }
  }
}
