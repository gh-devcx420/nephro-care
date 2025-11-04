import 'package:nephro_care/features/trackers/blood_pressure/bp_model.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_utils.dart';
import 'package:nephro_care/features/trackers/dialysis/dialysis_model.dart';

/// ViewModel that combines DialysisModel with its referenced BP data
/// This is what the UI displays
class DialysisSessionViewModel {
  final DialysisModel session;

  // The actual BP objects fetched using the IDs
  final BPTrackerModel? preDialysisBPResting;
  final BPTrackerModel? preDialysisBPStanding;
  final BPTrackerModel? postDialysisBPResting;
  final BPTrackerModel? postDialysisBPStanding;

  // 🔒 COMMENTED OUT: Weight/Urine (implement later)
  // final WeightModel? preWeight;
  // final WeightModel? postWeight;
  // final UrineModel? ultraFiltrationTarget;

  // ✅ BP Utils instance for calculations
  final _bpUtils = BloodPressureUtils();

  DialysisSessionViewModel({
    required this.session,
    this.preDialysisBPResting,
    this.preDialysisBPStanding,
    this.postDialysisBPResting,
    this.postDialysisBPStanding,
  });

  /// Check if all referenced BP data has been loaded
  bool get isFullyLoaded {
    // Check if all expected references have their data loaded
    if (session.preDialysisBPRestingId != null &&
        preDialysisBPResting == null) {
      return false;
    }
    if (session.preDialysisBPStandingId != null &&
        preDialysisBPStanding == null) {
      return false;
    }
    if (session.postDialysisBPRestingId != null &&
        postDialysisBPResting == null) {
      return false;
    }
    if (session.postDialysisBPStandingId != null &&
        postDialysisBPStanding == null) {
      return false;
    }

    return true;
  }

  /// Get loading progress (0.0 to 1.0)
  double get loadingProgress {
    int totalExpected = 0;
    int totalLoaded = 0;

    if (session.preDialysisBPRestingId != null) {
      totalExpected++;
      if (preDialysisBPResting != null) totalLoaded++;
    }
    if (session.preDialysisBPStandingId != null) {
      totalExpected++;
      if (preDialysisBPStanding != null) totalLoaded++;
    }
    if (session.postDialysisBPRestingId != null) {
      totalExpected++;
      if (postDialysisBPResting != null) totalLoaded++;
    }
    if (session.postDialysisBPStandingId != null) {
      totalExpected++;
      if (postDialysisBPStanding != null) totalLoaded++;
    }

    if (totalExpected == 0) return 1.0;
    return totalLoaded / totalExpected;
  }

  // ============ BP Calculations (Delegated to Utils) ============

  /// Check for orthostatic hypotension (pre-dialysis)
  /// ✅ Delegates to BloodPressureUtils for consistency
  bool get hasPreDialysisOrthostaticHypotension {
    return _bpUtils.hasOrthostaticHypotension(
      restingBP: preDialysisBPResting,
      standingBP: preDialysisBPStanding,
    );
  }

  /// Check for orthostatic hypotension (post-dialysis)
  /// ✅ Delegates to BloodPressureUtils for consistency
  bool get hasPostDialysisOrthostaticHypotension {
    return _bpUtils.hasOrthostaticHypotension(
      restingBP: postDialysisBPResting,
      standingBP: postDialysisBPStanding,
    );
  }

  /// Check if there was BP drop during dialysis (resting)
  /// ✅ Uses utils' getBPDropCategory logic
  bool get hadBPDrop {
    final category = _bpUtils.getBPDropCategory(
      beforeBP: preDialysisBPResting,
      afterBP: postDialysisBPResting,
    );

    // Consider it a drop if category is not 'N/A', 'Minimal', or 'BP Increased'
    return category != 'N/A' &&
        category != 'Minimal' &&
        category != 'BP Increased';
  }

  /// Get BP drop severity category during dialysis
  String get bpDropCategory {
    return _bpUtils.getBPDropCategory(
      beforeBP: preDialysisBPResting,
      afterBP: postDialysisBPResting,
    );
  }

  /// Calculate systolic BP change during dialysis
  /// ✅ Delegates to utils
  int? get systolicChange {
    return _bpUtils.calculateSystolicDrop(
      beforeBP: preDialysisBPResting,
      afterBP: postDialysisBPResting,
    );
  }

  /// Calculate diastolic BP change during dialysis
  /// ✅ Delegates to utils
  int? get diastolicChange {
    return _bpUtils.calculateDiastolicDrop(
      beforeBP: preDialysisBPResting,
      afterBP: postDialysisBPResting,
    );
  }

  /// Get systolic drop for pre-dialysis orthostatic check
  int? get preDialysisSystolicDrop {
    return _bpUtils.calculateSystolicDrop(
      beforeBP: preDialysisBPResting,
      afterBP: preDialysisBPStanding,
    );
  }

  /// Get diastolic drop for pre-dialysis orthostatic check
  int? get preDialysisDiastolicDrop {
    return _bpUtils.calculateDiastolicDrop(
      beforeBP: preDialysisBPResting,
      afterBP: preDialysisBPStanding,
    );
  }

  /// Get systolic drop for post-dialysis orthostatic check
  int? get postDialysisSystolicDrop {
    return _bpUtils.calculateSystolicDrop(
      beforeBP: postDialysisBPResting,
      afterBP: postDialysisBPStanding,
    );
  }

  /// Get diastolic drop for post-dialysis orthostatic check
  int? get postDialysisDiastolicDrop {
    return _bpUtils.calculateDiastolicDrop(
      beforeBP: postDialysisBPResting,
      afterBP: postDialysisBPStanding,
    );
  }

  DialysisSessionViewModel copyWith({
    DialysisModel? session,
    BPTrackerModel? preDialysisBPResting,
    BPTrackerModel? preDialysisBPStanding,
    BPTrackerModel? postDialysisBPResting,
    BPTrackerModel? postDialysisBPStanding,
  }) {
    return DialysisSessionViewModel(
      session: session ?? this.session,
      preDialysisBPResting: preDialysisBPResting ?? this.preDialysisBPResting,
      preDialysisBPStanding:
          preDialysisBPStanding ?? this.preDialysisBPStanding,
      postDialysisBPResting:
          postDialysisBPResting ?? this.postDialysisBPResting,
      postDialysisBPStanding:
          postDialysisBPStanding ?? this.postDialysisBPStanding,
    );
  }

  @override
  String toString() {
    return 'DialysisSessionViewModel('
        'session: ${session.id}, '
        'loaded: $isFullyLoaded, '
        'progress: ${(loadingProgress * 100).toStringAsFixed(0)}%'
        ')';
  }
}
