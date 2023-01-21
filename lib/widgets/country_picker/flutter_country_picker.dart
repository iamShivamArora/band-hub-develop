import 'dart:async';

import 'package:flutter/material.dart';

import 'country.dart';

export 'country.dart';

/// The country picker widget exposes an dialog to select a country from a
/// pre defined list, see [Country.ALL]
class CountryPicker extends StatelessWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onChanged;
  final bool dense;
  final bool showFlag;
  final bool showDialingCode;
  final bool showName;
  final bool showNameCode;
  final bool showCurrency;
  final bool showCurrencyISO;
  final bool showArrow;
  final TextStyle? nameTextStyle;
  final TextStyle? dialingCodeTextStyle;
  final TextStyle? currencyTextStyle;
  final TextStyle? currencyISOTextStyle;
  final bool isNationality;

  final List<String>? countryFilter;

  const CountryPicker({
    Key? key,
    required this.selectedCountry,
    required this.onChanged,
    this.dense = false,
    this.showFlag = false,
    this.showDialingCode = true,
    this.showName = false,
    this.showNameCode = false,
    this.showCurrency = false,
    this.showCurrencyISO = false,
    this.showArrow = true,
    this.nameTextStyle,
    this.dialingCodeTextStyle,
    this.currencyTextStyle,
    this.currencyISOTextStyle,
    this.isNationality = false,
    this.countryFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    Country displayCountry = selectedCountry;

    return dense
        ? _renderDenseDisplay(context, displayCountry, countryFilter)
        : _renderDefaultDisplay(context, displayCountry, countryFilter);
  }

  _renderDefaultDisplay(BuildContext context, Country displayCountry,
      List<String>? countryFilter) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showFlag)
            Image.asset(
              displayCountry.asset,
              height: 32.0,
              fit: BoxFit.fitWidth,
            ),
          if (isNationality)
            Image.asset(
              displayCountry.asset,
              height: 24.0,
              fit: BoxFit.fitWidth,
            ),
          if (showName)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                " ${displayCountry.name}",
                style: nameTextStyle,
              ),
            ),
          if (showCurrencyISO)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                " ${displayCountry.currencyISO}",
                style: currencyISOTextStyle,
              ),
            ),
          if (showNameCode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                " ${displayCountry.isoCode}",
                style: dialingCodeTextStyle,
              ),
            ),
          if (showDialingCode)
            Text(
              "+${displayCountry.dialingCode}",
              style: dialingCodeTextStyle,
            ),
          if (showCurrency)
            Text(
              " ${displayCountry.currency}",
              style: currencyTextStyle,
            ),
          if (showArrow)
            Icon(Icons.keyboard_arrow_down_sharp,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
        ],
      ),
      onTap: () {
        _selectCountry(context, displayCountry, countryFilter);
      },
    );
  }

  _renderDenseDisplay(BuildContext context, Country displayCountry,
      List<String>? countryFilter) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            displayCountry.asset,
            height: 24.0,
            fit: BoxFit.fitWidth,
          ),
          Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70),
        ],
      ),
      onTap: () {
        _selectCountry(context, displayCountry, countryFilter);
      },
    );
  }

  Future<void> _selectCountry(BuildContext context, Country defaultCountry,
      List<String>? countryFilter) async {
    final Country? picked = await showCountryPicker(
        context: context,
        defaultCountry: defaultCountry,
        countryFilter: countryFilter);

    if (picked != null && picked != selectedCountry) onChanged(picked);
  }
}

/// Display a [Dialog] with the country list to selection
/// you can pass and [defaultCountry], see [Country.findByIsoCode]
Future<Country?> showCountryPicker(
    {required BuildContext context,
    required Country defaultCountry,
    List<String>? countryFilter}) async {
  assert(Country.findByIsoCode(defaultCountry.isoCode) != null);

  return await showDialog<Country>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => _CountryPickerDialog(
      defaultCountry: defaultCountry,
      countryFilter: countryFilter,
    ),
  );
}

class _CountryPickerDialog extends StatefulWidget {
  final List<String>? countryFilter;

  const _CountryPickerDialog({
    Key? key,
    Country? defaultCountry,
    this.countryFilter,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<_CountryPickerDialog> {
  TextEditingController controller = TextEditingController();
  String filter = "";
  late List<Country> countries;

  @override
  void initState() {
    super.initState();

    if (widget.countryFilter?.isNotEmpty == true) {
      List<Country> filteredCountries = [];
      for (var element in widget.countryFilter!) {
        Country country = Country.findByIsoCode(element);
        debugPrint(country.name.toString());
        filteredCountries.add(country);
      }
      countries = filteredCountries;
    } else {
      countries = Country.ALL;
    }

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 12, top: 12),
                  child: Text("Close"),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: MaterialLocalizations.of(context).searchFieldLabel,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filter == ""
                    ? const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      )
                    : InkWell(
                        child: const Icon(Icons.clear),
                        onTap: () {
                          controller.clear();
                        },
                      ),
              ),
              controller: controller,
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (BuildContext context, int index) {
                    Country country = countries[index];
                    if (filter == "" ||
                        country.name
                            .toLowerCase()
                            .contains(filter.toLowerCase()) ||
                        country.isoCode.contains(filter)) {
                      return InkWell(
                        child: ListTile(
                          trailing: Text("+ ${country.dialingCode}"),
                          title: Row(
                            children: <Widget>[
                              Image.asset(
                                country.asset,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    country.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, country);
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
