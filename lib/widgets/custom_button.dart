import 'package:flutter/material.dart';
import 'package:sigma_task/constants/colors.dart';

class CustomButton extends StatefulWidget {

  Function addFunction;
  Function removeFunction;
  bool added;
  List<Map<String,String?>> imagesList;

  CustomButton({Key? key,required this.addFunction,required this.removeFunction,required this.added,required this.imagesList}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {

  late Color buttonColor;
  late String buttonText;

  @override
  void initState() {
    super.initState();
    buttonText = widget.added ? "Remove" : "Add";
    buttonColor = widget.added ? Colors.red : MyColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
        ),
        onPressed: (){

          bool isFilled = true;
          for (var element in widget.imagesList) {
            if(element["id"] == null){
              isFilled = false;
            }
          }

            setState(() {
              if(buttonText == "Add" && !widget.added){
                if(!isFilled){
                  buttonText = "Remove";
                  buttonColor = Colors.red;
                  widget.addFunction();
                }
              }
              if(buttonText == "Remove" && widget.added){
                buttonText = "Add";
                buttonColor = MyColors.primary;
                widget.removeFunction();
              }
            });

        },
        child: Text(buttonText,
          style: const TextStyle(
              color: Colors.white
          ),
        )
    );
  }
}