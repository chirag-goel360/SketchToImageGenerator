import 'package:humangenerator/src/utils/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'key_value.dart';

enum FORM_FIELD_VALIDATION_TYPES {
  EMPTY_TEXT_NOT_ALLOWED,
  EMPTY_LIST_NOT_ALLOWED,
  LIST_OF_EMAIL_IDS,
  EMAIL_TEXT,
  ALPHANUMERIC_WITH_SPECIAL_CHARS,
  ONLY_NUMBERS_ALLOWED,
  NO_WHITESPACE_ALLOWED,
  MAX_LENGTH_25,
  NULL_NOT_ALLOWED,
  FUTURE_DATE_NOT_ALLOWED,
}

class ReactiveFormValidator {
  final FORM_FIELD_VALIDATION_TYPES type;
  final String errorMessage;

  ReactiveFormValidator({
    @required this.type,
    @required this.errorMessage,
  });
}

class ReactiveFormField<T> {
  final List<ReactiveFormValidator> validators;
  final String name;
  T value;
  String _errorMessage;

  ReactiveFormField({
    this.validators: const [],
    @required this.name,
    this.value,
    String errorMessage,
  }) : _errorMessage = errorMessage;

  void setValidity(String errorMessage) {
    _errorMessage = errorMessage;
  }

  void setValue(T val) {
    value = val;
    _errorMessage = null;
  }

  String get errorMessage => _errorMessage;
}

class ReactiveFormBuilder {
  final Map<String, ReactiveFormField> _formFieldsMap = {};
  final Map<String, BehaviorSubject<dynamic>> subjectData = {};
  final BehaviorSubject<String> _combinedErrorSubject =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _formLevelErrorSubject =
      BehaviorSubject<String>();
  bool _isFormTouched = false;
  bool get isFormTouched => _isFormTouched;

  get _validationMap => {
        FORM_FIELD_VALIDATION_TYPES.EMPTY_TEXT_NOT_ALLOWED:
            _validateEmptyTextNotAllowed,
        FORM_FIELD_VALIDATION_TYPES.EMPTY_LIST_NOT_ALLOWED:
            _validateEmptyListNotAllowed,
        FORM_FIELD_VALIDATION_TYPES.LIST_OF_EMAIL_IDS: _validateListOfEmailIds,
        FORM_FIELD_VALIDATION_TYPES.EMAIL_TEXT: _validateEmail,
        FORM_FIELD_VALIDATION_TYPES.ONLY_NUMBERS_ALLOWED:
            _validateOnlyNumbersAllowed,
        FORM_FIELD_VALIDATION_TYPES.ALPHANUMERIC_WITH_SPECIAL_CHARS:
            _validateAlphaNumericWithSpecialChars,
        FORM_FIELD_VALIDATION_TYPES.MAX_LENGTH_25: _validateMaxLength25,
        FORM_FIELD_VALIDATION_TYPES.NO_WHITESPACE_ALLOWED:
            _validateNoWhiteSpaceAllowed,
        FORM_FIELD_VALIDATION_TYPES.NULL_NOT_ALLOWED: _validateNullNotAllowed,
        FORM_FIELD_VALIDATION_TYPES.FUTURE_DATE_NOT_ALLOWED:
            _validateFutureDateNotAllowed,
      };

  ReactiveFormBuilder(
      Map<String, ReactiveFormField<dynamic>> fieldNamesWithInitialValues) {
    _formFieldsMap.clear();
    subjectData.clear();
    _formFieldsMap.addAll(fieldNamesWithInitialValues);
    _formFieldsMap.forEach((key, value) {
      subjectData[key] = BehaviorSubject<dynamic>.seeded(value.value);
    });

    // validate field in start so that appropriate subscribers can enable/disable other fields
    _validateFields();
    _checkAndPropagateCommonError();
  }

  Stream<dynamic> getFormFieldStream(String name) => subjectData[name].stream;
  Stream<String> get commonErrorStream => _combinedErrorSubject.stream;
  Stream<String> get formLevelErrorStream => _formLevelErrorSubject.stream;

  String _validateEmptyTextNotAllowed(dynamic value, String errorMessage) {
    if (value == null || value == '') {
      return errorMessage;
    }
    return null;
  }

  String _validateFutureDateNotAllowed(dynamic value, String errorMessage) {
    if (value == null) return null;
    if (value.compareTo(DateTime.now()) > 0) {
      return errorMessage;
    }
    return null;
  }

  String _validateEmptyListNotAllowed(dynamic value, String errorMessage) {
    if (value == null || (value as List).length == 0) {
      return errorMessage;
    }
    return null;
  }

  String _validateListOfEmailIds(dynamic value, String errorMessage) {
    if (value == null || (value as List).length == 0) {
      return errorMessage;
    }
    bool valid = true;
    for (int i = 0; i < (value as List).length; i++) {
      valid = EMAIL_REGEX.hasMatch(value[i]);
      if (!valid) break;
    }
    return valid ? null : errorMessage;
  }

  String _validateOnlyNumbersAllowed(dynamic value, String errorMessage) {
    if (isEmptyStringOrNull(value)) {
      return null;
    }

    return ONLY_NUMBERS_REGEX.hasMatch(value) ? null : errorMessage;
  }

  String _validateAlphaNumericWithSpecialChars(
      dynamic value, String errorMessage) {
    if (isEmptyStringOrNull(value)) {
      return null;
    }
    return ALPHANUMERIC_WITH_SPECIAL_CHARS_REGEX.hasMatch(value)
        ? null
        : errorMessage;
  }

  String _validateEmail(dynamic value, String errorMessage) {
    if (isEmptyStringOrNull(value)) {
      return errorMessage;
    }
    return EMAIL_REGEX.hasMatch(value) ? null : errorMessage;
  }

  String _validateMaxLength25(dynamic value, String errorMessage) {
    if (isEmptyStringOrNull(value)) {
      return null;
    }
    return value.runtimeType == String && value.length <= 25
        ? null
        : errorMessage;
  }

  String _validateNoWhiteSpaceAllowed(dynamic value, String errorMessage) {
    if (isEmptyStringOrNull(value)) {
      return null;
    }
    return NO_WHITESPACE_REGEX.hasMatch(value) ? null : errorMessage;
  }

  String _validateNullNotAllowed(dynamic value, String errorMessage) {
    if (value is KeyValueDisableWithExtraDetails) {
      if (isEmptyStringOrNull(value.key) && isEmptyStringOrNull(value.value)) {
        return errorMessage;
      }
    }
    if (value == null) {
      return errorMessage;
    }
    return null;
  }

  void _validateFields() {
    _formFieldsMap.values.forEach((element) {
      for (int i = 0; i < element.validators.length; i++) {
        ReactiveFormValidator validator = element.validators[i];
        String errorMessage = _validationMap[validator.type](
            element.value, validator.errorMessage);
        element.setValidity(errorMessage);
        if (errorMessage != null) {
          break;
        }
      }
    });
  }

  dynamic getFieldValue(String name) {
    return _formFieldsMap[name]?.value;
  }

  bool _checkNullOrEmptyString(dynamic str) => str != null && str != '';

  bool setFieldValue(String name, dynamic value) {
    if (_formFieldsMap[name] == null) return null;
    if (!_checkNullOrEmptyString(_formFieldsMap[name].value) &&
        !_checkNullOrEmptyString(value)) return null;
    if (value == _formFieldsMap[name].value) return null;
    _isFormTouched = true;
    _formFieldsMap[name].setValue(value);
    _validateFields();
    // if value is changed then propagate it to ui using the stream and check for error in the form
    subjectData[name].add(value);
    if (_formFieldsMap[name].errorMessage != null) {
      subjectData[name].addError(_formFieldsMap[name].errorMessage);
    }
    _checkAndPropagateCommonError();
    _checkAndResetFormLevelError();
    return _formFieldsMap[name].errorMessage == null;
  }

  Map<String, String> getErrorMap() {
    Map<String, String> errorMap = {};
    _formFieldsMap.forEach((key, value) {
      if (value.errorMessage != null) {
        errorMap[key] = value.errorMessage;
      }
    });
    return errorMap;
  }

  Map<String, dynamic> _getAllValues() {
    Map<String, dynamic> values = {};
    _formFieldsMap.forEach((key, value) {
      values[key] = value.value;
    });
    return values;
  }

  void setError(String name, String errorMessage) {
    if (_formFieldsMap[name] != null &&
        _formFieldsMap[name].errorMessage != errorMessage) {
      _formFieldsMap[name].setValidity(errorMessage);
      subjectData[name].addError(errorMessage);
      _combinedErrorSubject.add(errorMessage);
    }
  }

  void setFormLevelError(String errorMessage) {
    _formLevelErrorSubject.add(errorMessage);
  }

  bool _checkAndPropagateErrors() {
    bool hasError = false;
    _formFieldsMap.forEach((key, value) {
      if (value.errorMessage != null) {
        hasError = true;
        subjectData[key].addError(value.errorMessage);
      }
    });
    return hasError;
  }

  void _checkAndPropagateCommonError() {
    List<String> keys = _formFieldsMap.keys.toList();
    bool notified = false;
    for (int i = 0; i < keys.length; i++) {
      ReactiveFormField value = _formFieldsMap[keys[i]];
      if (value.errorMessage != null) {
        notified = true;
        _combinedErrorSubject.add(value.errorMessage);
        break;
      }
    }
    if (!notified) {
      _combinedErrorSubject.add(null);
    }
  }

  _checkAndResetFormLevelError() {
    if (_formLevelErrorSubject.value != null) {
      _formLevelErrorSubject.add(null);
    }
  }

  Map<String, dynamic> validateAndGetValues() {
    _validateFields();
    bool hasError = _checkAndPropagateErrors();
    _checkAndPropagateCommonError();
    _checkAndResetFormLevelError();
    if (hasError) {
      throw new Exception('FIELDS_NOT_VALIDATED');
    } else {
      return this._getAllValues();
    }
  }

  dispose() {
    subjectData.values.forEach((element) {
      element.close();
    });
    _combinedErrorSubject.close();
    _formLevelErrorSubject.close();
  }
}

// ignore: non_constant_identifier_names
final RegExp EMAIL_REGEX = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
// ignore: non_constant_identifier_names
final RegExp ALPHANUMERIC_WITH_SPECIAL_CHARS_REGEX =
    RegExp(r"^[a-z0-9&/-]+$", caseSensitive: false);
// ignore: non_constant_identifier_names
final RegExp NO_WHITESPACE_REGEX = RegExp(r"^[^\s]+$", caseSensitive: false);
// ignore: non_constant_identifier_names
final RegExp ONLY_NUMBERS_REGEX = RegExp(r"^[0-9]*$", caseSensitive: false);
// ignore: non_constant_identifier_names
final RegExp IPV4_REGEX = RegExp(
    r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
// ignore: non_constant_identifier_names
final RegExp IP_PORT_REGEX = RegExp(r"^\d{4}$");
