import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';

class ClearAllButton extends StatefulWidget {
  final String title;
  final double height;
  final VoidCallback onTap;
  final bool isSelected;

  const ClearAllButton({
    Key? key,
    required this.title,
    required this.height,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  _ClearAllButtonState createState() => _ClearAllButtonState();
}

class _ClearAllButtonState extends State<ClearAllButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.height,
      child: GestureDetector(
        onTap: () {
          if(!widget.isSelected){
          return;
        }
          widget.onTap();
        }, // Call the callback function,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.checkboxlist2Color
                : AppColors.rectangleBoxColor, // Background color
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                overflow: TextOverflow.clip, // Clips overflow text
                // Title color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
