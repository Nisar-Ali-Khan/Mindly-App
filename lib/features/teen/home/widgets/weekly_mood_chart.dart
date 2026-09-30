import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/models/mood_model.dart';
import 'package:intl/intl.dart';

class WeeklyMoodChart extends StatelessWidget {
  final List<MoodEntry> entries;

  const WeeklyMoodChart({super.key, required this.entries});

  int _moodToScore(String mood) {
    switch (mood) {
      case 'Happy':
        return 5;
      case 'Calm':
      case 'Good':
        return 4;
      case 'Okay':
        return 3;
      case 'Sad':
      case 'Anxious':
        return 2;
      case 'Angry':
      case 'Overwhelmed':
        return 1;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    final now = DateTime.now();
    final last7Days = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DateTime(date.year, date.month, date.day);
    });

    final spots = <FlSpot>[];
    for (int i = 0; i < 7; i++) {
      final day = last7Days[i];
      final dayEntries = entries.where((e) {
        final entryDate = DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
        return entryDate.isAtSameMomentAs(day);
      }).toList();

      if (dayEntries.isNotEmpty) {
        final avgScore = dayEntries.map((e) => _moodToScore(e.mood)).reduce((a, b) => a + b) / dayEntries.length;
        spots.add(FlSpot(i.toDouble(), avgScore));
      } else {
        spots.add(FlSpot(i.toDouble(), 0));
      }
    }

    final hasData = entries.isNotEmpty;

    if (!hasData) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Check in daily to see your weekly mood trends here!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 2.0,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < 7) {
                    final dayName = DateFormat('E').format(last7Days[index]);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        dayName[0],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: last7Days[index].day == now.day ? AppColors.amber : textColor.withValues(alpha: 0.6),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 5.5,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: spot.y > 0 ? AppColors.amber : Colors.grey.shade600,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.amber.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
