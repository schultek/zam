import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/functions_framework.dart';

Builder cloudRunBuilder([BuilderOptions? options]) => const CloudRunBuilder();

class CloudRunBuilder implements Builder {
  const CloudRunBuilder();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final entries = <String, dynamic>{};

    var libraryElement = await buildStep.resolver.libraryFor(buildStep.inputId);

    for (var annotatedElement in _fromLibrary(libraryElement)) {
      final element = annotatedElement.element;
      if (element is! FunctionElement || element.isPrivate) {
        throw InvalidGenerationSourceError(
          'Only top-level, public functions are supported.',
          element: element,
        );
      }

      final targetReader = annotatedElement.annotation.read('target');

      final targetName = targetReader.isNull ? element.name : targetReader.stringValue;

      if (entries.containsKey(targetName)) {
        throw InvalidGenerationSourceError(
          'A function has already been annotated with target "$targetName".',
          element: element,
        );
      }

      var trigger = annotatedElement.annotation.read('trigger');

      entries[targetName] = {
        'trigger': _writeTrigger(trigger),
        'target': targetName,
        'service': targetName //
            .split(RegExp(r'[ ./_\-\\]+|(?<=[a-z])(?=[A-Z])'))
            .map((t) => t.toLowerCase())
            .join('-'),
      };
    }

    await buildStep.writeAsString(
      buildStep.inputId.changeExtension('.json'),
      JsonEncoder.withIndent('  ').convert(entries),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        'lib/functions.dart': ['lib/functions.json'],
      };
}

Iterable<AnnotatedElement> _fromLibrary(LibraryElement library) sync* {
  // Merging the `topLevelElements` picks up private elements and fields.
  // While neither is supported, it allows us to provide helpful errors if devs
  // are using the annotations incorrectly.
  final mergedElements = {
    ...library.topLevelElements,
    ...library.exportNamespace.definedNames.values,
  };

  for (var element in mergedElements) {
    final annotations = _checker.annotationsOf(element).toList();

    if (annotations.isEmpty) {
      continue;
    }
    if (annotations.length > 1) {
      throw InvalidGenerationSourceError(
        'Cannot be annotated with `CloudFunction` more than once.',
        element: element,
      );
    }
    yield AnnotatedElement(ConstantReader(annotations.single), element);
  }
}

dynamic _writeTrigger(ConstantReader trigger) {
  if (trigger.isNull) {
    return null;
  }
  if (trigger.instanceOf(_firestoreTriggerChecker)) {
    return {
      'type': 'google.cloud.audit.log.v1.written',
      'serviceName': 'firestore.googleapis.com',
      'methodName': 'google.firestore.v1.Firestore.${trigger.read('event').stringValue}Document',
      'resourceName': trigger.read('documentPath').stringValue,
    };
  }
}

const _checker = TypeChecker.fromRuntime(CloudFunction);
const _firestoreTriggerChecker = TypeChecker.fromRuntime(FirestoreTrigger);
