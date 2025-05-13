import 'package:flutter/material.dart';
import '../widgets/message_banner.dart';

class BaseScreen extends StatefulWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final List<Widget> columnWidgets;
  final MainAxisAlignment mainAxisAlignment;
  final bool resizeToAvoidBottomInset;
  final bool showAppBar;
  final Widget? bottomNavigationBar; // Optional bottom navigation
  final Color bodyBackgroundColor; // Optional body background color
  final double leadingWidth; // Optional leading width

  const BaseScreen({
    super.key,
    this.leading,
    this.actions,
    required this.columnWidgets,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.resizeToAvoidBottomInset = true,
    this.showAppBar = true,
    this.bottomNavigationBar,
    this.bodyBackgroundColor = Colors.white,
    this.leadingWidth = 50.0, // Default value
  });

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bodyBackgroundColor,
      appBar: widget.showAppBar
          ? AppBar(
              surfaceTintColor: Colors.transparent,
              leadingWidth: widget.leadingWidth,
              automaticallyImplyLeading: false,
              leading: widget.leading != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: widget.leading,
                    )
                  : null,
              actions: widget.actions != null
                  ? [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.actions!,
                        ),
                      ),
                    ]
                  : null,
            )
          : null,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
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
            child: MessageBanner(),
          ),
        ],
      ),
    );
  }
}