import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nephro_care/core/constants/nc_app_icons.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';

/// Controller to synchronize multiple animated displays
class MetricAnimationController extends ChangeNotifier {
  int _currentIndex = 0;
  Timer? _timer;
  int _metricsCount = 0;

  int get currentIndex => _currentIndex;

  void start(int metricsCount,
      {Duration duration = const Duration(seconds: 5)}) {
    _metricsCount = metricsCount;
    if (_metricsCount == 0) return;

    _timer?.cancel();
    _timer = Timer.periodic(duration, (timer) {
      _currentIndex = (_currentIndex + 1) % _metricsCount;
      notifyListeners();
    });
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Widget that displays timestamp and value synchronized
class NCHealthMetricAnimatedDisplay extends StatefulWidget {
  const NCHealthMetricAnimatedDisplay({
    super.key,
    required this.fluidValue,
    required this.fluidUnit,
    required this.fluidTime,
    required this.urineValue,
    required this.urineUnit,
    required this.urineTime,
    required this.bpValue,
    required this.bpUnit,
    required this.bpTime,
    required this.weightValue,
    required this.weightUnit,
    required this.weightTime,
    required this.textStyle,
  });

  final String? fluidValue;
  final String? fluidUnit;
  final DateTime? fluidTime;
  final String? urineValue;
  final String? urineUnit;
  final DateTime? urineTime;
  final String? bpValue;
  final String? bpUnit;
  final DateTime? bpTime;
  final String? weightValue;
  final String? weightUnit;
  final DateTime? weightTime;
  final TextStyle textStyle;

  @override
  State<NCHealthMetricAnimatedDisplay> createState() =>
      _NCHealthMetricAnimatedDisplayState();
}

class _NCHealthMetricAnimatedDisplayState
    extends State<NCHealthMetricAnimatedDisplay> {
  late final MetricAnimationController _controller;
  List<MetricData> _metrics = [];

  @override
  void initState() {
    super.initState();
    _controller = MetricAnimationController();
    _buildMetricsList();
    _controller.start(_metrics.length);
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void didUpdateWidget(NCHealthMetricAnimatedDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldMetricsLength = _metrics.length;
    _buildMetricsList();

    if (_metrics.length != oldMetricsLength) {
      _controller.start(_metrics.length);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _buildMetricsList() {
    _metrics = [];

    if (_isValidValue(widget.fluidValue)) {
      _metrics.add(MetricData(
        icon: NCIcons.waterGlass,
        value: widget.fluidValue!,
        unit: widget.fluidUnit ?? 'ml',
        timestamp: widget.fluidTime,
      ));
    }

    if (_isValidValue(widget.urineValue)) {
      _metrics.add(MetricData(
        icon: NCIcons.toilet,
        value: widget.urineValue!,
        unit: widget.urineUnit ?? 'ml',
        timestamp: widget.urineTime,
      ));
    }

    if (_isValidValue(widget.bpValue) &&
        widget.bpValue != '0/0' &&
        widget.bpValue != '--/--') {
      _metrics.add(MetricData(
        icon: NCIcons.heartBeat,
        value: widget.bpValue!,
        unit: widget.bpUnit ?? 'mmHg',
        timestamp: widget.bpTime,
      ));
    }

    if (_isValidValue(widget.weightValue)) {
      _metrics.add(MetricData(
        icon: NCIcons.weighingScale,
        value: widget.weightValue!,
        unit: widget.weightUnit ?? 'kg',
        timestamp: widget.weightTime,
      ));
    }
  }

  bool _isValidValue(String? value) {
    return value != null && value != '--' && value != '0';
  }

  @override
  Widget build(BuildContext context) {
    if (_metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentMetric = _metrics[_controller.currentIndex % _metrics.length];
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated timestamp
        _AnimatedTimestamp(
          timestamp: currentMetric.timestamp,
          textStyle: widget.textStyle,
          animationKey: 'timestamp_${_controller.currentIndex}',
        ),
        hGap4,
        Text(
          '•',
          textAlign: TextAlign.center,
          style: widget.textStyle.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        hGap4,
        _AnimatedMetricValue(
          metric: currentMetric,
          textStyle: widget.textStyle,
          colorScheme: theme.colorScheme,
          animationKey: 'metric_${_controller.currentIndex}',
        ),
      ],
    );
  }
}

/// Internal widget for animated timestamp
class _AnimatedTimestamp extends StatelessWidget {
  const _AnimatedTimestamp({
    required this.timestamp,
    required this.textStyle,
    required this.animationKey,
  });

  final DateTime? timestamp;
  final TextStyle textStyle;
  final String animationKey;

  @override
  Widget build(BuildContext context) {
    if (timestamp == null) {
      return const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Container(
        key: ValueKey(animationKey),
        child: UIUtils.createRichTextTimestamp(
          timestamp: timestamp,
          timeStyle: textStyle.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          meridiemStyle: textStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: (textStyle.fontSize ?? 12) * 0.85,
            height: 1.2,
          ),
          isMeridiemUpperCase: false,
        ),
      ),
    );
  }
}

/// Internal widget for animated metric value
class _AnimatedMetricValue extends StatelessWidget {
  const _AnimatedMetricValue({
    required this.metric,
    required this.textStyle,
    required this.colorScheme,
    required this.animationKey,
  });

  final MetricData metric;
  final TextStyle textStyle;
  final ColorScheme colorScheme;
  final String animationKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Row(
        key: ValueKey(animationKey),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          NCIcon(
            metric.icon,
            size: 14,
            color: colorScheme.primary,
          ),
          hGap4,
          UIUtils.createRichTextValueWithUnit(
            value: metric.value,
            unit: metric.unit,
            valueStyle: textStyle.copyWith(
              fontWeight: FontWeight.w800,
              height: 0.9,
            ),
            unitStyle: textStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: (textStyle.fontSize ?? 12) * 0.85,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricData {
  final String icon;
  final String value;
  final String unit;
  final DateTime? timestamp;

  MetricData({
    required this.icon,
    required this.value,
    required this.unit,
    this.timestamp,
  });
}
