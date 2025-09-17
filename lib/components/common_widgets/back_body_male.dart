import 'package:flutter/material.dart';

enum MaleBackBodyParts {
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

extension MaleBackBodyPartsExtension on MaleBackBodyParts {
  String get label {
    switch (this) {
      case MaleBackBodyParts.head:
        return "Head (Back)";
      case MaleBackBodyParts.neck:
        return "Neck (Back)";
      case MaleBackBodyParts.leftUpperArm:
        return "Left Upper Arm (Back)";
      case MaleBackBodyParts.leftForeArm:
        return "Left Forearm (Back)";
      case MaleBackBodyParts.leftHand:
        return "Left Hand (Back)";
      case MaleBackBodyParts.rightUpperArm:
        return "Right Upper Arm (Back)";
      case MaleBackBodyParts.rightForeArm:
        return "Right Forearm (Back)";
      case MaleBackBodyParts.rightHand:
        return "Right Hand (Back)";
      case MaleBackBodyParts.chest:
        return "Back";
      case MaleBackBodyParts.leftThigh:
        return "Left Thigh (Back)";
      case MaleBackBodyParts.rightThigh:
        return "Right Thigh (Back)";
      case MaleBackBodyParts.leftKnee:
        return "Left Knee (Back)";
      case MaleBackBodyParts.rightKnee:
        return "Right Knee (Back)";
      case MaleBackBodyParts.leftShin:
        return "Left Shin (Back)";
      case MaleBackBodyParts.rightShin:
        return "Right Shin (Back)";
      case MaleBackBodyParts.leftFoot:
        return "Left Foot (Back)";
      case MaleBackBodyParts.rightFoot:
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

class BackBodyMale extends StatefulWidget {
  Set<String>? selectedBodyParts;
  final ValueChanged<String>? onBodyPartSelected;
  final ValueChanged<Set<String>>? onSelectedPartsChanged; // Added callback for selected parts

  BackBodyMale({
    super.key,
    this.selectedBodyParts,
    this.onBodyPartSelected,
    this.onSelectedPartsChanged,
  });

  @override
  State<StatefulWidget> createState() => _BackBodyMaleState();
}

class _BackBodyMaleState extends State<BackBodyMale> {
  late Set<String> _selectedBodyParts;

  @override
  void initState() {
    super.initState();
    // Initialize with provided selected parts or empty set
    _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
  }

  @override
  void didUpdateWidget(BackBodyMale oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected parts if the widget's selectedBodyParts changed
    if (widget.selectedBodyParts != oldWidget.selectedBodyParts) {
      setState(() {
        _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
      });
    }
  }

  static const Map<MaleBackBodyParts, BodyPartPosition> _bodyPartPositions = {
    MaleBackBodyParts.head: BodyPartPosition(
      topPercent: 0.03,
      leftPercent: 0.46,
      widthPercent: 0.13,
      heightPercent: 0.08,
    ),
    MaleBackBodyParts.neck: BodyPartPosition(
      topPercent: 0.14,
      leftPercent: 0.46,
      widthPercent: 0.13,
      heightPercent: 0.05,
    ),
    MaleBackBodyParts.chest: BodyPartPosition(
      topPercent: 0.19,
      leftPercent: 0.373,
      widthPercent: 0.29,
      heightPercent: 0.26,
    ),
    MaleBackBodyParts.leftUpperArm: BodyPartPosition(
      topPercent: 0.22,
      leftPercent: 0.26,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.leftForeArm: BodyPartPosition(
      topPercent: 0.34,
      leftPercent: 0.17,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.leftHand: BodyPartPosition(
      topPercent: 0.48,
      leftPercent: 0.06,
      widthPercent: 0.12,
      heightPercent: 0.06,
    ),
    MaleBackBodyParts.rightUpperArm: BodyPartPosition(
      topPercent: 0.22,
      leftPercent: 0.69,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.rightForeArm: BodyPartPosition(
      topPercent: 0.34,
      leftPercent: 0.79,
      widthPercent: 0.08,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.rightHand: BodyPartPosition(
      topPercent: 0.48,
      leftPercent: 0.87,
      widthPercent: 0.12,
      heightPercent: 0.06,
    ),
    MaleBackBodyParts.leftThigh: BodyPartPosition(
      topPercent: 0.54,
      leftPercent: 0.39,
      widthPercent: 0.1,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.rightThigh: BodyPartPosition(
      topPercent: 0.54,
      leftPercent: 0.545,
      widthPercent: 0.1,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.leftKnee: BodyPartPosition(
      topPercent: 0.69,
      leftPercent: 0.4,
      widthPercent: 0.1,
      heightPercent: 0.05,
    ),
    MaleBackBodyParts.rightKnee: BodyPartPosition(
      topPercent: 0.69,
      leftPercent: 0.55,
      widthPercent: 0.1,
      heightPercent: 0.05,
    ),
    MaleBackBodyParts.leftShin: BodyPartPosition(
      topPercent: 0.75,
      leftPercent: 0.415,
      widthPercent: 0.07,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.rightShin: BodyPartPosition(
      topPercent: 0.75,
      leftPercent: 0.55,
      widthPercent: 0.07,
      heightPercent: 0.14,
    ),
    MaleBackBodyParts.leftFoot: BodyPartPosition(
      topPercent: 0.92,
      leftPercent: 0.41,
      widthPercent: 0.1,
      heightPercent: 0.05,
    ),
    MaleBackBodyParts.rightFoot: BodyPartPosition(
      topPercent: 0.92,
      leftPercent: 0.52,
      widthPercent: 0.1,
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

  Widget _buildBodyPart(MaleBackBodyParts part, Size containerSize) {
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
                  'assets/bodies/back_view.png',
                  fit: BoxFit.contain,
                ),
              ),

              // Body parts
              ...MaleBackBodyParts.values.map(
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
class BackBodyMaleAlternative extends StatefulWidget {
  Set<String>? selectedBodyParts; // Changed from String? to Set<String>?
  final ValueChanged<String>? onBodyPartSelected;
  final ValueChanged<Set<String>>? onSelectedPartsChanged; // Added callback for selected parts

  BackBodyMaleAlternative({
    super.key,
    this.selectedBodyParts,
    this.onBodyPartSelected,
    this.onSelectedPartsChanged,
  });

  @override
  State<StatefulWidget> createState() => _BackBodyMaleAlternativeState();
}

class _BackBodyMaleAlternativeState extends State<BackBodyMaleAlternative> {
  late Set<String> _selectedBodyParts;

  @override
  void initState() {
    super.initState();
    // Initialize with provided selected parts or empty set
    _selectedBodyParts = widget.selectedBodyParts?.toSet() ?? <String>{};
  }

  @override
  void didUpdateWidget(BackBodyMaleAlternative oldWidget) {
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
    required MaleBackBodyParts part,
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
              'assets/bodies/back_view.png',
              fit: BoxFit.contain,
            ),
          ),

          // Body parts using Align and FractionallySizedBox
          _buildAlignedBodyPart(
            part: MaleBackBodyParts.head,
            alignment: const Alignment(0.02, -0.85),
            widthFactor: 0.13,
            heightFactor: 0.08,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.neck,
            alignment: const Alignment(0.02, -0.7),
            widthFactor: 0.13,
            heightFactor: 0.05,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.chest,
            alignment: const Alignment(0.0, -0.4),
            widthFactor: 0.29,
            heightFactor: 0.26,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.leftUpperArm,
            alignment: const Alignment(-0.52, -0.5),
            widthFactor: 0.08,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.rightUpperArm,
            alignment: const Alignment(0.52, -0.5),
            widthFactor: 0.08,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.leftForeArm,
            alignment: const Alignment(-0.67, -0.2),
            widthFactor: 0.08,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.rightForeArm,
            alignment: const Alignment(0.67, -0.2),
            widthFactor: 0.08,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.leftHand,
            alignment: const Alignment(-0.84, 0.05),
            widthFactor: 0.08,
            heightFactor: 0.06,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.rightHand,
            alignment: const Alignment(0.84, 0.05),
            widthFactor: 0.08,
            heightFactor: 0.06,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.leftThigh,
            alignment: const Alignment(-0.2, 0.25),
            widthFactor: 0.08,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.rightThigh,
            alignment: const Alignment(0.2, 0.25),
            widthFactor: 0.08,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.leftKnee,
            alignment: const Alignment(-0.18, 0.45),
            widthFactor: 0.05,
            heightFactor: 0.05,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.rightKnee,
            alignment: const Alignment(0.18, 0.45),
            widthFactor: 0.05,
            heightFactor: 0.05,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.leftShin,
            alignment: const Alignment(-0.18, 0.7),
            widthFactor: 0.06,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.rightShin,
            alignment: const Alignment(0.18, 0.7),
            widthFactor: 0.06,
            heightFactor: 0.14,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.leftFoot,
            alignment: const Alignment(-0.18, 0.9),
            widthFactor: 0.06,
            heightFactor: 0.05,
          ),

          _buildAlignedBodyPart(
            part: MaleBackBodyParts.rightFoot,
            alignment: const Alignment(0.18, 0.9),
            widthFactor: 0.06,
            heightFactor: 0.05,
          ),
        ],
      ),
    );
  }
}