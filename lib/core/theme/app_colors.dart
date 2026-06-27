import 'package:flutter/material.dart';

/// Brand palette, calibrated to dwelleo.sa (lime + purple on near-black / white).
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  /// Signature lime (sampled from the official mark).
  static const Color primary = Color(0xFFB8D030);
  static const Color primaryDark = Color(0xFF93A821);
  static const Color primaryLight = Color(0xFFCDE253);

  /// Purple accent (List Property / AI pill).
  static const Color accent = Color(0xFF6B4FA0);
  static const Color accentLight = Color(0xFF9B7FD4);

  /// Text/icon color that sits ON the lime (near-black for AA contrast).
  static const Color ink = Color(0xFF12150A);

  // ── Light surfaces ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF6F7F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE7E9E2);

  static const Color textPrimary = Color(0xFF14160F);
  static const Color textSecondary = Color(0xFF646B58);

  // ── Dark surfaces (near-black, faint warm tint like the site) ───────────────
  static const Color backgroundDark = Color(0xFF0C0D0A);
  static const Color surfaceDark = Color(0xFF17180F);
  static const Color cardDark = Color(0xFF1B1D12);
  static const Color dividerDark = Color(0xFF2A2C20);

  static const Color textPrimaryDark = Color(0xFFF3F5EC);
  static const Color textSecondaryDark = Color(0xFF9CA38C);

  // ── Shared ──────────────────────────────────────────────────────────────────
  static const Color textOnPrimary = ink;
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color shadow = Color(0x14000000);

  /// Onboarding/auth hero gradient (deep greenish-black -> black).
  static const Color heroTop = Color(0xFF12180A);
  static const Color heroBottom = Color(0xFF000000);
}
