import 'package:flutter/material.dart';

class AddPlayerWidget extends StatefulWidget {
  String? networkImage;
  Function()? removeFunction;
  bool added;
  AddPlayerWidget({Key? key,this.removeFunction,required this.added,this.networkImage}) : super(key: key);

  @override
  State<AddPlayerWidget> createState() => _AddPlayerWidgetState();
}

class _AddPlayerWidgetState extends State<AddPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                  color: Colors.black38,
                  width: 0.5
              )
          ),
          padding: const EdgeInsets.all(8),
          child: widget.networkImage != null ? CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(widget.networkImage!)
          ):
          const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/addPlayer.png")
          ),
    );
  }
}