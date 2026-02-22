import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ramadan_planner/features/settings/auth_screen.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:ramadan_planner/features/tasbeeh/tasbeeh_provider.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/features/planner/data/models/settings_model.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';
import 'package:ramadan_planner/features/settings/about_screen.dart';
import 'package:ramadan_planner/features/azan/widgets/azan_settings_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _latController;
  late TextEditingController _longController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsViewModelProvider);

    _latController = TextEditingController(
      text: settings.latitude?.toString() ?? '',
    );
    _longController = TextEditingController(
      text: settings.longitude?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final adv = viewModel.advanced;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileSection(settings, adv, viewModel, l10n),
                const SizedBox(height: 12),
                _buildLocationSection(settings, viewModel, l10n),
                const SizedBox(height: 12),
                _buildAppearanceSection(settings, adv, viewModel, l10n),
                const SizedBox(height: 12),
                _buildNotificationSection(adv, viewModel, l10n),
                const SizedBox(height: 12),
                _buildDataSection(adv, viewModel, l10n),
                const SizedBox(height: 12),
                _buildAboutSection(context, l10n),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ExpansionTile(
        key: PageStorageKey(title),
        leading: Icon(icon, color: Colors.pinkAccent),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        backgroundColor: const Color(0xFF1E293B),
        collapsedBackgroundColor: const Color(0xFF1E293B),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        iconColor: Colors.pinkAccent,
        collapsedIconColor: Colors.white24,
        children: children,
      ),
    );
  }

  Widget _buildProfileSection(
    ShellUserSettings settings,
    AdvancedSettings adv,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final user = FirebaseAuth.instance.currentUser;

    return _buildSection(l10n.profile, Icons.person_outline, [
      Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.pinkAccent.withValues(alpha: 0.1),
            child: const Icon(Icons.person, color: Colors.pinkAccent, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? settings.userName ?? l10n.guestUser,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user?.email != null)
                  Text(
                    user!.email!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                Text(
                  user == null ? 'Sign in to sync' : 'Cloud Sync Enabled',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (user == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              } else {
                FirebaseAuth.instance.signOut();
              }
            },
            child: Text(
              user == null ? 'Login' : 'Logout',
              style: const TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const SizedBox(height: 8),
    ]);
  }

  Widget _buildLocationSection(
    ShellUserSettings settings,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return _buildSection(l10n.locationAndPrayer, Icons.location_on_outlined, [
      const AzanSettingsCard(),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSmallLabel(l10n.timeFormat),
                _buildDropdown<bool>(
                  value: viewModel.advanced.is24HourFormat,
                  items: [
                    DropdownMenuItem(value: false, child: Text(l10n.hour12)),
                    DropdownMenuItem(value: true, child: Text(l10n.hour24)),
                  ],
                  onChanged: (v) => viewModel.setTimeFormat(v!),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSmallLabel(l10n.school),
                _buildDropdown<int>(
                  value: settings.asrSchool,
                  items: [
                    DropdownMenuItem(
                      value: 0,
                      child: Text(l10n.schoolStandard),
                    ),
                    DropdownMenuItem(value: 1, child: Text(l10n.schoolHanafi)),
                  ],
                  onChanged: (v) => viewModel.setAsrSchool(v!),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildSmallLabel(l10n.calculationMethod),
      _buildDropdown<int>(
        value: settings.calculationMethod,
        items: [
          DropdownMenuItem(
            value: 1,
            child: Text(l10n.calculationMethodKarachi),
          ),
          DropdownMenuItem(value: 2, child: Text(l10n.calculationMethodISNA)),
          DropdownMenuItem(value: 3, child: Text(l10n.calculationMethodMWL)),
          DropdownMenuItem(value: 4, child: Text(l10n.calculationMethodMakkah)),
          DropdownMenuItem(value: 5, child: Text(l10n.calculationMethodEgypt)),
        ],
        onChanged: (v) => viewModel.setCalculationMethod(v!),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _detectLocation(context, l10n, viewModel),
          icon: const Icon(Icons.gps_fixed, size: 18),
          label: Text(l10n.autoDetectGps),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.pinkAccent,
            side: const BorderSide(color: Colors.pinkAccent),
          ),
        ),
      ),
      const SizedBox(height: 8),
    ]);
  }

  Widget _buildAppearanceSection(
    ShellUserSettings settings,
    AdvancedSettings adv,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return _buildSection(l10n.appearance, Icons.palette_outlined, [
      _buildSmallLabel(l10n.appLanguage),
      _buildDropdown<String>(
        value: settings.language,
        items: [
          DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
          DropdownMenuItem(value: 'ar', child: Text(l10n.languageArabic)),
          DropdownMenuItem(value: 'ur', child: Text(l10n.languageUrdu)),
        ],
        onChanged: (v) => viewModel.setLanguage(v!),
      ),
      const SizedBox(height: 16),
      _buildSmallLabel(l10n.currency),
      _buildDropdown<String>(
        value: settings.currency,
        items: const [
          DropdownMenuItem(value: 'PKR', child: Text('PKR (Pakistani Rupee)')),
          DropdownMenuItem(value: 'USD', child: Text('USD (US Dollar)')),
          DropdownMenuItem(value: 'AED', child: Text('AED (UAE Dirham)')),
          DropdownMenuItem(value: 'SAR', child: Text('SAR (Saudi Riyal)')),
          DropdownMenuItem(value: 'GBP', child: Text('GBP (British Pound)')),
          DropdownMenuItem(value: 'EUR', child: Text('EUR (Euro)')),
          DropdownMenuItem(value: 'INR', child: Text('INR (Indian Rupee)')),
          DropdownMenuItem(value: 'BDT', child: Text('BDT (Bangladeshi Taka)')),
        ],
        onChanged: (v) => viewModel.setCurrency(v!),
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.enableAnimations,
            style: const TextStyle(color: Colors.white),
          ),
          Switch(
            value: adv.animationsEnabled,
            onChanged: (v) => viewModel.setAnimations(v),
            activeThumbColor: Colors.pinkAccent,
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildSmallLabel(l10n.fontScale(adv.fontSize.toStringAsFixed(1))),
      Slider(
        value: adv.fontSize,
        min: 0.8,
        max: 1.5,
        divisions: 7,
        activeColor: Colors.pinkAccent,
        onChanged: (v) => viewModel.setFontSize(v),
      ),
      const SizedBox(height: 8),
    ]);
  }

  Widget _buildNotificationSection(
    AdvancedSettings adv,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return _buildSection(l10n.notifications, Icons.notifications_none, [
      _buildSmallLabel(l10n.reminderPreferences),
      ...adv.notificationToggles.entries.map((e) {
        String label;
        switch (e.key) {
          case 'quran':
            label = l10n.notifQuran;
            break;
          case 'suhoor':
            label = l10n.notifSuhoor;
            break;
          case 'iftar':
            label = l10n.notifIftar;
            break;
          case 'taraweeh':
            label = l10n.notifTaraweeh;
            break;
          case 'dua':
            label = l10n.notifDua;
            break;
          case 'quote':
            label = l10n.notifQuote;
            break;
          case 'weekly':
            label = l10n.notifWeekly;
            break;
          default:
            label = e.key;
        }
        return CheckboxListTile(
          title: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          value: e.value,
          onChanged: (v) => viewModel.setNotificationToggle(e.key, v!),
          activeColor: Colors.pinkAccent,
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }),
      const Divider(color: Colors.white10),
      _buildSmallLabel(l10n.notificationStyle),
      _buildDropdown<String>(
        value: adv.notificationStyle,
        items: [
          DropdownMenuItem(
            value: 'Standard',
            child: Text(l10n.standardNotificationStyle),
          ),
          DropdownMenuItem(
            value: 'Spiritual',
            child: Text(l10n.spiritualNotificationStyle),
          ),
          DropdownMenuItem(
            value: 'Minimal',
            child: Text(l10n.minimalNotificationStyle),
          ),
        ],
        onChanged: (v) => viewModel.setNotificationStyle(v!),
      ),
      const SizedBox(height: 8),
    ]);
  }

  Widget _buildDataSection(
    AdvancedSettings adv,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return _buildSection(l10n.dataAndPrivacy, Icons.security_outlined, [
      _buildListTile(l10n.clearTasbeehHistory, Icons.history, () {
        ref.read(tasbeehProvider.notifier).clearFullHistory();
        _showToast(l10n.historyCleared);
      }),
      _buildListTile(
        l10n.resetAppData,
        Icons.refresh,
        () => _confirmResetAll(context, viewModel, l10n),
        isDestructive: true,
      ),
      _buildListTile(l10n.exportProgressPdf, Icons.share_outlined, () {
        final entries = ref.read(plannerViewModelProvider).allEntries;
        viewModel.exportData(entries);
      }),
      _buildListTile(
        l10n.cloudBackup,
        Icons.cloud_upload_outlined,
        () => _showComingSoon(l10n, 'Cloud Sync'),
      ),
      _buildListTile(
        l10n.appLock,
        adv.appLockEnabled ? Icons.lock : Icons.lock_open,
        () => _showAppLockDialog(context, viewModel, l10n, adv),
        trailing: Switch(
          value: adv.appLockEnabled,
          onChanged: (v) => _showAppLockDialog(context, viewModel, l10n, adv),
          activeThumbColor: Colors.pinkAccent,
        ),
      ),
    ]);
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return _buildSection(l10n.about, Icons.info_outline, [
      _buildListTile(
        l10n.about,
        Icons.description_outlined,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        ),
      ),
      _buildListTile(
        l10n.rateApp,
        Icons.star_outline,
        () => _showComingSoon(l10n, l10n.rateApp),
      ),
      _buildListTile(
        l10n.shareApp,
        Icons.share_outlined,
        () => _showComingSoon(l10n, l10n.shareApp),
      ),
      _buildListTile(
        l10n.contactSupport,
        Icons.mail_outline,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        ),
      ),
      const Divider(color: Colors.white10),
      _buildListTile(
        l10n.termsOfService,
        Icons.gavel_outlined,
        () => _showTextDialog(
          context,
          l10n.termsOfService,
          l10n.termsOfServiceContent,
        ),
      ),
      _buildListTile(
        l10n.privacyPolicy,
        Icons.privacy_tip_outlined,
        () => _showTextDialog(
          context,
          l10n.privacyPolicy,
          l10n.privacyPolicyContent,
        ),
      ),
      const SizedBox(height: 8),
      Center(
        child: Text(
          'v1.5.0',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.2),
            fontSize: 10,
          ),
        ),
      ),
    ]);
  }

  Widget _buildListTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.redAccent : Colors.white60,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : Colors.white70,
          fontSize: 14,
        ),
      ),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: Colors.white10, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildSmallLabel(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white24,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white24),
        ),
      ),
    );
  }

  Future<void> _detectLocation(
    BuildContext context,
    AppLocalizations l10n,
    SettingsViewModel viewModel,
  ) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showToast(l10n.locationDisabled);
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    _showToast(l10n.detectingLocation);
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _latController.text = position.latitude.toString();
        _longController.text = position.longitude.toString();
      });
      viewModel.setLocation(position.latitude, position.longitude);
      _showToast(l10n.gpsUpdated);
    } catch (e) {
      _showToast('Error: $e');
    }
  }

  void _confirmResetAll(
    BuildContext context,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          l10n.resetAllDataTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.resetAllDataContent,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(plannerViewModelProvider.notifier).resetAllData();
              Navigator.pop(ctx);
              _showToast(l10n.allProgressReset);
            },
            child: Text(
              l10n.reset,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppLockDialog(
    BuildContext context,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
    AdvancedSettings adv,
  ) {
    if (adv.appLockEnabled) {
      // Disable
      viewModel.setAppLock(false, null);
      _showToast(l10n.appLockDisabledToast);
      return;
    }

    final pin1Controller = TextEditingController();
    final pin2Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: Text(
          l10n.setPinTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pin1Controller,
              decoration: InputDecoration(
                labelText: l10n.enterPin,
                labelStyle: const TextStyle(color: Colors.pinkAccent),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: pin2Controller,
              decoration: InputDecoration(
                labelText: l10n.confirmPin,
                labelStyle: const TextStyle(color: Colors.pinkAccent),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (pin1Controller.text.length == 4 &&
                  pin1Controller.text == pin2Controller.text) {
                viewModel.setAppLock(true, pin1Controller.text);
                Navigator.pop(ctx);
                _showToast(l10n.appLockEnabledToast);
              } else {
                _showToast(l10n.pinMismatch);
              }
            },
            child: Text(
              l10n.save,
              style: const TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(AppLocalizations l10n, String feature) {
    _showToast(l10n.comingSoon(feature));
  }

  void _showTextDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
