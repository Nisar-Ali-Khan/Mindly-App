import 'package:flutter/material.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/widgets/app_button.dart';

class WorryDumpScreen extends StatefulWidget {
  const WorryDumpScreen({super.key});

  @override
  State<WorryDumpScreen> createState() => _WorryDumpScreenState();
}

class _WorryDumpScreenState extends State<WorryDumpScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isReleasing = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _releaseWorry() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isReleasing = true);
    await _fadeController.forward();
    _controller.clear();
    _fadeController.reset();
    setState(() => _isReleasing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Worry released. It no longer holds power over you.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dustyRose.withValues(alpha: 0.15),
      appBar: AppBar(
        title: const Text('Worry Dump'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Unload your mind',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.deepPlum,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Write down whatever is stressing you out, then release it.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      enabled: !_isReleasing,
                      decoration: const InputDecoration(
                        hintText: 'Type your worries here...',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: _isReleasing ? 'Releasing...' : 'Release & Let Go 🕊️',
                color: AppColors.dustyRose,
                onPressed: _controller.text.isEmpty || _isReleasing ? null : _releaseWorry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
