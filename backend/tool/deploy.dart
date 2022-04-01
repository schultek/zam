import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

void main() async {
  await buildPackage();

  /*
  await run('dart run build_runner build');

  var functionsJsonPath = '.dart_tool/build/generated/backend/lib/functions.json';
  var functionsJson = await File(functionsJsonPath).readAsString();
  var functions = jsonDecode(functionsJson) as Map<String, dynamic>;

  for (var key in functions.keys) {
    var functionConfig = functions[key];

    var target = functionConfig['target'];
    var service = functionConfig['service'];
    var trigger = functionConfig['trigger'] as Map<String, dynamic>?;

    var signatureType = trigger != null ? 'cloudevent' : 'http';

    await run('docker build --build-arg TARGET=$target --build-arg SIGNATURE_TYPE=$signatureType -t $service .');
    await run('docker tag $service gcr.io/jufa20/$service');
    await run('docker push gcr.io/jufa20/$service');
    await run('gcloud run deploy $service --image=gcr.io/jufa20/$service '
        '--region=europe-west1 --allow-unauthenticated');

    if (trigger != null) {
      var filters = trigger.entries.where((e) => e.key != 'resourceName').map((e) => '${e.key}=${e.value}');

      await run('gcloud eventarc triggers update trigger-$service '
          '--location=global '
          '--destination-run-service=$service '
          '--destination-run-region=europe-west1 '
          '--destination-run-path=/ '
          '--service-account=815326157809-compute@developer.gserviceaccount.com '
          '--event-filters="${filters.join(',')}" '
          '--event-filters-path-pattern="resourceName=${trigger['resourceName']}"');
    }
  }

 */
}

Future<int> run(String command, {bool output = true}) async {
  print('RUNNING $command');
  var args = command.split(' ');
  var process = await Process.start(args[0], args.skip(1).toList(), workingDirectory: _workingDir);

  if (output) {
    process.stdout.listen((event) => stdout.add(event));
  }
  process.stderr.listen((event) => stderr.add(event));

  return process.exitCode;
}

String? _workingDir;

void changeWorkingDir(String dir) {
  _workingDir = dir;
}

Future<void> buildPackage() async {
  var pubspecYaml = File('pubspec.yaml');

  if (!pubspecYaml.existsSync()) {
    stdout.write('Cannot find pubspec.yaml file in current directory.');
    exit(1);
  }

  var pubspecDoc = loadYamlDocument(await pubspecYaml.readAsString()).contents;
  var pubspecMap = {
    ...pubspecDoc as Map,
    'dependencies': {...(pubspecDoc as Map)['dependencies'] as Map}
  };

  var buildDir = Directory('build');
  if (await buildDir.exists()) {
    await buildDir.delete(recursive: true);
  }

  await copy('.', 'build/', ['build/', 'tool/', 'test/']);

  bool hasChangedDependencies = false;

  var dependencies = pubspecMap['dependencies'];
  for (var key in dependencies.keys) {
    var dep = dependencies[key];
    if (dep is YamlMap && dep['path'] != null) {
      print('Found path dependency: $dep');

      var path = dep['path'] as String;
      await copy(path + '/', 'build/packages/$key/', []);

      dependencies[key] = {'path': 'packages/$key'};
      hasChangedDependencies = true;
    }
  }

  if (hasChangedDependencies) {
    var yamlStr = YAMLWriter().write(pubspecMap);
    await File('build/pubspec.yaml').writeAsString(yamlStr);
  }

  changeWorkingDir('build/');
}

Future<void> copy(String from, String to, List<String> exclude) async {
  var dir = Directory(to);
  if (!(await dir.exists())) {
    await dir.create(recursive: true);
  }
  await run('rsync -av --progress $from $to ${exclude.map((e) => '--exclude $e').join(' ')}', output: false);
}
