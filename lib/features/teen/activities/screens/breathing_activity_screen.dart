import 'package:flutter/material.dart';
import 'dart:async';

class BreathingActivityScreen extends StatefulWidget {
  const BreathingActivityScreen({super.key});

  @override
  State<BreathingActivityScreen> createState() => _BreathingActivityScreenState();
}

class _BreathingActivityScreenState extends State<BreathingActivityScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _text = 'Breathe In';
  int _secondsLeft = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _text = 'Breathe Out');
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          setState(() => _text = 'Breathe In');
          _controller.forward();
        }
      });

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        _controller.stop();
        _showCompletion();
      }
    });
  }

  void _showCompletion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Well Done!'),
        content: const Text('You took a moment for yourself. How do you feel now?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Pop dialog
              Navigator.of(context).pop(); // Pop activity
            },
            child: const Text('Great'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B315C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 64),
            ScaleTransition(
              scale: _animation,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 64),
            Text(
              '${_secondsLeft ~/ 60}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
