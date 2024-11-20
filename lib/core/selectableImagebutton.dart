import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';

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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.checkboxlist2Color : Colors.black, // Background color
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                widget.imagePath, 
                height: widget.height*0.5,
                width: widget.height*0.5,
              ),
              const SizedBox(height: 4),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 12,
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