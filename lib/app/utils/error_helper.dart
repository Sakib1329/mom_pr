/// Converts any exception into a clean, user-facing error label.
///
/// Rules:
/// - Offline (SocketException / no connection) → returns null → callers should
///   rely on the home-level offline UI and NOT show a toast.
/// - HTTP 5xx server errors → "🚧 Server unavailable"
/// - Any other HTTP status code → "HTTP XXX"
/// - Anything else (unknown) → "Error"
///
/// Note: manually thrown translated strings (e.g. throw 'email_empty'.tr)
/// are returned as-is because they are already user-friendly.
String cleanErrorMessage(Object e) {
  final s = e.toString();

  // Already a clean/translated user message (manually thrown string)
  final isRawException = s.contains('Exception') ||
      s.contains('Error') ||
      s.contains('SocketException') ||
      s.contains('HttpException') ||
      s.contains('FormatException') ||
      s.contains('TimeoutException') ||
      s.contains('DioException') ||
      s.contains('ClientException');

  if (!isRawException) {
    // It's a manually thrown translated string — show it as-is
    return s;
  }

  // Offline / no internet
  if (s.contains('SocketException') ||
      s.contains('failed to connect') ||
      s.contains('No internet') ||
      s.contains('Network is unreachable') ||
      s.contains('Connection refused')) {
    return 'offline'; // callers use this sentinel to skip toast or show offline msg
  }

  // Extract HTTP status code
  final codeMatch = RegExp(r'\b([3-5]\d{2})\b').firstMatch(s);
  if (codeMatch != null) {
    return 'HTTP ${codeMatch.group(1)}';
  }

  return 'Error';
}

/// Returns true if the error represents a network connectivity issue.
bool isOfflineError(Object e) {
  final s = e.toString();
  return s.contains('SocketException') ||
      s.contains('failed to connect') ||
      s.contains('No internet') ||
      s.contains('Network is unreachable') ||
      s.contains('Connection refused');
}
