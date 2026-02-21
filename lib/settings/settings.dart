import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner_app/theme/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color selectedColor = Colors.teal;
  String selectedTheme = 'Dark';
  bool beep = false;
  bool vibrate = true;
  bool autoOpenUrls = false;
  bool addToHistory = true;

  final List<Color> colorSwatches = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.lightBlue,
    Colors.pink,
    Colors.purple,
    Colors.teal,
    Colors.purple.shade200,
    Colors.lightGreen,
  ];

  static const _gradientColors = [
    Color(0xFF003300),
    Color(0xFF004466),
    Color(0xFF005566),
    Color(0xFF003355),
  ];

  @override
  Widget build(BuildContext context) {
    // Read accent color once here, passed down to helper methods
    final accentColor = context.watch<ThemeProvider>().accentColor;

    return Scaffold(
      backgroundColor: const Color(0xFF003300),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
                accentColor.withValues(alpha: 0.6),
                accentColor.withValues(alpha: 0.2),
              ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel("Color Scheme"),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: colorSwatches.map((color) {
                              final bool isSelected = selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedColor = color);
                                  context
                                      .read<ThemeProvider>()
                                      .setAccentColor(color);
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          )
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: color.withValues(alpha: 0.6),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.white24),

                          _sectionLabel("Theme (Dropdown)"),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedTheme,
                                dropdownColor: const Color(0xFF004466),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                isExpanded: true,
                                items: ['Dark', 'Light', 'System']
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => selectedTheme = val!),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          const Divider(color: Colors.white24),

                          _checkboxTile(
                            title: "Beep",
                            value: beep,
                            accentColor: accentColor,
                            onChanged: (v) => setState(() => beep = v!),
                          ),
                          const Divider(color: Colors.white24),
                          _checkboxTile(
                            title: "Vibrate",
                            value: vibrate,
                            accentColor: accentColor,
                            onChanged: (v) => setState(() => vibrate = v!),
                          ),
                          const Divider(color: Colors.white24),
                          _checkboxTile(
                            title: "Automatically open URLs",
                            subtitle:
                                "Automatically open websites after scanning QR with URL",
                            value: autoOpenUrls,
                            accentColor: accentColor,
                            onChanged: (v) =>
                                setState(() => autoOpenUrls = v!),
                          ),
                          const Divider(color: Colors.white24),
                          _checkboxTile(
                            title: "Add scans to history",
                            value: addToHistory,
                            accentColor: accentColor,
                            onChanged: (v) =>
                                setState(() => addToHistory = v!),
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _checkboxTile({
    required String title,
    String? subtitle,
    required bool value,
    required Color accentColor,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            )
          : null,
      value: value,
      onChanged: onChanged,
      checkColor: Colors.white,
      activeColor: accentColor, // ← uses selected accent color
      side: const BorderSide(color: Colors.white54),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}