import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';


List checkListItems = [
    {
      "id": 0,
      "value": true,
      "title": "Ascot",
    },
    {
      "id": 1,
      "value": false,
      "title": "Darwin",
    },
    {
      "id": 2,
      "value": false,
      "title": "Albany",
    },
    {
      "id": 3,
      "value": false,
      "title": "Gundagai",
    },
    {
      "id": 4,
      "value": false,
      "title": "Toowoomba",
    },
    {
      "id": 5,
      "value": false,
      "title": "Caulfield",
    },
    {
      "id": 6,
      "value": false,
      "title": "SunShine Coast",
    },
    {
      "id": 7,
      "value": false,
      "title": "Dunkeld",
    },
    {
      "id": 8,
      "value": false,
      "title": "Kembla Grange",
    },
    {
      "id": 9,
      "value": false,
      "title": "Tauranga",
    },
    {
      "id": 10,
      "value": false,
      "title": "NewCastle",
    },
    {
      "id": 11,
      "value": false,
      "title": "Morphetville",
    },
    {
      "id": 12,
      "value": false,
      "title": "Bathrust",
    },
    {
      "id": 13,
      "value": false,
      "title": "Ipswitch",
    },
    {
      "id": 14,
      "value": false,
      "title": "RicartonPark",
    },
  ];
 


class CheckboxContainer extends StatefulWidget {
  int index;

   CheckboxContainer({
    Key? key,
    required this.index,
  }) : super(key: key);
 
  @override
  _CheckboxContainerState createState() => _CheckboxContainerState();

}

class _CheckboxContainerState extends State<CheckboxContainer> {

  String Selected = "";
  

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 35,
      child: ListTileTheme(
        horizontalTitleGap: 8,
        minLeadingWidth: 0,
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          checkColor: Colors.white,
          activeColor: AppColors.checkboxlist1Color,
          side: const BorderSide(color: AppColors.checkboxlist1Color, width: 2),
          dense: true,
          title: Text(
            textAlign: TextAlign.left,
            maxLines: 1,
            checkListItems[0]["title"],
            style: AppFonts.body,
          ),
          value: checkListItems[0]["value"],
          onChanged: (value) {
            setState(() {
              for (var element in checkListItems) {
                element["value"] = false;
              }
              checkListItems[0]["value"] = value;
              Selected =
                  "${checkListItems[0]["id"]}, ${checkListItems[0]["title"]}, ${checkListItems[0]["value"]}";
               
            });
          },
        ),
      ),
    );
  }
 
}