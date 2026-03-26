import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';

/// Side panel (slides from right) for display settings.
/// Shown as an overlay within [ChapterReaderBody].
class QuickToolsPanel extends StatefulWidget {
  const QuickToolsPanel({
    required this.onClose,
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    super.key,
  });

  final VoidCallback onClose;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;

  @override
  State<QuickToolsPanel> createState() => _QuickToolsPanelState();
}

class _QuickToolsPanelState extends State<QuickToolsPanel> {
  int _selectedTab = 0;
  double _arabFontSize = 22;
  double _translationFontSize = 14;

  static const _tabs = ['Bait', 'Hadi', 'Kategori', 'Kitab'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark scrim — tapping closes the panel
        GestureDetector(
          onTap: widget.onClose,
          child: const ColoredBox(
            color: Color(0x80000000),
            child: SizedBox.expand(),
          ),
        ),
        // Panel — absorbs taps so they don't reach the scrim
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                      child: Row(
                        children: [
                          // Close button
                          GestureDetector(
                            onTap: widget.onClose,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F5EE),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: Color(0xFF777777),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Quick Tools',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111111),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8DF)),
                    // Tab chips
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_tabs.length, (i) {
                            final selected = _selectedTab == i;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedTab = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  height: 30,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF111111)
                                        : const Color(0xFFF0F5EE),
                                    borderRadius: BorderRadius.circular(100),
                                    border: selected
                                        ? null
                                        : Border.all(
                                            color: const Color(0xFFE2E8DF),
                                            width: 1.5,
                                          ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _tabs[i],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFF777777),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _selectedTab == 0
                          ? _BaitTabContent(
                              showArabic: widget.showArabic,
                              showTransliteration: widget.showTransliteration,
                              showTranslation: widget.showTranslation,
                              arabFontSize: _arabFontSize,
                              translationFontSize: _translationFontSize,
                              onArabFontSizeChanged: (v) =>
                                  setState(() => _arabFontSize = v),
                              onTranslationFontSizeChanged: (v) =>
                                  setState(() => _translationFontSize = v),
                            )
                          : Center(
                              child: Text(
                                '${_tabs[_selectedTab]} — coming soon',
                                style: const TextStyle(
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BaitTabContent extends StatelessWidget {
  const _BaitTabContent({
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.arabFontSize,
    required this.translationFontSize,
    required this.onArabFontSizeChanged,
    required this.onTranslationFontSizeChanged,
  });

  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final double arabFontSize;
  final double translationFontSize;
  final ValueChanged<double> onArabFontSizeChanged;
  final ValueChanged<double> onTranslationFontSizeChanged;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MuhudBloc>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        const SizedBox(height: 16),
        const Text(
          'Konten',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111111),
            letterSpacing: -0.2,
          ),
        ),
        _ToggleRow(
          label: 'Arab',
          subtitle: 'Tampilkan teks Arab',
          value: showArabic,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleArabic()),
        ),
        _ToggleRow(
          label: 'Transliterasi',
          subtitle: 'Tampilkan latin',
          value: showTransliteration,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleTransliteration()),
        ),
        _ToggleRow(
          label: 'Terjemahan',
          badge: 'ID',
          value: showTranslation,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleTranslation()),
        ),
        const SizedBox(height: 16),
        const Text(
          'Pengaturan Font',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111111),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        // Font Arab row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Font Arab',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111111),
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Scheherazade New',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFFAAAAAA),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8DF)),
        // Arab font size slider
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ukuran Font Arab',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111111),
                    ),
                  ),
                  Text(
                    arabFontSize.round().toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF111111),
                  thumbColor: const Color(0xFFCAFF00),
                  inactiveTrackColor: const Color(0xFFE8F0E6),
                  overlayColor:
                      const Color(0xFFCAFF00).withValues(alpha: 0.20),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                  ),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: arabFontSize,
                  min: 16,
                  max: 36,
                  divisions: 20,
                  onChanged: onArabFontSizeChanged,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8DF)),
        // Translation font size slider
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ukuran Font Terjemahan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111111),
                    ),
                  ),
                  Text(
                    translationFontSize.round().toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF111111),
                  thumbColor: const Color(0xFFCAFF00),
                  inactiveTrackColor: const Color(0xFFE8F0E6),
                  overlayColor:
                      const Color(0xFFCAFF00).withValues(alpha: 0.20),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                  ),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: translationFontSize,
                  min: 10,
                  max: 22,
                  divisions: 12,
                  onChanged: onTranslationFontSizeChanged,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.badge,
  });

  final String label;
  final String? subtitle;
  final String? badge;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8DF))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111111),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCAFF00),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111111),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF111111),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD0D8CE),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
