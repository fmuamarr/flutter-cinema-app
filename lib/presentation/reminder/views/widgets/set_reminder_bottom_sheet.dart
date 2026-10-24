import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/infrastructure/theme/theme.dart';
import '../../../../app/utils/const/borderradius_const.dart';
import '../../../../app/utils/film_poster_helper.dart';
import '../../../../domain/entities/film/film_entity.dart';
import '../../controllers/reminder_controller.dart';
import '../../models/movie_reminder.dart';

class SetReminderBottomSheet extends StatefulWidget {
  final FilmEntity film;
  final ReminderController controller;
  final MovieReminder? existingReminder;

  const SetReminderBottomSheet({
    super.key,
    required this.film,
    required this.controller,
    this.existingReminder,
  });

  @override
  State<SetReminderBottomSheet> createState() => _SetReminderBottomSheetState();
}

class _SetReminderBottomSheetState extends State<SetReminderBottomSheet> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late int _selectedOffsetMinutes;

  final List<Map<String, dynamic>> _offsetOptions = [
    {'label': 'On Time', 'minutes': 0},
    {'label': '15 Mins Before', 'minutes': 15},
    {'label': '30 Mins Before', 'minutes': 30},
    {'label': '1 Hour Before', 'minutes': 60},
    {'label': '1 Day Before', 'minutes': 1440},
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReminder;
    if (existing != null) {
      _selectedDate = DateTime(
        existing.showTime.year,
        existing.showTime.month,
        existing.showTime.day,
      );
      _selectedTime = TimeOfDay(
        hour: existing.showTime.hour,
        minute: existing.showTime.minute,
      );
      _selectedOffsetMinutes = existing.offsetMinutes;
    } else {
      final now = DateTime.now().add(const Duration(hours: 2));
      _selectedDate = DateTime(now.year, now.month, now.day);
      _selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
      _selectedOffsetMinutes = 15;
    }
  }

  DateTime get _computedShowDateTime {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  DateTime get _computedReminderDateTime {
    return _computedShowDateTime.subtract(
      Duration(minutes: _selectedOffsetMinutes),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.disneyBlue,
              surface: AppTheme.disneyCardSurface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.disneyBlue,
              surface: AppTheme.disneyCardSurface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final posterAsset = FilmPosterHelper.getPoster(widget.film.episodeId);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.disneyDeepBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with film info
            Row(
              children: [
                if (posterAsset != null)
                  ClipRRect(
                    borderRadius: BorderradiusConst.radiusAllSmall,
                    child: Image.asset(
                      posterAsset,
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Movie Reminder',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: AppTheme.disneyCyanAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.film.title ?? 'Movie',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(color: Colors.white12),
            const SizedBox(height: 12),

            Text(
              'Pick Date',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.disneySilver,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderradiusConst.radiusAllSmall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.disneyCardSurface,
                        borderRadius: BorderradiusConst.radiusAllSmall,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: AppTheme.disneyCyanAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    borderRadius: BorderradiusConst.radiusAllSmall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.disneyCardSurface,
                        borderRadius: BorderradiusConst.radiusAllSmall,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: AppTheme.disneyCyanAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedTime.format(context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              'Remind Me',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.disneySilver,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _offsetOptions.map((opt) {
                final isSelected = _selectedOffsetMinutes == opt['minutes'];
                return ChoiceChip(
                  label: Text(
                    opt['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.disneySilver,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.disneyBlue,
                  backgroundColor: AppTheme.disneyCardSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderradiusConst.radiusAllSmall,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.disneyBlue
                          : Colors.transparent,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedOffsetMinutes = opt['minutes'] as int;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // calculated alert
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.disneyCardSurface,
                borderRadius: BorderradiusConst.radiusAllSmall,
                border: Border.all(
                  color: _computedReminderDateTime.isBefore(DateTime.now())
                      ? Colors.redAccent.withAlpha(100)
                      : AppTheme.disneyCyanAccent.withAlpha(80),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _computedReminderDateTime.isBefore(DateTime.now())
                        ? Icons.warning_amber_rounded
                        : Icons.notifications_active_rounded,
                    color: _computedReminderDateTime.isBefore(DateTime.now())
                        ? Colors.redAccent
                        : AppTheme.disneyCyanAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _computedReminderDateTime.isBefore(DateTime.now())
                              ? 'Reminder time has passed!'
                              : 'Notification will be sent:',
                          style: TextStyle(
                            color:
                                _computedReminderDateTime.isBefore(
                                  DateTime.now(),
                                )
                                ? Colors.redAccent
                                : AppTheme.disneySilver,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          _formatDateTime(_computedReminderDateTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Obx(() {
              final isSaving = widget.controller.isSaving.value;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.disneyBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderradiusConst.radiusAllSmall,
                    ),
                  ),
                  icon: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.alarm_on_rounded, size: 20),
                  label: Text(
                    isSaving
                        ? 'Scheduling...'
                        : (widget.existingReminder != null
                              ? 'Update Reminder'
                              : 'Save Reminder'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          final navigator = Navigator.of(context);
                          final success = await widget.controller
                              .scheduleReminder(
                                film: widget.film,
                                showTime: _computedShowDateTime,
                                reminderTime: _computedReminderDateTime,
                                offsetMinutes: _selectedOffsetMinutes,
                              );

                          if (success) {
                            navigator.pop();
                          }
                        },
                ),
              );
            }),

            // if existing reminder, show delete button
            if (widget.existingReminder != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text(
                    'Cancel This Reminder',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await widget.controller.cancelReminder(
                      widget.existingReminder!.id,
                    );
                    navigator.pop();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
