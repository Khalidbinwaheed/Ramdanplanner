import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late TextEditingController _latController;
  late TextEditingController _longController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsViewModelProvider);
    _nameController = TextEditingController(text: settings.userName ?? '');
    _cityController = TextEditingController(text: settings.city ?? '');
    _latController = TextEditingController(
      text: settings.latitude?.toString() ?? '',
    );
    _longController = TextEditingController(
      text: settings.longitude?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    final l10n = AppLocalizations.of(context)!;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.locationDisabled)));
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.locationPermissionDenied)),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.locationPermissionPermanent)),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.detectingLocation)));
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _latController.text = position.latitude.toString();
        _longController.text = position.longitude.toString();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.locationError(e.toString()))),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        final settings = ref.read(settingsViewModelProvider);

        final newSettings = settings.copyWith(
          userName: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
          city: _cityController.text,
          latitude: double.tryParse(_latController.text),
          longitude: double.tryParse(_longController.text),
        );

        await ref
            .read(settingsViewModelProvider.notifier)
            .updateSettings(newSettings);

        if (mounted) {
          final messenger = ScaffoldMessenger.of(context);
          final l10n = AppLocalizations.of(context)!;
          Navigator.pop(context); // Close settings
          messenger.showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving settings: $e')));
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep dark background
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLabel(l10n.name),
            _buildTextField(
              controller: _nameController,
              hint: l10n.enterName,
              highlight: true,
            ),
            const SizedBox(height: 16),

            _buildLabel(l10n.city),
            _buildTextField(controller: _cityController, hint: l10n.cityHint),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(l10n.latitude),
                      _buildTextField(controller: _latController, hint: '0.00'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(l10n.longitude),
                      _buildTextField(
                        controller: _longController,
                        hint: '0.00',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Detect Location Button
            OutlinedButton.icon(
              onPressed: _detectLocation,
              icon: const Icon(Icons.pin_drop, color: Colors.pinkAccent),
              label: Text(
                l10n.detectMyLocation,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel(l10n.calculationMethod),
            _buildDropdown<int>(
              value: settings.calculationMethod,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text(l10n.calculationMethodKarachi),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text(l10n.calculationMethodISNA),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text(l10n.calculationMethodMWL),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Text(l10n.calculationMethodMakkah),
                ),
                DropdownMenuItem(
                  value: 5,
                  child: Text(l10n.calculationMethodEgypt),
                ),
              ],
              onChanged: (val) {
                if (val != null) viewModel.setCalculationMethod(val);
              },
            ),

            const SizedBox(height: 16),

            _buildLabel(l10n.school),
            _buildDropdown<int>(
              value: settings.asrSchool,
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.schoolStandard)),
                DropdownMenuItem(value: 1, child: Text(l10n.schoolHanafi)),
              ],
              onChanged: (val) {
                if (val != null) viewModel.setAsrSchool(val);
              },
            ),

            const SizedBox(height: 16),

            _buildLabel(l10n.language),
            _buildDropdown<String>(
              value: settings.language,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.languageEnglish),
                ),
                DropdownMenuItem(value: 'ar', child: Text(l10n.languageArabic)),
                DropdownMenuItem(value: 'ur', child: Text(l10n.languageUrdu)),
              ],
              onChanged: (val) {
                if (val != null) viewModel.setLanguage(val);
              },
            ),

            const SizedBox(height: 16),

            _buildLabel(l10n.currency),
            _buildDropdown<String>(
              value: settings.currency,
              items: const [
                DropdownMenuItem(value: 'PKR', child: Text('PKR')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'SAR', child: Text('SAR')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                DropdownMenuItem(value: 'GBP', child: Text('GBP')),
              ],
              onChanged: (val) {
                if (val != null) viewModel.setCurrency(val);
              },
            ),

            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Text(l10n.save),
            ),

            const SizedBox(height: 24),

            // Reset Data
            Center(
              child: TextButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.resetAllDataTitle),
                      content: Text(l10n.resetAllDataContent),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(l10n.reset),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref
                        .read(plannerViewModelProvider.notifier)
                        .resetAllData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.allDataReset)),
                      );
                    }
                  }
                },
                child: Text(
                  l10n.resetAppData,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[400], fontSize: 14),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool highlight = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: highlight
              ? BorderSide(color: Theme.of(context).primaryColor)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          isExpanded: true,
        ),
      ),
    );
  }
}
