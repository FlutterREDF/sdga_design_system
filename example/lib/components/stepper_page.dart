import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class StepperPage extends BaseComponentsPage {
  const StepperPage({super.key});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends BaseComponentsPageState<StepperPage> {
  SDGAStepperStyle _style = SDGAStepperStyle.circle;
  Axis _axis = Axis.vertical;
  bool _canPressCompletedSteps = true;
  bool _canPressUpcomingSteps = false;
  bool _showTitle = true;
  bool _enabled = true;
  bool _showDescription = true;
  bool _enableAnimations = true;
  int _currentStep = 2;
  int _selectedStep = 2;

  @override
  bool get wrapWithFill => _axis == Axis.horizontal;

  @override
  Widget buildContent() {
    final Widget child = SDGAStepper(
      style: _style,
      direction: _axis,
      enableAnimations: _enableAnimations,
      canPressCompletedSteps: _canPressCompletedSteps,
      canPressUpcomingSteps: _canPressUpcomingSteps,
      currentStepIndex: _currentStep,
      selectedStepIndex: _selectedStep,
      onStepSelected: _enabled
          ? (step) {
              setState(() => _selectedStep = step);
            }
          : null,
      steps: [
        SDGAStep(
          title: _showTitle ? 'Step One' : null,
          description: _showDescription ? 'This is step description' : null,
        ),
        SDGAStep(
          title: _showTitle ? 'Step Two' : null,
          description: _showDescription ? 'This is step description' : null,
        ),
        SDGAStep(
          title: _showTitle ? 'Step Three' : null,
          description: _showDescription ? 'This is step description' : null,
        ),
        SDGAStep(
          title: _showTitle ? 'Step Four' : null,
          description: _showDescription ? 'This is step description' : null,
        ),
      ],
    );
    switch (_axis) {
      case Axis.horizontal:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: SDGANumbers.spacingLG),
          child: child,
        );
      case Axis.vertical:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: SDGANumbers.spacingLG),
          child: child,
        );
    }
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildNextStepProperty(),
      _buildPreviousStepProperty(),
      _buildDirectionProperty(),
      _buildStyleProperty(),
      _buildShowTitleProperty(),
      _buildShowDescriptionProperty(),
      _buildEnableAnimationsProperty(),
      _buildEnabledProperty(),
      if (_enabled) ...[
        _buildCompletedIntractableProperty(),
        _buildUpcomingIntractableProperty(),
      ],
    ];
  }

  Widget _buildNextStepProperty() {
    return SDGAListTile(
      title: const Text("Next Step"),
      onTap: () {
        if (_currentStep < 3) {
          setState(() {
            _currentStep++;
            _selectedStep = _currentStep;
          });
        }
      },
    );
  }

  Widget _buildPreviousStepProperty() {
    return SDGAListTile(
      title: const Text("Previous Step"),
      onTap: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep--;
            _selectedStep = _currentStep;
          });
        }
      },
    );
  }

  Widget _buildDirectionProperty() {
    return buildSelectionProperty(
      title: 'Direction',
      value: _axis.name,
      values: Axis.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _axis = item),
    );
  }

  Widget _buildStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _style.name,
      values: SDGAStepperStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _style = item),
    );
  }

  Widget _buildEnableAnimationsProperty() {
    return SDGASwitchListTile(
      value: _enableAnimations,
      title: const Text('Enable Animations'),
      onChanged: (value) => setState(() => _enableAnimations = value),
    );
  }

  Widget _buildShowTitleProperty() {
    return SDGASwitchListTile(
      value: _showTitle,
      title: const Text('Show Title'),
      onChanged: (value) => setState(() => _showTitle = value),
    );
  }

  Widget _buildShowDescriptionProperty() {
    return SDGASwitchListTile(
      value: _showDescription,
      title: const Text('Show Description'),
      onChanged: (value) => setState(() => _showDescription = value),
    );
  }

  Widget _buildEnabledProperty() {
    return SDGASwitchListTile(
      value: _enabled,
      title: const Text('Intractable'),
      onChanged: (value) => setState(() => _enabled = value),
    );
  }

  Widget _buildCompletedIntractableProperty() {
    return SDGASwitchListTile(
      value: _canPressCompletedSteps,
      title: const Text('Allow switching to completed steps?'),
      onChanged: (value) => setState(() => _canPressCompletedSteps = value),
    );
  }

  Widget _buildUpcomingIntractableProperty() {
    return SDGASwitchListTile(
      value: _canPressUpcomingSteps,
      title: const Text('Allow switching to upcoming steps?'),
      onChanged: (value) => setState(() => _canPressUpcomingSteps = value),
    );
  }
}
