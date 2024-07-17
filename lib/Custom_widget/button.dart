import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class button extends StatelessWidget {
  final String btnName;
  final Icon? icon;
  final Color? bgColor;
  final TextStyle? textStyle;
  final VoidCallback? callback;
  final double? width;
  final double? height;

  button({
    required this.btnName,
    this.icon,
    this.bgColor ,
    this.textStyle,
    this.callback,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          callback!();
        },
        child: icon != null ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon!,
            SizedBox(width: 8),
            Text(btnName , style: textStyle,)
          ],
        ) : Text(btnName , style: textStyle,) ,
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shadowColor: bgColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(17))
            )
        ),
      ),
    );
  }
}
