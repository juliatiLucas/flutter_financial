import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final Function action;
  final Color color;
  ColorSelector({this.action, this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Material(
        color: Theme.of(context).secondaryHeaderColor,
        child: InkWell(
            onTap: this.action,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: [
                  Text('Color: '),
                  Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: this.color,
                        borderRadius: BorderRadius.circular(40),
                      )),
                ]))),
      ),
    );
  }
}
