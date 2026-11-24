import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase project settings passed at build time with
/// `--dart-define-from-file=config/supabase.json`.
abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  /// False in tests and in builds without the config file.
  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}

/// Connects to Supabase when the app was built with the config.
///
/// Builds without it (CI, widget tests) still start, they just have no
/// backend. Signing in happens later, see ADR-0001.
Future<void> initSupabase() async {
  if (!SupabaseConfig.isConfigured) return;
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
}

/// The Supabase client. Repositories read it from here so tests can
/// override it.
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);
