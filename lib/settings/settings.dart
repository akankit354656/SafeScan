import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color selectedColor = Colors.red;
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
    return Scaffold(
      // ── Kill the default white Scaffold background ──
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
        // ── Full-screen gradient ──
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: _gradientColors,
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // ── physics so it always scrolls even when content is short ──
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  // ── Forces content to be AT LEAST the full visible height ──
                  // so the gradient always fills the screen even when
                  // there's little content.
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Color Scheme ──────────────────────────
                          _sectionLabel("Color Scheme"),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: colorSwatches.map((color) {
                              final bool isSelected = selectedColor == color;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => selectedColor = color),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white, width: 3)
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                                color:
                                                    color.withOpacity(0.6),
                                                blurRadius: 8,
                                                spreadRadius: 2)
                                          ]
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Colors.white24),

                          // ── Theme Dropdown ────────────────────────
                          _sectionLabel("Theme (Dropdown)"),
                          const SizedBox(height: 8),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
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
                                    color: Colors.white, fontSize: 16),
                                isExpanded: true,
                                items: ['Dark', 'Light', 'System']
                                    .map((t) => DropdownMenuItem(
                                        value: t, child: Text(t)))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => selectedTheme = val!),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          const Divider(color: Colors.white24),

                          // ── Checkboxes ────────────────────────────
                          _checkboxTile(
                            title: "Beep",
                            value: beep,
                            onChanged: (v) => setState(() => beep = v!),
                          ),
                          const Divider(color: Colors.white24),
                          _checkboxTile(
                            title: "Vibrate",
                            value: vibrate,
                            onChanged: (v) => setState(() => vibrate = v!),
                          ),
                          const Divider(color: Colors.white24),
                          _checkboxTile(
                            title: "Automatically open URLs",
                            subtitle:
                                "Automatically open websites after scanning QR with URL",
                            value: autoOpenUrls,
                            onChanged: (v) =>
                                setState(() => autoOpenUrls = v!),
                          ),
                          const Divider(color: Colors.white24),
                          _checkboxTile(
                            title: "Add scans to history",
                            value: addToHistory,
                            onChanged: (v) =>
                                setState(() => addToHistory = v!),
                          ),

                          // ── This Spacer pushes everything up and
                          //    fills remaining space with gradient ──
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
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title:
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style:
                  const TextStyle(color: Colors.white54, fontSize: 12))
          : null,
      value: value,
      onChanged: onChanged,
      checkColor: Colors.white,
      activeColor: Colors.teal,
      side: const BorderSide(color: Colors.white54),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}