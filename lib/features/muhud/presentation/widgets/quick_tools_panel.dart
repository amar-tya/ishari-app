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
                      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                      child: Row(
                        children: [
                          const Text(
                            'Quick Tools',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C1B1F),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF79747E),
                            ),
                            onPressed: widget.onClose,
                          ),
                        ],
                      ),
                    ),
                    // Tab chips
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_tabs.length, (i) {
                            final selected = _selectedTab == i;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTab = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF51C878)
                                        : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: selected
                                        ? null
                                        : Border.all(
                                            color: const Color(0xFFE0E0E0),
                                          ),
                                  ),
                                  child: Text(
                                    _tabs[i],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFF1C1B1F),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE8EAE9)),
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
                                  color: Color(0xFF79747E),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 12),
        const Text(
          'KONTEN',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF79747E),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        _ToggleRow(
          label: 'Arab',
          value: showArabic,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleArabic()),
        ),
        _ToggleRow(
          label: 'Transliterasi',
          value: showTransliteration,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleTransliteration()),
        ),
        _ToggleRow(
          label: 'Terjemahan',
          value: showTranslation,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleTranslation()),
        ),
        const SizedBox(height: 20),
        const Divider(height: 1, color: Color(0xFFE8EAE9)),
        const SizedBox(height: 20),
        const Text(
          'PENGATURAN FONT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF79747E),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Font Arab',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1B1F),
              ),
            ),
            Row(
              children: [
                Text(
                  'scheherazadeNew',
                  style: TextStyle(fontSize: 13, color: Color(0xFF51C878)),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF79747E),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ukuran Arab',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1B1F),
              ),
            ),
            Text(
              arabFontSize.round().toString(),
              style: const TextStyle(fontSize: 13, color: Color(0xFF51C878)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF51C878),
            thumbColor: const Color(0xFF51C878),
            inactiveTrackColor: const Color(0xFFE0E0E0),
            overlayColor: const Color(0xFF51C878).withValues(alpha: 0.12),
          ),
          child: Slider(
            value: arabFontSize,
            min: 16,
            max: 36,
            divisions: 20,
            onChanged: onArabFontSizeChanged,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ukuran Terjemahan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1B1F),
              ),
            ),
            Text(
              translationFontSize.round().toString(),
              style: const TextStyle(fontSize: 13, color: Color(0xFF51C878)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF51C878),
            thumbColor: const Color(0xFF51C878),
            inactiveTrackColor: const Color(0xFFE0E0E0),
            overlayColor: const Color(0xFF51C878).withValues(alpha: 0.12),
          ),
          child: Slider(
            value: translationFontSize,
            min: 10,
            max: 22,
            divisions: 12,
            onChanged: onTranslationFontSizeChanged,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1B1F),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF51C878),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
