import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';

class SelectableImageButton extends StatefulWidget {
  final String imagePath;
  final String title;
  final double height;
  final VoidCallback onTap;
  final bool isSelected;
  final String raceCourseType;

  const SelectableImageButton({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.height,
    required this.onTap,
    required this.isSelected, 
    required this.raceCourseType,
  }) : super(key: key);
 
  @override
  _SelectableImageButtonState createState() => _SelectableImageButtonState();

}

class _SelectableImageButtonState extends State<SelectableImageButton> {
 
  Color getTitleColor(){
    return widget.isSelected ? AppColors.primaryDarkBlueColor : Colors.black; 
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.height,
      child: GestureDetector(
        onTap: () {
        widget.onTap();}, // Call the callback function,
        child: Container(
         
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: widget.isSelected ? [
                              BoxShadow(
                                color: Apputils().getColor(widget.raceCourseType), // Glow color
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : []
                ),
                child: Image.asset(
                  widget.imagePath, 
                  height: widget.height*0.65,
                  width: widget.height*0.6,
                ),
              ),
              SizedBox(height: 2,),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color:  getTitleColor()
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