import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  Badge({
    @required this.child,
    @required this.value,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2),
            constraints: BoxConstraints(minHeight: 16, minWidth: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color == null ? Theme.of(context).accentColor : color),
            child: Text(
              value,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
