import 'dart:async';
import 'package:flutter/material.dart';
import 'package:on_the_spot/theme/app_colors.dart';

class TimerIcon extends StatefulWidget {
  final Duration duration;
  final double size;
  final Color color;

  const TimerIcon({
    super.key,
    required this.duration,
    this.size = 48.0,
    this.color = AppColors.lightGrey,
  });

  @override
  State<TimerIcon> createState() => _TimerIconState();
}

class _TimerIconState extends State<TimerIcon> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.duration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  void didUpdateWidget(TimerIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _timer?.cancel();
      setState(() {
        _secondsLeft = widget.duration.inSeconds;
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.size / 2,
            backgroundColor: widget.color.withAlpha((0.15 * 255).round()),
            child: CircleAvatar(
              radius: widget.size / 2 - 2,
              backgroundColor: Colors.white,
            ),
          ),
          Text(
            _secondsLeft.toString(),
            style: TextStyle(
              fontSize: widget.size * 0.5,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}