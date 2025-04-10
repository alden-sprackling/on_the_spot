import 'package:flutter/material.dart';
import '../widgets/system_message_banner.dart';

class BaseScreen extends StatefulWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final List<Widget> columnWidgets;
  final MainAxisAlignment mainAxisAlignment;
  final bool resizeToAvoidBottomInset;

  const BaseScreen({
    super.key,
    this.leading,
    this.actions,
    required this.columnWidgets,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        leading: widget.leading != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0), // Add padding to the left of the leading widget
                child: widget.leading,
              )
            : null,
        actions: widget.actions != null
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0), // Add padding to the right of the entire actions array
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.actions!,
                  ),
                ),
              ]
            : null,
      ),
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MessageBanner(),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0), // Add padding around the whole screen
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque, // Ensures taps on empty space register
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // Forces keyboard to close
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: widget.columnWidgets,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}