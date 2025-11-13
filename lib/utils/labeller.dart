class Labeller {
  static String _getInitials(String input) {
    final words = input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').split(' ');
    if (words.length >= 2) {
      return words
          .where((w) => w.isNotEmpty)
          .take(2)
          .map((word) => word[0].toUpperCase())
          .join();
    } else if (words.isNotEmpty && words[0].isNotEmpty) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'XX'; // Default fallback
  }

  static String generateRecietNumber({
    required String fullName,
    required String companyName,
    required int count, // This count must be managed and incremented externally
  }) {
    final companyPrefix = _getInitials(companyName);
    final userPrefix = _getInitials(fullName);
    final now = DateTime.now().toUtc();
    final sequenceNumber = count.toString().padLeft(6, '0');
    return '$companyPrefix-$userPrefix-${now.day}${now.month}${now.year}-$sequenceNumber';
  }

  static String getShiftLabeller({
    required String fullName,
    required String companyName,
    required int count, // This count must be managed and incremented externally
  }) {
    final companyPrefix = _getInitials(companyName);
    final userPrefix = _getInitials(fullName);
    final now = DateTime.now().toUtc();
    final sequenceNumber = count.toString().padLeft(6, '0');
    return '$companyPrefix-$userPrefix-${now.day}${now.month}${now.year}-$sequenceNumber';
  }
}
