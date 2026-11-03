/// Arguments passed with Navigator.pushNamed for the math routes.
class MathFlowArgs {
  const MathFlowArgs({this.userName, this.openLearningList = false});

  /// Shown in "Thanks, <name>" and "Here's your map, <name>". Optional.
  final String? userName;

  /// When true the map opens with the learning list already on top.
  final bool openLearningList;
}
