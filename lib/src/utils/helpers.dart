import 'package:humangenerator/src/utils/key_value.dart';
import 'package:flutter/services.dart';

const String ASSETS_GRAPHICS_PATH = 'assets/graphics';
const String ASSETS_MODULE_ICON_PATH = 'assets/module_icons';
// ignore: non_constant_identifier_names
final RegExp MENTIONS_REGEX = RegExp(r'@[\w\s\d._+-]+[(][\w\s\d._+-]+[)]');

bool compareLists<T>(List<T> list1, List<T> list2) {
  // true means they are same
  bool result = true;
  int length1 = list1?.length ?? 0;
  int length2 = list2?.length ?? 0;
  if (length1 != length2) {
    result = false;
  } else if (list1.toSet().difference(list2.toSet()).length > 0) {
    result = false;
  }
  return result;
}

List<String> getKeysFromKeyValueDisabledWithExtraDetailsList(
    List<KeyValueDisableWithExtraDetails> list) {
  if (list == null) return null;
  return list.map((e) => e.key).toList();
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item) f) sync* {
  int index = 0;
  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}

int parseToInt(dynamic str) {
  switch (str.runtimeType) {
    case String:
      return isEmptyStringOrNull(str) ? null : int.parse(str);
    case int:
      return str;
    default:
      return null;
  }
}

num parseToNum(dynamic str) {
  switch (str.runtimeType) {
    case String:
      return isEmptyStringOrNull(str) ? null : num.parse(str);
    case int:
    case double:
      return str;
    default:
      return null;
  }
}

String capitalize(String word) {
  if (word == null) {
    return word;
  }
  word = word.toLowerCase();
  var d = word.split(" ");
  return d.map((e) => "${e[0].toUpperCase()}${e.substring(1)}").join(" ");
}

bool isEmptyStringOrNull(String str) => str == null || str == '';
bool isZeroOrNull(num number) => number == null || number == 0;

class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}
