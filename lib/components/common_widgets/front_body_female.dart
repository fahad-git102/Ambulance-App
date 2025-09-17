import 'package:flutter/material.dart';

enum FemaleFrontBodyParts {
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

extension FemaleFrontBodyPartsExtension on FemaleFrontBodyParts {
  String get label {
    switch (this) {
      case FemaleFrontBodyParts.head:
        return "Head";
      case FemaleFrontBodyParts.neck:
        return "Neck";
      case FemaleFrontBodyParts.leftUpperArm:
        return "Left Upper Arm";
      case FemaleFrontBodyParts.leftForeArm:
        return "Left Forearm";
      case FemaleFrontBodyParts.leftHand:
        return "Left Hand";
      case FemaleFrontBodyParts.rightUpperArm:
        return "Right Upper Arm";
      case FemaleFrontBodyParts.rightForeArm:
        return "Right Forearm";
      case FemaleFrontBodyParts.rightHand:
        return "Right Hand";
      case FemaleFrontBodyParts.chest:
        return "Chest";
      case FemaleFrontBodyParts.leftThigh:
        return "Left Thigh";
      case FemaleFrontBodyParts.rightThigh:
        return "Right Thigh";
      case FemaleFrontBodyParts.leftKnee:
        return "Left Knee";
      case FemaleFrontBodyParts.rightKnee:
        return "Right Knee";
      case FemaleFrontBodyParts.leftShin:
        return "Left Shin";
      case FemaleFrontBodyParts.rightShin:
        return "Right Shin";
      case FemaleFrontBodyParts.leftFoot:
        return "Left Foot";
      case FemaleFrontBodyParts.rightFoot:
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

class FrontBodyFemale extends StatefulWidget {
  Set<String>? selectedBodyParts; // Changed from String? to Set<String>?
  final ValueChanged<String>? onBodyPartSelected;
  final ValueChanged<Set<String>>? onSelectedPartsChanged; // Added callback for selected parts

  FrontBodyFemale({
    super.key,
    this.selectedBodyParts,
    this.onBodyPartSelected,
    this.onSelectedPartsChanged,
  });

  @override
  State<StatefulWidget> createState() => _FrontBodyFemaleState();
}

class _FrontBodyFemaleState extends State<FrontBodyFemale> {
  late Set<String> _selectedBodyParts;

  @override
  void initState() {
    super.initState();
    // Initialize with provided selected parts or empty set
    _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
  }

  @override
  void didUpdateWidget(FrontBodyFemale oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected parts if the widget's selectedBodyParts changed
    if (widget.selectedBodyParts != oldWidget.selectedBodyParts) {
      setState(() {
        _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
      });
    }
  }

  static const Map<FemaleFrontBodyParts, BodyPartPosition> _bodyPartPositions = {
    FemaleFrontBodyParts.head: BodyPartPosition(
      topPercent: 0.05,
      leftPercent: 0.42,
      widthPercent: 0.132,
      heightPercent: 0.077,
    ),
    FemaleFrontBodyParts.neck: BodyPartPosition(
      topPercent: 0.16,
      leftPercent: 0.42,
      widthPercent: 0.132,
      heightPercent: 0.046,
    ),
    FemaleFrontBodyParts.chest: BodyPartPosition(
      topPercent: 0.21,
      leftPercent: 0.363,
      widthPercent: 0.25,
      heightPercent: 0.262,
    ),
    FemaleFrontBodyParts.leftUpperArm: BodyPartPosition(
      topPercent: 0.24,
      leftPercent: 0.29,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.leftForeArm: BodyPartPosition(
      topPercent: 0.36,
      leftPercent: 0.26,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.leftHand: BodyPartPosition(
      topPercent: 0.5,
      leftPercent: 0.26,
      widthPercent: 0.079,
      heightPercent: 0.062,
    ),
    FemaleFrontBodyParts.rightUpperArm: BodyPartPosition(
      topPercent: 0.24,
      leftPercent: 0.61,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.rightForeArm: BodyPartPosition(
      topPercent: 0.36,
      leftPercent: 0.63,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.rightHand: BodyPartPosition(
      topPercent: 0.5,
      leftPercent: 0.64,
      widthPercent: 0.079,
      heightPercent: 0.062,
    ),
    FemaleFrontBodyParts.leftThigh: BodyPartPosition(
      topPercent: 0.538,
      leftPercent: 0.382,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.rightThigh: BodyPartPosition(
      topPercent: 0.538,
      leftPercent: 0.513,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.leftKnee: BodyPartPosition(
      topPercent: 0.68,
      leftPercent: 0.379,
      widthPercent: 0.079,
      heightPercent: 0.046,
    ),
    FemaleFrontBodyParts.rightKnee: BodyPartPosition(
      topPercent: 0.68,
      leftPercent: 0.52,
      widthPercent: 0.079,
      heightPercent: 0.046,
    ),
    FemaleFrontBodyParts.leftShin: BodyPartPosition(
      topPercent: 0.73,
      leftPercent: 0.382,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.rightShin: BodyPartPosition(
      topPercent: 0.73,
      leftPercent: 0.511,
      widthPercent: 0.079,
      heightPercent: 0.138,
    ),
    FemaleFrontBodyParts.leftFoot: BodyPartPosition(
      topPercent: 0.89,
      leftPercent: 0.379,
      widthPercent: 0.079,
      heightPercent: 0.046,
    ),
    FemaleFrontBodyParts.rightFoot: BodyPartPosition(
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

  Widget _buildBodyPart(FemaleFrontBodyParts part, Size containerSize) {
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
                  'assets/bodies/female_front.png',
                  fit: BoxFit.contain,
                ),
              ),

              // Body parts
              ...FemaleFrontBodyParts.values.map(
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
class FrontBodyFemaleAlternative extends StatefulWidget {
  Set<String>? selectedBodyParts; // Changed from String? to Set<String>?
  final ValueChanged<String>? onBodyPartSelected;
  final ValueChanged<Set<String>>? onSelectedPartsChanged; // Added callback for selected parts

  FrontBodyFemaleAlternative({
    super.key,
    this.selectedBodyParts,
    this.onBodyPartSelected,
    this.onSelectedPartsChanged,
  });

  @override
  State<StatefulWidget> createState() => _FrontBodyFemaleAlternativeState();
}

class _FrontBodyFemaleAlternativeState extends State<FrontBodyFemaleAlternative> {
  late Set<String> _selectedBodyParts;

  @override
  void initState() {
    super.initState();
    // Initialize with provided selected parts or empty set
    _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
  }

  @override
  void didUpdateWidget(FrontBodyFemaleAlternative oldWidget) {
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
    required FemaleFrontBodyParts part,
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
      aspectRatio: 380 / 650, // Maintain original aspect ratio
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bodies/female_front.png',
              fit: BoxFit.contain,
            ),
          ),

          // Body parts using Align and FractionallySizedBox
          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.head,
            alignment: const Alignment(-0.02, -0.85),
            widthFactor: 0.13,
            heightFactor: 0.077,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.neck,
            alignment: const Alignment(-0.02, -0.7),
            widthFactor: 0.13,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.chest,
            alignment: const Alignment(-0.03, -0.4),
            widthFactor: 0.29,
            heightFactor: 0.26,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.leftUpperArm,
            alignment: const Alignment(-0.58, -0.5),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.rightUpperArm,
            alignment: const Alignment(0.48, -0.5),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.leftForeArm,
            alignment: const Alignment(-0.73, -0.2),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.rightForeArm,
            alignment: const Alignment(0.62, -0.2),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.leftHand,
            alignment: const Alignment(-0.9, 0.05),
            widthFactor: 0.08,
            heightFactor: 0.062,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.rightHand,
            alignment: const Alignment(0.78, 0.05),
            widthFactor: 0.08,
            heightFactor: 0.062,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.leftThigh,
            alignment: const Alignment(-0.26, 0.25),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.rightThigh,
            alignment: const Alignment(0.14, 0.25),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.leftKnee,
            alignment: const Alignment(-0.22, 0.45),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.rightKnee,
            alignment: const Alignment(0.14, 0.45),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.leftShin,
            alignment: const Alignment(-0.22, 0.7),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.rightShin,
            alignment: const Alignment(0.13, 0.7),
            widthFactor: 0.08,
            heightFactor: 0.138,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.leftFoot,
            alignment: const Alignment(-0.22, 0.9),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),

          _buildAlignedBodyPart(
            part: FemaleFrontBodyParts.rightFoot,
            alignment: const Alignment(0.13, 0.9),
            widthFactor: 0.08,
            heightFactor: 0.046,
          ),
        ],
      ),
    );
  }
}