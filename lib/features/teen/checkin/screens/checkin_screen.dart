import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mindly/models/mood_model.dart';
import 'package:mindly/repositories/mood_repository.dart';
import 'package:mindly/widgets/app_button.dart';
import 'package:mindly/features/auth/controllers/auth_controller.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  int _currentStep = 0;
  String _selectedMood = '';
  double _energy = 5;
  double _stress = 5;
  final List<String> _selectedReasons = [];
  bool _isSaving = false;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Happy', 'emoji': '😊'},
    {'label': 'Calm', 'emoji': '😌'},
    {'label': 'Good', 'emoji': '🙂'},
    {'label': 'Okay', 'emoji': '😐'},
    {'label': 'Sad', 'emoji': '😔'},
    {'label': 'Anxious', 'emoji': '😰'},
    {'label': 'Angry', 'emoji': '😤'},
    {'label': 'Overwhelmed', 'emoji': '😵'},
  ];

  final List<String> _reasons = [
    'School', 'Exams', 'Friends', 'Family', 'Relationships', 'Sleep', 'Social Media', 'Body Image', 'Work'
  ];

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _saveCheckin();
    }
  }

  void _saveCheckin() async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please login again.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final entry = MoodEntry(
        id: const Uuid().v4(),
        uid: user.id,
        mood: _selectedMood,
        energy: _energy.toInt(),
        stress: _stress.toInt(),
        reasons: _selectedReasons,
        createdAt: DateTime.now(),
      );

      await ref.read(moodRepositoryProvider).saveMoodEntry(entry);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanks for checking in!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of 4'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(value: (_currentStep + 1) / 4),
            const SizedBox(height: 32),
            Expanded(child: _buildStepContent()),
            AppButton(
              text: _currentStep == 3 ? 'Finish' : 'Next',
              isLoading: _isSaving,
              onPressed: (_selectedMood.isEmpty && _currentStep == 0) || _isSaving ? null : _nextStep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildMoodStep();
      case 1:
        return _buildEnergyStressStep();
      case 2:
        return _buildReasonsStep();
      case 3:
        return _buildSummaryStep();
      default:
        return Container();
    }
  }

  Widget _buildMoodStep() {
    return Column(
      children: [
        Text('How are you feeling?', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: _moods.length,
            itemBuilder: (context, index) {
              final mood = _moods[index];
              final isSelected = _selectedMood == mood['label'];
              return InkWell(
                onTap: () => setState(() => _selectedMood = mood['label']),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                    border: Border.all(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mood['emoji'], style: const TextStyle(fontSize: 32)),
                      Text(mood['label']),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyStressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Energy Level', style: Theme.of(context).textTheme.titleLarge),
        Slider(
          value: _energy,
          min: 0,
          max: 10,
          divisions: 10,
          label: _energy.toInt().toString(),
          onChanged: (val) => setState(() => _energy = val),
        ),
        const SizedBox(height: 32),
        Text('Stress Level', style: Theme.of(context).textTheme.titleLarge),
        Slider(
          value: _stress,
          min: 0,
          max: 10,
          divisions: 10,
          label: _stress.toInt().toString(),
          onChanged: (val) => setState(() => _stress = val),
        ),
      ],
    );
  }

  Widget _buildReasonsStep() {
    return Column(
      children: [
        Text('What\'s influencing your mood?', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          children: _reasons.map((reason) {
            final isSelected = _selectedReasons.contains(reason);
            return FilterChip(
              label: Text(reason),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  if (val) _selectedReasons.add(reason);
                  else _selectedReasons.remove(reason);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
        const SizedBox(height: 24),
        Text(
          'Ready to save?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'Taking a moment to notice how you feel is a good habit.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
