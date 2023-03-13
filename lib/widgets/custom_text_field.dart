// Flutter imports:
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Package imports:

// Project imports:

class SimpleTf extends StatelessWidget {
  final String? title;
  final String? hint;
  final int? lines;
  final Widget? titleWidget;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final TextInputAction? action;
  final TextAlign? textAlign;
  final String? suffix;
  final bool? password;
  final double? vPadding;
  final EdgeInsetsGeometry? hPadding;
  final bool isExpanded;
  final Color? fillColor;
  final Color? borderSideColor;
  final double? sizedBoxWidth;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function()? onEditComplete;
  final bool? isMendotary;
  final double? width;
  final double? height;
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
  final bool? titleVisibilty;
  final bool hintWithSelected;
  final FontWeight? fontWeight;
  final double? fontSize;

  const SimpleTf(
      {this.title,
      this.hint,
      this.vPadding,
      this.onChanged,
      this.onEditComplete,
      this.lines,
      this.titleWidget,
      this.action,
      this.inputType,
      this.validator,
      this.password,
      this.suffix,
      this.textAlign,
      this.sizedBoxWidth,
      this.fillColor,
      this.isExpanded = true,
      this.hPadding,
      this.borderSideColor,
      this.controller,
      this.focusNode,
      this.isMendotary,
      this.width,
      this.height,
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
      this.titleVisibilty,
      this.hintWithSelected = false,
      this.fontWeight,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: titleVisibilty ?? true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: padding != null
                      ? const EdgeInsets.symmetric(horizontal: 20)
                      : EdgeInsets.zero,
                  child: Text(
                    title ?? "",
                    style: TextStyle(
                        color: titleColor ?? AppColor.blackColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: height ?? 50,
            margin: const EdgeInsets.only(top: 2),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              keyboardType: inputType,
              readOnly: readOnly,
              onEditingComplete: onEditComplete,
              cursorColor: AppColor.blackColor,
              maxLines: lines ?? 1,
              obscureText: lines == null ? password == true : false,
              validator: validator ?? validator,
              maxLength: maxLength,
              textAlign: textAlign ?? TextAlign.start,
              focusNode: focusNode,
              enabled: editabled ?? true,
              textInputAction: action ?? TextInputAction.done,
              textAlignVertical: TextAlignVertical.center,
              onChanged: onChanged,
              style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  fontSize: fontSize ?? 13),
              decoration: InputDecoration(
                  hintText: hint ??
                      ((title ?? "").isNotEmpty
                          ? HelperWidget.capitalize(
                              (hintWithSelected ? "Select " : "Enter ") +
                                  title.toString())
                          : ''),
                  counterText: "",
                  hintStyle: TextStyle(
                      color: AppColor.blackColor.withOpacity(.50),
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                  errorText: errorText,
                  filled: true,
                  fillColor: fillColor ?? AppColor.whiteColor,
                  errorMaxLines: 2,
                  prefixIcon: prefix != null
                      ? Container(
                          padding: const EdgeInsets.only(
                            top: 13,
                            bottom: 13,
                          ),
                          height: 5,
                          width: 5,
                          child: Image.asset(prefix!),
                        )
                      : null,
                  contentPadding: padding ??
                      EdgeInsets.symmetric(
                          horizontal: 15, vertical: (lines ?? 0) > 1 ? 15 : 0),
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
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 5),
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
}
