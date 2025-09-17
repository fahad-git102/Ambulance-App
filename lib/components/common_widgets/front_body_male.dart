import 'package:flutter/material.dart';

enum MaleFrontBodyParts {
  head,
  neck,
  leftUpperArm,
  leftForeArm,
  leftHand,
  rightUpperArm,
  rightForeArm,
  rightHand,
  chest,
  leftThigh,
  rightThigh,
  leftKnee,
  rightKnee,
  leftShin,
  rightShin,
  leftFoot,
  rightFoot,
}

extension MaleFrontBodyPartsExtension on MaleFrontBodyParts {
  String get label {
    switch (this) {
      case MaleFrontBodyParts.head:
        return "Head";
      case MaleFrontBodyParts.neck:
        return "Neck";
      case MaleFrontBodyParts.leftUpperArm:
        return "Left Upper Arm";
      case MaleFrontBodyParts.leftForeArm:
        return "Left Forearm";
      case MaleFrontBodyParts.leftHand:
        return "Left Hand";
      case MaleFrontBodyParts.rightUpperArm:
        return "Right Upper Arm";
      case MaleFrontBodyParts.rightForeArm:
        return "Right Forearm";
      case MaleFrontBodyParts.rightHand:
        return "Right Hand";
      case MaleFrontBodyParts.chest:
        return "Chest";
      case MaleFrontBodyParts.leftThigh:
        return "Left Thigh";
      case MaleFrontBodyParts.rightThigh:
        return "Right Thigh";
      case MaleFrontBodyParts.leftKnee:
        return "Left Knee";
      case MaleFrontBodyParts.rightKnee:
        return "Right Knee";
      case MaleFrontBodyParts.leftShin:
        return "Left Shin";
      case MaleFrontBodyParts.rightShin:
        return "Right Shin";
      case MaleFrontBodyParts.leftFoot:
        return "Left Foot";
      case MaleFrontBodyParts.rightFoot:
        return "Right Foot";
    }
  }
}

class BodyPartPosition {
  final double topPercent;
  final double leftPercent;
  final double widthPercent;
  final double heightPercent;

  const BodyPartPosition({
    required this.topPercent,
    required this.leftPercent,
    required this.widthPercent,
    required this.heightPercent,
  });
}

class FrontBodyMale extends StatefulWidget {
  Set<String>? selectedBodyParts; // Changed from String? to Set<String>?
  final ValueChanged<String>? onBodyPartSelected;
  final ValueChanged<Set<String>>? onSelectedPartsChanged; // Added callback for selected parts

  FrontBodyMale({
    super.key,
    this.selectedBodyParts,
    this.onBodyPartSelected,
    this.onSelectedPartsChanged,
  });

  @override
  State<StatefulWidget> createState() => _FrontBodyMaleState();
}

class _FrontBodyMaleState extends State<FrontBodyMale> {
  late Set<String> _selectedBodyParts;

  @override
  void initState() {
    super.initState();
    // Initialize with provided selected parts or empty set
    _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
  }

  @override
  void didUpdateWidget(FrontBodyMale oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected parts if the widget's selectedBodyParts changed
    if (widget.selectedBodyParts != oldWidget.selectedBodyParts) {
      setState(() {
        _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
      });
    }
  }

  // Define body part positions as percentages of the container
  static const Map<MaleFrontBodyParts, BodyPartPosition> _bodyPartPositions = {
    MaleFrontBodyParts.head: BodyPartPosition(
      topPercent: 0.03,
      leftPercent: 0.39,
      widthPercent: 0.16,
      heightPercent: 0.08,
    ),
    MaleFrontBodyParts.neck: BodyPartPosition(
      topPercent: 0.14,
      leftPercent: 0.39,
      widthPercent: 0.16,
      heightPercent: 0.05,
    ),
    MaleFrontBodyParts.chest: BodyPartPosition(
      topPercent: 0.19,
      leftPercent: 0.305,
      widthPercent: 0.32,
      heightPercent: 0.26,
    ),
    MaleFrontBodyParts.leftUpperArm: BodyPartPosition(
      topPercent: 0.22,
      leftPercent: 0.22,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.leftForeArm: BodyPartPosition(
      topPercent: 0.34,
      leftPercent: 0.13,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.leftHand: BodyPartPosition(
      topPercent: 0.48,
      leftPercent: 0.04,
      widthPercent: 0.08,
      heightPercent: 0.06,
    ),
    MaleFrontBodyParts.rightUpperArm: BodyPartPosition(
      topPercent: 0.22,
      leftPercent: 0.64,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.rightForeArm: BodyPartPosition(
      topPercent: 0.34,
      leftPercent: 0.73,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.rightHand: BodyPartPosition(
      topPercent: 0.48,
      leftPercent: 0.81,
      widthPercent: 0.08,
      heightPercent: 0.06,
    ),
    MaleFrontBodyParts.leftThigh: BodyPartPosition(
      topPercent: 0.54,
      leftPercent: 0.34,
      widthPercent: 0.1,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.rightThigh: BodyPartPosition(
      topPercent: 0.54,
      leftPercent: 0.5,
      widthPercent: 0.1,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.leftKnee: BodyPartPosition(
      topPercent: 0.69,
      leftPercent: 0.36,
      widthPercent: 0.08,
      heightPercent: 0.05,
    ),
    MaleFrontBodyParts.rightKnee: BodyPartPosition(
      topPercent: 0.69,
      leftPercent: 0.5,
      widthPercent: 0.08,
      heightPercent: 0.05,
    ),
    MaleFrontBodyParts.leftShin: BodyPartPosition(
      topPercent: 0.75,
      leftPercent: 0.37,
      widthPercent: 0.06,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.rightShin: BodyPartPosition(
      topPercent: 0.75,
      leftPercent: 0.5,
      widthPercent: 0.06,
      heightPercent: 0.14,
    ),
    MaleFrontBodyParts.leftFoot: BodyPartPosition(
      topPercent: 0.91,
      leftPercent: 0.355,
      widthPercent: 0.08,
      heightPercent: 0.05,
    ),
    MaleFrontBodyParts.rightFoot: BodyPartPosition(
      topPercent: 0.91,
      leftPercent: 0.48,
      widthPercent: 0.08,
      heightPercent: 0.05,
    ),
  };

  void _selectPart(String partName) {
    setState(() {
      // Add to selected parts set (won't add duplicates)
      _selectedBodyParts.add(partName);
    });

    // Call the original callback for opening dialog
    if (widget.onBodyPartSelected != null) {
      widget.onBodyPartSelected!(partName);
    }

    // Call the new callback to notify about selected parts change
    if (widget.onSelectedPartsChanged != null) {
      widget.onSelectedPartsChanged!(_selectedBodyParts);
    }
  }

  // Method to remove a body part from selection (useful for external control)
  void removeBodyPart(String partName) {
    setState(() {
      _selectedBodyParts.remove(partName);
    });

    if (widget.onSelectedPartsChanged != null) {
      widget.onSelectedPartsChanged!(_selectedBodyParts);
    }
  }

  // Method to clear all selections
  void clearSelection() {
    setState(() {
      _selectedBodyParts.clear();
    });

    if (widget.onSelectedPartsChanged != null) {
      widget.onSelectedPartsChanged!(_selectedBodyParts);
    }
  }

  Widget _buildBodyPart(MaleFrontBodyParts part, Size containerSize) {
    final position = _bodyPartPositions[part]!;
    final isSelected = _selectedBodyParts.contains(part.label);

    return Positioned(
      top: containerSize.height * position.topPercent,
      left: containerSize.width * position.leftPercent,
      child: Container(
        width: containerSize.width * position.widthPercent,
        height: containerSize.height * position.heightPercent,
        decoration: isSelected
            ? BoxDecoration(
          color: Colors.green.withAlpha(150),
          borderRadius: BorderRadius.circular(4),
        )
            : null,
        child: InkWell(
          onTap: () => _selectPart(part.label),
          borderRadius: BorderRadius.circular(4),
          child: Container(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // Adjust container size based on screen size
        double containerWidth = screenWidth * 0.8;
        double containerHeight = screenHeight * 0.8;

        // Maintain aspect ratio
        if (containerWidth / containerHeight > 380 / 650) {
          containerWidth = containerHeight * (380 / 650);
        } else {
          containerHeight = containerWidth * (650 / 380);
        }

        // Ensure minimum and maximum sizes
        containerWidth = containerWidth.clamp(300.0, 450.0);
        containerHeight = containerHeight.clamp(500.0, 750.0);

        final containerSize = Size(containerWidth, containerHeight);

        return SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/bodies/front_view.png',
                  fit: BoxFit.contain,
                ),
              ),

              // Body parts
              ...MaleFrontBodyParts.values.map(
                    (part) => _buildBodyPart(part, containerSize),
              ),
            ],
          ),
        );
      },
    );
  }
}