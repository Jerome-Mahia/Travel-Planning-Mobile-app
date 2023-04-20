import 'package:flutter/material.dart';

class InheritedDataProvider extends InheritedWidget {
  final ScrollController scrollController;
  const InheritedDataProvider({Key? key, 
    required Widget child,
    required this.scrollController,
  }) : super(key: key, child: child);
  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      scrollController != oldWidget.scrollController;
  static InheritedDataProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedDataProvider>()!;
}