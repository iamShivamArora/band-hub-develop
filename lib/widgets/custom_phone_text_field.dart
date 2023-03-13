import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_color.dart';
import 'country_picker/country.dart';
import 'country_picker/flutter_country_picker.dart';

class SimplePhoneTf extends StatelessWidget {
  final String? title;
  final String? hint;
  final int? lines;
  final Widget? titleWidget;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final TextInputAction? action;
  final String? suffix;
  final bool? password;
  final double? vPadding;
  final EdgeInsetsGeometry? hPadding;
  final bool isExpanded;
  final Color? fillColor;
  final Color? borderSideColor;
  final double? sizedBoxWidth;
  final Function(Country) onChanged;
  final Country selectedCountry;
  final FocusNode? focusNode;
  final bool? isMendotary;
  final double? width;
  final onSuffixTap;
  final bool? isDropDownShowing;
  final String? placeHolderText;
  final String? errorText;
  final String? prefix;
  final int? maxLength;
  final Function(bool)? onPrefixTap;
  final String? prefixText;
  final bool? editabled;
  final bool readOnly;
  final EdgeInsetsGeometry? padding;
  final Color? titleColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;

  SimplePhoneTf(
      {this.title,
      this.hint,
      this.vPadding,
      //  this.onChanged,
      this.focusNode,
      this.lines,
      this.titleWidget,
      this.action,
      this.inputType,
      this.validator,
      this.password,
      this.suffix,
      this.sizedBoxWidth,
      required this.onChanged,
      required this.selectedCountry,
      this.fillColor,
      this.isExpanded = true,
      this.hPadding,
      this.borderSideColor,
      this.controller,
      this.isMendotary,
      this.width,
      this.onSuffixTap,
      this.isDropDownShowing = false,
      this.placeHolderText,
      this.errorText,
      this.prefix,
      this.maxLength,
      this.onPrefixTap,
      this.prefixText,
      this.editabled,
      this.readOnly = false,
      this.padding,
      this.titleColor,
      this.fontSize,
      this.fontWeight,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "",
                style: TextStyle(
                    color: titleColor ?? AppColor.blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              )
            ],
          ),
          SizedBox(
            height: height ?? 50,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              keyboardType: TextInputType.phone,
              readOnly: readOnly,
              cursorColor: AppColor.blackColor,
              maxLines: password == true ? 1 : lines,
              obscureText: lines == null ? password == true : false,
              validator: validator,
              maxLength: maxLength,
              focusNode: focusNode,
              enabled: editabled ?? true,
              textInputAction: action ?? TextInputAction.done,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                FilteringTextInputFormatter.allow(RegExp("[0123456789]"))
              ],
              style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  fontSize: fontSize ?? 13),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  counterText: "",
                  hintText:
                      (hint ?? '').isNotEmpty ? capitalize(hint ?? '') : "",
                  hintStyle: TextStyle(
                      color: AppColor.blackColor.withOpacity(.50),
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                  errorText: errorText,
                  filled: false,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: CountryPicker(
                            dense: false,
                            showFlag: false,
                            onChanged: onChanged,
                            dialingCodeTextStyle: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: fontWeight ?? FontWeight.w400,
                              fontSize: fontSize ?? 13,
                            ),
                            selectedCountry: selectedCountry,
                            showArrow: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 1,
                        height: 10,
                        color: AppColor.blackColor,
                      ),
                      const SizedBox(width: 10)
                    ],
                  ),
                  contentPadding:
                      padding ?? const EdgeInsets.symmetric(vertical: 0),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: fillColor ?? AppColor.grayColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: fillColor ?? AppColor.grayColor)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: fillColor ??
                              AppColor.grayColor.withOpacity(.50))),
                  suffixIcon: suffix != null
                      ? InkWell(
                          splashColor: Colors.transparent,
                          onTap: onSuffixTap,
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 20),
                            height: 5,
                            width: 5,
                            child: Image.asset(
                              suffix!,
                              color: AppColor.blackColor,
                            ),
                          ),
                        )
                      : null),
            ),
          ),
        ],
      ),
    );
  }

  String capitalize(String value) {
    if (value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }
}
