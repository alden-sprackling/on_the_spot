import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false).clearMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        leading: widget.leading,
        actions: widget.actions,
      ),
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Stack(
        children: [
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: messageProvider.messageBanners,
            ),
          ),
        ],
      ),
    );
  }
}