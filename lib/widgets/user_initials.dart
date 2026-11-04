import 'package:flutter/material.dart';

const List<Color> _avatarPalette = [
  Color(0xFF8D6E63),
  Color(0xFF5C6BC0),
  Color(0xFF66BB6A),
  Color(0xFFAB47BC),
  Color(0xFFEF5350),
  Color(0xFF26A69A),
  Color(0xFFFFA726),
  Color(0xFF42A5F5),
];

/// Deterministic color for a given seed (username or groupId) — same person
/// always gets the same color, with no server-side field required.
Color avatarColorFor(String seed) {
  if (seed.isEmpty) return _avatarPalette.first;
  final hash = seed.codeUnits.fold<int>(0, (sum, c) => sum + c);
  return _avatarPalette[hash % _avatarPalette.length];
}

/// Up to two initials from a display name. Falls back gracefully for empty
/// or single-word names (usernames, group names, etc.).
String initialsFor(String displayName) {
  final parts = displayName
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
