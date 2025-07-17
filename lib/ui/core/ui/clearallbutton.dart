import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';

class ClearAllButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final String imagePath;

  const ClearAllButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
    required this.imagePath,
  });

  @override
  State<ClearAllButton> createState() => _ClearAllButtonState();
}

class _ClearAllButtonState extends State<ClearAllButton> {
  Color getTitleColor() {
    return widget.isSelected ? AppColors.primaryDarkBlueColor : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      }, // Call the callback function,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryDarkBlueColor, // Glow color
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ]
                    : []),
            child: Image.asset(
              widget.imagePath,
              height: 52,
              width: 48,
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
              color: getTitleColor(),
              // Title color
            ),
          ),
        ],
      ),
    );
  }
}
