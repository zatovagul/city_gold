import 'package:city_gold/app/constants/app_colors.dart';
import 'package:city_gold/app/constants/app_sizes.dart';
import 'package:city_gold/app/constants/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerItemWidget extends StatelessWidget {
  final IconData? icon;
  final String? asset;
  final String text;
  final VoidCallback? onPressed;
  final bool showArrow;
  final double height;

  const DrawerItemWidget({Key? key,this.icon,required this.text,required this.onPressed, this.asset, this.showArrow:true, this.height:40}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.w1 * height,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w1 * 10),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero,),
        child: Row(
          children: [
            asset==null ? Icon(icon, size: AppSizes.w1 * 20, color: AppColors.darkGrey,) :
            Padding(
              padding: EdgeInsets.only(left: AppSizes.w1 * 2),
              child: Image.asset(asset!, width: AppSizes.w1 * 17,color: AppColors.darkGrey,),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w1 * 10),
                child: Text(text, style: AppTextStyles.white13.copyWith(color: AppColors.darkGrey, fontSize: AppSizes.w1 * 11),),
              ),
            ),
            if(showArrow)
            Icon(Icons.arrow_forward_ios, size: AppSizes.w1 * 15, color: CupertinoColors.black.withOpacity(0.3),)
          ],
        ),
      ),
    );
  }
}
