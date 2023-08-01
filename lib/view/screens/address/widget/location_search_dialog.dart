import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../all_export.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialog({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(top: 80),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
            width: 1170,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller,
                textInputAction: TextInputAction.search,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: getTranslated('search_location', context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  hintStyle:
                      Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: Theme.of(context).disabledColor,
                          ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    ),
              ),
              suggestionsCallback: (pattern) async {
                return await Provider.of<LocationProvider>(context,
                        listen: false)
                    .searchLocation(context, pattern);
              },
              itemBuilder: (context, suggestion) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Row(children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(suggestion.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              )),
                    ),
                  ]),
                );
              },
              onSuggestionSelected: (suggestion) {
                Provider.of<LocationProvider>(context, listen: false)
                    .setLocation(suggestion.placeId, suggestion.description,
                        mapController);
                Navigator.pop(context);
              },
            )),
      ),
    );
  }
}
