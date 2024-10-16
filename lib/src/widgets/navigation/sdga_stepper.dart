import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sdga_design_system/src/src.dart';
import 'package:sdga_icons/sdga_icons.dart';

part 'sdga_stepper_renderer.dart';
part 'sdga_stepper_step.dart';

const Duration _kCurrentStepDuration = Duration(milliseconds: 400);
const Duration _kSelectedStepDuration = Duration(milliseconds: 200);

/// Defines the style of the stepper indicator.
enum SDGAStepperStyle {
  /// Displays a circular indicator for each step with the step index inside it.
  circle,

  /// Displays a dot indicator for each step.
  dot
}

/// Represents a single step in the [SDGAStepper].
class SDGAStep {
  /// Creates an [SDGAStep] with the specified parameters.
  SDGAStep({
    // required this.value,
    this.title,
    this.description,
    // this.state = SDGAStepperState.upcoming,
  });

  // /// The value associated with this step.
  // final T value;

  /// The title of this step.
  final String? title;

  /// The description of this step.
  final String? description;

  // /// The current state of this step.
  // final SDGAStepperState state;
}

/// A widget that displays a stepper with customizable steps and styles.
///
/// The [SDGAStepper] widget provides a way to display a sequence of steps,
/// each represented by an [SDGAStep] object. The stepper can be displayed
/// horizontally or vertically, with different indicator styles (circle or dot),
/// and customizable behavior for interacting with completed and upcoming steps.
///
/// {@tool sample}
///
/// ```dart
/// SDGAStepper<int>(
///   direction: Axis.horizontal,
///   steps: [
///     SDGAStep<int>(
///       value: 1,
///       title: 'Step 1',
///       description: 'Description for Step 1',
///       state: SDGAStepperState.completed,
///     ),
///     SDGAStep<int>(
///       value: 2,
///       title: 'Step 2',
///       description: 'Description for Step 2',
///       state: SDGAStepperState.current,
///     ),
///     SDGAStep<int>(
///       value: 3,
///       title: 'Step 3',
///       description: 'Description for Step 3',
///       state: SDGAStepperState.upcoming,
///     ),
///   ],
///   style: SDGAStepperStyle.circle,
///   canPressCompletedSteps: true,
///   canPressUpcomingSteps: false,
///   currentStep: 2,
///   onStepSelected: (step) {
///     // Handle step selection
///   },
/// )
/// ```
/// {@end-tool}
class SDGAStepper extends StatefulWidget {
  /// Creates an [SDGAStepper] widget with the specified parameters.
  const SDGAStepper({
    super.key,
    this.direction = Axis.horizontal,
    required this.steps,
    this.style = SDGAStepperStyle.circle,
    this.canPressCompletedSteps = true,
    this.canPressUpcomingSteps = false,
    this.onStepSelected,
    required this.currentStepIndex,
    this.selectedStepIndex,
    this.scrollAlignment = 0.5,
    this.constraints,
    this.padding = SDGANumbers.spacingXL,
    this.enableAnimations = true,
  });

  /// The orientation of the stepper (horizontal or vertical).
  final Axis direction;

  /// A list of [SDGAStep] objects representing the steps in the stepper.
  final List<SDGAStep> steps;

  /// The visual style of the stepper indicator.
  final SDGAStepperStyle style;

  /// Determines whether completed steps can be pressed or not.
  final bool canPressCompletedSteps;

  /// Determines whether upcoming steps can be pressed or not.
  final bool canPressUpcomingSteps;

  /// A callback function that is called when a step is selected.
  ///
  /// If this is null steps will not be intractable and both
  /// [canPressCompletedSteps] and [canPressUpcomingSteps] will
  /// be ineffective.
  final ValueChanged<int>? onStepSelected;

  /// The selected step index.
  ///
  /// This property is useful for allowing users to navigate to
  /// completed or upcoming steps without changing the current
  /// step indicator.
  ///
  /// If a completed or upcoming step is the current step, the
  /// indicator style will change slightly to show that it is
  /// selected.
  final int? selectedStepIndex;

  /// The current step index.
  ///
  /// All steps before this step, will be marked as completed, and
  /// all steps after this it will be marked as upcoming.
  final int currentStepIndex;

  /// Describes where the Step should be positioned when it should be visible within
  /// the parent scrollable. If `alignment` is 0.0, the child must be positioned as
  /// close to the leading edge of the viewport as possible. If `alignment` is 1.0,
  /// the child must be positioned as close to the trailing edge of the viewport as
  /// possible. If `alignment` is 0.5, the child must be positioned as close to
  /// the center of the viewport as possible.
  final double scrollAlignment;

  /// The constraints to be applied to each step widget.
  ///
  /// If this is null the constraints will be tight for the biggest
  /// child size.
  final BoxConstraints? constraints;

  /// The padding between each step.
  final double padding;

  /// Whether to enable the animations for when the current step changes.
  final bool enableAnimations;

  @override
  State<SDGAStepper> createState() => _SDGAStepperState();
}

class _SDGAStepperState extends State<SDGAStepper>
    with TickerProviderStateMixin {
  late AnimationController _selectedStepController;
  late AnimationController _currentStepController;
  late Animation<double> _currentStep;
  int? _oldSelectedStep;

  double get _currentStepNormalized =>
      ((widget.currentStepIndex + 0.5) / widget.steps.length).clamp(0, 1);

  void _animateToCurrentStep() {
    _currentStepController.animateTo(
      _currentStepNormalized,
      duration: widget.enableAnimations ? _kCurrentStepDuration : Duration.zero,
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    _selectedStepController = AnimationController(
      vsync: this,
      value: 1,
      duration:
          widget.enableAnimations ? _kSelectedStepDuration : Duration.zero,
    );
    _currentStepController =
        AnimationController(vsync: this, value: _currentStepNormalized);
    _currentStep = Tween<double>(
      begin: 0,
      end: widget.steps.length.toDouble(),
    ).animate(_currentStepController);
    _animateToCurrentStep();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SDGAStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableAnimations != oldWidget.enableAnimations) {
      _selectedStepController.duration =
          widget.enableAnimations ? _kSelectedStepDuration : Duration.zero;
    }
    if (widget.steps.length != oldWidget.steps.length) {
      _currentStep = Tween<double>(
        begin: 0,
        end: widget.steps.length.toDouble(),
      ).animate(_currentStepController);

      _animateToCurrentStep();
    } else if (widget.currentStepIndex != oldWidget.currentStepIndex) {
      _animateToCurrentStep();
    }
    if (widget.selectedStepIndex != oldWidget.selectedStepIndex) {
      _oldSelectedStep = oldWidget.selectedStepIndex;
      _selectedStepController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _currentStepController.dispose();
    _selectedStepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Stepper(
      padding: widget.padding,
      direction: widget.direction,
      constraints: widget.constraints,
      children: List.generate(
        widget.steps.length,
        (index) {
          final bool canGoNext =
              index < widget.currentStepIndex && widget.canPressCompletedSteps;
          final bool canGoBack =
              index > widget.currentStepIndex && widget.canPressUpcomingSteps;
          final bool canGoCurrent = index == widget.currentStepIndex &&
              widget.selectedStepIndex != null;
          final bool intractable = widget.onStepSelected != null &&
              widget.selectedStepIndex != index &&
              (canGoNext || canGoBack || canGoCurrent);
          return _Step(
            key: SaltedKey(context, index),
            index: index,
            currentStepIndex: _currentStep,
            selectedValue: _selectedStepController,
            step: widget.steps[index],
            direction: widget.direction,
            isCircle: widget.style == SDGAStepperStyle.circle,
            lastStep: index == widget.steps.length - 1,
            currentIndex: widget.currentStepIndex,
            selectedIndex: widget.selectedStepIndex,
            lastSelectedIndex: _oldSelectedStep,
            scrollAlignment: widget.scrollAlignment,
            onSelected:
                intractable ? () => widget.onStepSelected?.call(index) : null,
          );
        },
      ),
    );
  }
}
