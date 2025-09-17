import 'package:flutter/material.dart';

enum FemaleBackBodyParts {
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

extension FemaleBackBodyPartsExtension on FemaleBackBodyParts {
  String get label {
    switch (this) {
      case FemaleBackBodyParts.head:
        return "Head (Back)";
      case FemaleBackBodyParts.neck:
        return "Neck (Back)";
      case FemaleBackBodyParts.leftUpperArm:
        return "Left Upper Arm (Back)";
      case FemaleBackBodyParts.leftForeArm:
        return "Left Forearm (Back)";
      case FemaleBackBodyParts.leftHand:
        return "Left Hand (Back)";
      case FemaleBackBodyParts.rightUpperArm:
        return "Right Upper Arm (Back)";
      case FemaleBackBodyParts.rightForeArm:
        return "Right Forearm (Back)";
      case FemaleBackBodyParts.rightHand:
        return "Right Hand (Back)";
      case FemaleBackBodyParts.chest:
        return "Chest (Back)";
      case FemaleBackBodyParts.leftThigh:
        return "Left Thigh (Back)";
      case FemaleBackBodyParts.rightThigh:
        return "Right Thigh (Back)";
      case FemaleBackBodyParts.leftKnee:
        return "Left Knee (Back)";
      case FemaleBackBodyParts.rightKnee:
        return "Right Knee (Back)";
      case FemaleBackBodyParts.leftShin:
        return "Left Shin (Back)";
      case FemaleBackBodyParts.rightShin:
        return "Right Shin (Back)";
      case FemaleBackBodyParts.leftFoot:
        return "Left Foot (Back)";
      case FemaleBackBodyParts.rightFoot:
        return "Right Foot (Back)";
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

class BackBodyFemale extends StatefulWidget {
  Set<String>? selectedBodyParts; // Changed from String? to Set<String>?
  final ValueChanged<String>? onBodyPartSelected;
  final ValueChanged<Set<String>>? onSelectedPartsChanged; // Added callback for selected parts

  BackBodyFemale({
    super.key,
    this.selectedBodyParts,
    this.onBodyPartSelected,
    this.onSelectedPartsChanged,
  });

  @override
  State<StatefulWidget> createState() => _BackBodyFemaleState();
}

class _BackBodyFemaleState extends State<BackBodyFemale> {
  late Set<String> _selectedBodyParts;

  @override
  void initState() {
    super.initState();
    _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
  }

  @override
  void didUpdateWidget(BackBodyFemale oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected parts if the widget's selectedBodyParts changed
    if (widget.selectedBodyParts != oldWidget.selectedBodyParts) {
      setState(() {
        _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
      });
    }
  }

  static const Map<FemaleBackBodyParts, BodyPartPosition> _bodyPartPositions = {
    FemaleBackBodyParts.head: BodyPartPosition(
      topPercent: 0.05,
      leftPercent: 0.42,
      widthPercent: 0.132,
      heightPercent: 0.077,
    ),
    FemaleBackBodyParts.neck: BodyPartPosition(
      topPercent: 0.16,
      leftPercent: 0.42,
      widthPercent: 0.132,
      heightPercent: 0.046,
    ),
    FemaleBackBodyParts.chest: BodyPartPosition(
      topPercent: 0.21,
      leftPercent: 0.363,
      widthPercent: 0.25,
      heightPercent: 0.262,
    ),
    FemaleBackBodyParts.leftUpperArm: BodyPartPosition(
      topPercent: 0.24,
      leftPercent: 0.29,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.leftForeArm: BodyPartPosition(
      topPercent: 0.36,
      leftPercent: 0.26,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.leftHand: BodyPartPosition(
      topPercent: 0.5,
      leftPercent: 0.26,
      widthPercent: 0.079,
      heightPercent: 0.062,
    ),
    FemaleBackBodyParts.rightUpperArm: BodyPartPosition(
      topPercent: 0.24,
      leftPercent: 0.61,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.rightForeArm: BodyPartPosition(
      topPercent: 0.36,
      leftPercent: 0.63,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.rightHand: BodyPartPosition(
      topPercent: 0.5,
      leftPercent: 0.64,
      widthPercent: 0.079,
      heightPercent: 0.062,
    ),
    FemaleBackBodyParts.leftThigh: BodyPartPosition(
      topPercent: 0.538,
      leftPercent: 0.382,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.rightThigh: BodyPartPosition(
      topPercent: 0.538,
      leftPercent: 0.513,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.leftKnee: BodyPartPosition(
      topPercent: 0.68,
      leftPercent: 0.379,
      widthPercent: 0.079,
      heightPercent: 0.046,
    ),
    FemaleBackBodyParts.rightKnee: BodyPartPosition(
      topPercent: 0.68,
      leftPercent: 0.52,
      widthPercent: 0.079,
      heightPercent: 0.046,
    ),
    FemaleBackBodyParts.leftShin: BodyPartPosition(
      topPercent: 0.73,
      leftPercent: 0.382,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.rightShin: BodyPartPosition(
      topPercent: 0.73,
      leftPercent: 0.511,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleBackBodyParts.leftFoot: BodyPartPosition(
      topPercent: 0.89,
      leftPercent: 0.379,
      widthPercent: 0.079,
      heightPercent: 0.046,
    ),
    FemaleBackBodyParts.rightFoot: BodyPartPosition(
      topPercent: 0.89,
      leftPercent: 0.511,
      widthPercent: 0.079,
      heightPercent: 0.046,
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

  Widget _buildBodyPart(FemaleBackBodyParts part, Size containerSize) {
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

        // Maintain aspect ratio (380/650 from original dimensions)
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
                  'assets/bodies/female_back.png',
                  fit: BoxFit.contain,
                ),
              ),

              // Body parts
              ...FemaleBackBodyParts.values.map(
                    (part) => _buildBodyPart(part, containerSize),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Alternative approach using AspectRatio and Align widgets
class BackBodyFemaleAlternative extends StatefulWidget {
  Set<String>? selectedBodyParts; // Changed from String? to Set<String>?
  final ValueChanged<String>? onBodyPartSelected;
  final ValueChanged<Set<String>>? onSelectedPartsChanged; // Added callback for selected parts

  BackBodyFemaleAlternative({
    super.key,
    this.selectedBodyParts,
    this.onBodyPartSelected,
    this.onSelectedPartsChanged,
  });

  @override
  State<StatefulWidget> createState() => _BackBodyFemaleAlternativeState();
}

class _BackBodyFemaleAlternativeState extends State<BackBodyFemaleAlternative> {
  late Set<String> _selectedBodyParts;

  @override
  void initState() {
    super.initState();
    // Initialize with provided selected parts or empty set
    _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
  }

  @override
  void didUpdateWidget(BackBodyFemaleAlternative oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected parts if the widget's selectedBodyParts changed
    if (widget.selectedBodyParts != oldWidget.selectedBodyParts) {
      setState(() {
        _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
      });
    }
  }

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

  Widget _buildAlignedBodyPart({
    required FemaleBackBodyParts part,
    required AlignmentGeometry alignment,
    required double widthFactor,
    required double heightFactor,
  }) {
    final isSelected = _selectedBodyParts.contains(part.label);

    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: Container(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 380 / 650,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bodies/female_back.png',
              fit: BoxFit.contain,
            ),
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.head,
            alignment: const Alignment(0.02, -0.83),
            widthFactor: 0.13,
            heightFactor: 0.077,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.neck,
            alignment: const Alignment(0.02, -0.7),
            widthFactor: 0.13,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.chest,
            alignment: const Alignment(0.0, -0.4),
            widthFactor: 0.29,
            heightFactor: 0.26,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.leftUpperArm,
            alignment: const Alignment(-0.52, -0.5),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.rightUpperArm,
            alignment: const Alignment(0.52, -0.5),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.leftForeArm,
            alignment: const Alignment(-0.67, -0.2),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.rightForeArm,
            alignment: const Alignment(0.67, -0.2),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.leftHand,
            alignment: const Alignment(-0.84, 0.05),
            widthFactor: 0.08,
            heightFactor: 0.062,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.rightHand,
            alignment: const Alignment(0.84, 0.05),
            widthFactor: 0.08,
            heightFactor: 0.062,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.leftThigh,
            alignment: const Alignment(-0.2, 0.25),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.rightThigh,
            alignment: const Alignment(0.2, 0.25),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.leftKnee,
            alignment: const Alignment(-0.18, 0.45),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.rightKnee,
            alignment: const Alignment(0.18, 0.45),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.leftShin,
            alignment: const Alignment(-0.18, 0.7),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.rightShin,
            alignment: const Alignment(0.18, 0.7),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.leftFoot,
            alignment: const Alignment(-0.18, 0.9),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleBackBodyParts.rightFoot,
            alignment: const Alignment(0.18, 0.9),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),
        ],
      ),
    );
  }
}