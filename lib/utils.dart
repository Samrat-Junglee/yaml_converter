class Utils {
  /// Converts a camelCase string into a readable English sentence.
  /// For example, "camelCaseString" becomes "Camel case string".
  /// Capitalizes the first letter for better readability.
  static String camelCaseToEnglish(String camelCase) {
    String result = camelCase.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match match) => "${match[1]} ${match[2]?.toLowerCase()}"
    );

    return result[0].toUpperCase() + result.substring(1);
  }

  /// Prepends a specified number of spaces to a given text.
  /// Useful for formatting or indentation purposes.
  static String addSpaces(String text, int n) {
    return ' ' * n + text;
  }

  /// Generates a regular expression pattern based on the given data.
  /// - If the data is numeric, it returns a pattern for whole or decimal numbers.
  /// - If the data matches a URL format, it returns a URL validation pattern.
  /// - If the data matches an email format, it returns an email validation pattern.
  /// - Otherwise, it returns an empty pattern.
  static String validationPattern(String data) {
    bool isDouble = true;
    try {
      double.parse(data);
    } catch (e) {
      isDouble = false;
    }

    if (isDouble) {
      return data.contains('.') ? "'^\\d+(\\.\\d+)?\$'" : "'^\\d+\$'";
    }

    if (RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)').hasMatch(data)) {
      return "'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)'";
    }

    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$').hasMatch(data)) {
      return "'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$'";
    }

    return "''";
  }

  /// Generates a validation message based on the given data.
  /// - If the data is numeric, it returns a message indicating whether it should be a whole or decimal number.
  /// - If the data matches a URL format, it returns a message about invalid URL format.
  /// - If the data matches an email format, it returns a message about invalid email format.
  /// - Otherwise, it returns an empty message.
  static String validationMessage(String data) {
    bool isDouble = true;
    try {
      double.parse(data);
    } catch (e) {
      isDouble = false;
    }

    if (isDouble) {
      return data.contains('.')
          ? '"Input must consist of valid decimal numbers"'
          : '"Input must consist of whole numbers only, with no decimal points or other characters allowed."';
    }

    if (RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)').hasMatch(data)) {
      return '"URL format is invalid"';
    }

    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$').hasMatch(data)) {
      return '"Email format is invalid"';
    }

    return '""';
  }

  /// Handles a numeric ID by determining whether it can be parsed as a number.
  /// - If the ID is numeric, it returns the string representation of the number.
  /// - If the ID is not numeric, it simply returns the original ID.
  static String handleNumericValueForYaml(String id) {
    bool isDouble = true;
    try {
      double.parse(id);
    } catch(e) {
      isDouble = false;
    }

    if (isDouble) return "'$id'";

    return id;
  }
}
