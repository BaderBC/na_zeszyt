import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PrimaryLoader {
  PrimaryLoader({required this.context});

  BuildContext context;

  static Widget getWidget(BuildContext context) {
    return LoadingAnimationWidget.inkDrop(
      color: Colors.black,
      size: 100,
    );
  }

  void popup() {
    showDialog(
      context: context,
      builder: (ctx) {
        context = ctx;
        return PrimaryLoader.getWidget(ctx);
      },
    );
  }
  
  void hidePopup() {
    Navigator.pop(context);
  }
}
