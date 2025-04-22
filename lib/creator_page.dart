import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml_creator/utils.dart';

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  TextEditingController _jsonController = TextEditingController();
  TextEditingController _yamlController = TextEditingController();

  String yamlText = "fields:\n";

  /// Converts a given JSON string into a YAML representation for form configuration.
  /// The resulting YAML format includes fields, labels, descriptions, types, and validations.
  ///
  /// The `handleJson` function recursively processes the JSON data and generates
  /// corresponding YAML content for objects, arrays, and primitive types.
  ///
  /// Parameters:
  /// - [json]: A JSON string to be converted.
  /// - [indentationSpace]: The current indentation level used for YAML formatting.
  ///
  /// Example Usage:
  ///
  /// String json = '{"name": "John", "age": 30, "isAdmin": false}';
  /// handleJson(json, 2);
  ///
  void handleJson(String json, int indentationSpace) {
    Map<String, dynamic> jsonData = jsonDecode(json);

    for (int i = 0; i < jsonData.entries.length; i++) {
      if (jsonData.entries.toList()[i].value is Map<String, dynamic>) {
        yamlText += Utils.addSpaces("- id: ${Utils.handleNumericValueForYaml(jsonData.entries.toList()[i].key)}", indentationSpace) + "\n";
        yamlText += Utils.addSpaces(
                "label: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}", indentationSpace + 2) +
            "\n";
        yamlText += Utils.addSpaces(
                "description: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}", indentationSpace + 2) +
            "\n";
        yamlText += Utils.addSpaces("type: object", indentationSpace + 2) + "\n";
        yamlText += Utils.addSpaces("fields:", indentationSpace + 2) + "\n";
        handleJson(jsonEncode(jsonData.entries.toList()[i].value), indentationSpace + 4);
      } else if (jsonData.entries.toList()[i].value is List<dynamic>) {
        if (jsonData.entries.toList()[i].value[0] is Map<String, dynamic>) {
          yamlText += Utils.addSpaces("- id: ${Utils.handleNumericValueForYaml(jsonData.entries.toList()[i].key)}", indentationSpace) + "\n";
          yamlText += Utils.addSpaces(
                  "label: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}", indentationSpace + 2) +
              "\n";
          yamlText += Utils.addSpaces("description: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}",
                  indentationSpace + 2) +
              "\n";
          yamlText += Utils.addSpaces("type: objectList", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("objectFields:", indentationSpace + 2) + "\n";
          Map<String, dynamic> jsonValue = jsonData.entries.toList()[i].value[0];
          handleJson(jsonEncode(jsonValue), indentationSpace + 4);
        } else if (jsonData.entries.toList()[i].value[0] is int || jsonData.entries.toList()[i].value[0] is double) {
          yamlText += Utils.addSpaces("- id: ${Utils.handleNumericValueForYaml(jsonData.entries.toList()[i].key)}", indentationSpace) + "\n";
          yamlText += Utils.addSpaces(
                  "label: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}", indentationSpace + 2) +
              "\n";
          yamlText += Utils.addSpaces("description: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}",
                  indentationSpace + 2) +
              "\n";
          yamlText += Utils.addSpaces("type: List", indentationSpace + 2) + "\n";
          if (jsonData.entries.toList()[i].value[0] is String) {
            yamlText += Utils.addSpaces("subtype: TextField", indentationSpace + 2) + "\n";
          } else if (jsonData.entries.toList()[i].value[0] is int || jsonData.entries.toList()[i].value[0] is double) {
            yamlText += Utils.addSpaces("subtype: Number", indentationSpace + 2) + "\n";
          } else {
            yamlText += Utils.addSpaces("subtype: TextField", indentationSpace + 2) + "\n";
          }
          yamlText += Utils.addSpaces("fields:", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("validations:", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("required: true", indentationSpace + 4) + "\n";
          yamlText +=
              Utils.addSpaces("pattern: ${Utils.validationPattern(jsonData.entries.toList()[i].value[0].toString())}", indentationSpace + 4) + "\n";
          yamlText +=
              Utils.addSpaces("message: ${Utils.validationMessage(jsonData.entries.toList()[i].value[0].toString())}", indentationSpace + 4) + "\n";
        } else if (jsonData.entries.toList()[i].value[0] is String) {
          yamlText += Utils.addSpaces("- id: ${Utils.handleNumericValueForYaml(jsonData.entries.toList()[i].key)}", indentationSpace) + "\n";
          yamlText += Utils.addSpaces(
                  "label: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}", indentationSpace + 2) +
              "\n";
          yamlText += Utils.addSpaces("description: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}",
                  indentationSpace + 2) +
              "\n";
          yamlText += Utils.addSpaces("type: List", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("subtype: TextField", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("fields:", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("validations:", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("required: true", indentationSpace + 4) + "\n";
          yamlText +=
              Utils.addSpaces("pattern: ${Utils.validationPattern(jsonData.entries.toList()[i].value[0].toString())}", indentationSpace + 4) + "\n";
          yamlText +=
              Utils.addSpaces("message: ${Utils.validationMessage(jsonData.entries.toList()[i].value[0].toString())}", indentationSpace + 4) + "\n";
        }
      } else {
        yamlText += Utils.addSpaces("- id: ${Utils.handleNumericValueForYaml(jsonData.entries.toList()[i].key)}", indentationSpace) + "\n";
        yamlText += Utils.addSpaces(
                "label: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}", indentationSpace + 2) +
            "\n";
        yamlText += Utils.addSpaces(
                "description: ${Utils.handleNumericValueForYaml(Utils.camelCaseToEnglish(jsonData.entries.toList()[i].key))}", indentationSpace + 2) +
            "\n";
        if (jsonData.entries.toList()[i].value is String) {
          yamlText += Utils.addSpaces("type: TextField", indentationSpace + 2) + "\n";
        } else if (jsonData.entries.toList()[i].value is int || jsonData.entries.toList()[i].value is double) {
          yamlText += Utils.addSpaces("type: Number", indentationSpace + 2) + "\n";
        } else if (jsonData.entries.toList()[i].value is bool) {
          yamlText += Utils.addSpaces("type: Bool", indentationSpace + 2) + "\n";
        }
        if (jsonData.entries.toList()[i].value is bool) {
          // No validations required
        } else {
          yamlText += Utils.addSpaces("validations:", indentationSpace + 2) + "\n";
          yamlText += Utils.addSpaces("required: false", indentationSpace + 4) + "\n";
          yamlText +=
              Utils.addSpaces("pattern: ${Utils.validationPattern(jsonData.entries.toList()[i].value.toString())}", indentationSpace + 4) + "\n";
          yamlText +=
              Utils.addSpaces("message: ${Utils.validationMessage(jsonData.entries.toList()[i].value.toString())}", indentationSpace + 4) + "\n";
        }
        print("${jsonData.entries.toList()[i].key} : ${jsonData.entries.toList()[i].value} -> ${jsonData.entries.toList()[i].value.runtimeType}");
      }
    }

    setState(() {
      _yamlController.text = yamlText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "JGC Yaml Creator",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          width: size.width / 2.2,
                          height: size.height / 1.2,
                          decoration:
                              BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: _jsonController,
                            maxLines: null,
                            decoration: InputDecoration(border: InputBorder.none, hintText: "Paste your json text over here"),
                          )),
                    ),
                    SizedBox(
                      height: 40,
                      width: size.width / 2.2,
                      child: MaterialButton(
                        onPressed: () {
                          handleJson(_jsonController.text, 2);
                        },
                        color: Colors.black,
                        child: Text(
                          "Generate",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: size.height / 1.2,
                  width: 2,
                  color: Colors.black12,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          width: size.width / 2.2,
                          height: size.height / 1.2,
                          decoration:
                              BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: _yamlController,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 40,
                          width: size.width / 4.5,
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                yamlText = "fields:\n";
                                _yamlController.clear();
                              });
                            },
                            color: Colors.red,
                            child: Text(
                              "Clear Yaml",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 40,
                          width: size.width / 4.5,
                          child: MaterialButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _yamlController.text));
                            },
                            color: Colors.black,
                            child: Text(
                              "Copy Yaml",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
