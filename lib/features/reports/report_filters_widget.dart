import 'package:flutter/material.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'pdf_generator_service.dart';

/// A widget that allows the user to choose a date range and
/// optionally filter by flock/batch name.
class ReportFiltersWidget extends StatefulWidget {
  final ReportFilter initialFilter;
  final List<String> flockOrBatchNames; // pass [] if no filter needed
  final ValueChanged<ReportFilter> onChanged;

  const ReportFiltersWidget({
    super.key,
    required this.initialFilter,
    required this.flockOrBatchNames,
    required this.onChanged,
  });

  @override
  State<ReportFiltersWidget> createState() => _ReportFiltersWidgetState();
}

class _ReportFiltersWidgetState extends State<ReportFiltersWidget> {
  late DateTime _start;
  late DateTime _end;
  String? _selectedFlock;

  // Quick-range presets
  static const _presets = [
    ('This Week', 7),
    ('Last 30 Days', 30),
    ('Last 90 Days', 90),
    ('This Year', 365),
  ];

  @override
  void initState() {
    super.initState();
    _start = widget.initialFilter.startDate;
    _end = widget.initialFilter.endDate;
    _selectedFlock = widget.initialFilter.flockOrBatchName;
  }

  void _emit() {
    widget.onChanged(ReportFilter(
      startDate: _start,
      endDate: _end,
      flockOrBatchName: _selectedFlock,
      flockOrBatchId: _selectedFlock,
    ));
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _start : _end,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.cardDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _start = picked;
          if (_end.isBefore(_start)) _end = _start;
        } else {
          _end = picked;
          if (_start.isAfter(_end)) _start = _end;
        }
      });
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Filters',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondaryDark,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),

          // Quick range chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presets.map((p) {
                final (label, days) = p;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _PresetChip(
                    label: label,
                    onTap: () {
                      setState(() {
                        _end = DateTime.now();
                        _start = _end.subtract(Duration(days: days - 1));
                      });
                      _emit();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Date range pickers
          Row(
            children: [
              Expanded(
                child: _DateButton(
                  label: 'From',
                  date: _start,
                  onTap: () => _pickDate(true),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('→',
                    style: TextStyle(color: AppColors.textSecondaryDark)),
              ),
              Expanded(
                child: _DateButton(
                  label: 'To',
                  date: _end,
                  onTap: () => _pickDate(false),
                ),
              ),
            ],
          ),

          // Flock/batch filter (only shown when list is non-empty)
          if (widget.flockOrBatchNames.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Filter by Flock / Batch',
              style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _selectedFlock == null,
                    onTap: () {
                      setState(() => _selectedFlock = null);
                      _emit();
                    },
                  ),
                  const SizedBox(width: 6),
                  ...widget.flockOrBatchNames.map((name) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _FilterChip(
                          label: name,
                          selected: _selectedFlock == name,
                          onTap: () {
                            setState(() => _selectedFlock = name);
                            _emit();
                          },
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
        ),
      );
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const _DateButton(
      {required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fmt =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                size: 14, color: AppColors.textSecondaryDark),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondaryDark)),
                Text(fmt,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderDark,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondaryDark)),
        ),
      );
}
