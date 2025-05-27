import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/utils/apputils.dart';

class SelectableImageButton extends StatefulWidget {
  final String imagePath;
  final String title;
  final double height;
  final VoidCallback onTap;
  final bool isSelected;
  final String raceCourseType;

  const SelectableImageButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.height,
    required this.onTap,
    required this.isSelected,
    required this.raceCourseType,
  });

  @override
  State<SelectableImageButton> createState() => _SelectableImageButtonState();
}

class _SelectableImageButtonState extends State<SelectableImageButton> {
  Color getTitleColor() {
    return widget.isSelected ? AppColors.primaryDarkBlueColor : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        }, // Call the callback function,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50, // Fixed width
              height: 50,
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: AppColors.selectableImageButtonColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: Apputils().getColor(
                                widget.raceCourseType), // Glow color
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ]
                      : []),
              child: Image.asset(
                widget.imagePath,
                height: widget.height * 0.65,
                width: widget.height * 0.6,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: getTitleColor()
                  // Title color
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
