import 'package:flutter/material.dart';
import '/widgets/message_banner.dart';

class TemplateScreen extends StatefulWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final List<Widget> columnWidgets;
  final List<MessageBanner> messageBanners;

  const TemplateScreen({
    super.key,
    this.leading,
    this.actions,
    required this.columnWidgets,
    this.messageBanners = const [],
  });

  @override
  TemplateScreenState createState() => TemplateScreenState();
}

class TemplateScreenState extends State<TemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // Disable the back button
        leading: widget.leading,
        actions: widget.actions,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0), // Add padding around the whole screen
        child: Center(
          child: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque, // Ensures taps on empty space register
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // Forces keyboard to close
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.columnWidgets,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.messageBanners,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}