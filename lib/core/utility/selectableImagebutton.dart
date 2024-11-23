import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';

class SelectableImageButton extends StatefulWidget {
  final String imagePath;
  final String title;
   final double height;
  final VoidCallback onTap;
  final bool isSelected;

  const SelectableImageButton({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.height,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);
 
  @override
  _SelectableImageButtonState createState() => _SelectableImageButtonState();

}

class _SelectableImageButtonState extends State<SelectableImageButton> {
 


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.height,
      child: GestureDetector(
        onTap: () {
        widget.onTap();}, // Call the callback function,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.selectedDarkBrownColor : AppColors.checkboxlist2Color, // Background color
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.imagePath, 
                height: widget.height*0.6,
                width: widget.height*0.6,
                color: Colors.white,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white
                   // Title color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


} 