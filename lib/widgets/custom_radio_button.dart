import 'package:flutter/material.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        height: 30,
        child: Row(
          children: [
            _customRadioButton,
            SizedBox(width: 8),
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      height: 15,
      width: 15,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(

        decoration: BoxDecoration(
          color: isSelected ? AppColor.appColor : null,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}