
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:band_hub/widgets/app_color.dart';

// Package imports:

// Project imports:

class SimpleMessageTf extends StatelessWidget {
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
  final bool? isMendotary;
  final double? width;
  final  onSuffixTap;
  final bool? isDropDownShowing;
  final String? placeHolderText;
  final String? errorText;
  final String? prefix;
  final int? maxLength;
  final Function(bool)? onPrefixTap;
  final String? prefixText;
  final bool? editabled;
  final bool readOnly;

  SimpleMessageTf({
    this.title,
    this.hint,
    this.vPadding,
     this.onChanged,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                title??"",
                style: TextStyle(
                    color: AppColor.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              )
            ],
          ),
          Container(
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              keyboardType: inputType,
              readOnly: readOnly,
              cursorColor: AppColor.blackColor,
              maxLines: password == true ? 1 : lines,
              obscureText: lines == null ? password == true : false,
              validator: validator ?? validator,
              maxLength: maxLength ?? null,
              textAlign: textAlign??TextAlign.start,
              focusNode: focusNode!=null?focusNode:null,
              enabled: editabled == null ? true : editabled,
              textInputAction: action == null ? TextInputAction.done : action,
              textAlignVertical: TextAlignVertical.center,
              onChanged: onChanged!=null?onChanged:null,
              style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 13),
              decoration: InputDecoration(
                  hintText: hint ?? "",
                  counterText: "",
                  hintStyle: TextStyle(
                      color: AppColor.blackColor.withOpacity(.50),
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                  errorText: errorText == null ? null : errorText,
                  filled: true,
                  fillColor: AppColor.whiteColor,
                  errorMaxLines: 2,
                  prefixIcon: prefix != null ? Container(
                    padding: EdgeInsets.only(right: 20,top: 15,bottom: 15,),
                    height: 5,width: 5,
                    child: Image.asset(prefix!),
                  ) : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: AppColor.whiteColor)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: AppColor.whiteColor)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: AppColor.whiteColor)
                  ),
                  suffixIcon: suffix != null ?  InkWell(splashColor: Colors.transparent,
                    onTap: onSuffixTap!=null?onSuffixTap:null,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 15,width: 15,
                      child: Image.asset(suffix!),
                    ),
                  ) : null),
            ),
          ),
        ],
      ),
    );
  }
}