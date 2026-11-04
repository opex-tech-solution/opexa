/// Extra passed with context.go / context.push for the math diagnostic route:
///   context.go(AppRoutes.mathDiagnostic, extra: const MathFlowArgs(userName: 'Chineche'));
class MathFlowArgs {
  const MathFlowArgs({this.userName});

  /// Shown in "Thanks, <name>" and "Here's your map, <name>". Optional.
  final String? userName;
}
