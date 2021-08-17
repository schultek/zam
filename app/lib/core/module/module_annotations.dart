import 'package:super_annotations/super_annotations.dart';

export '../../models/segment_size.dart';

class Module extends ClassAnnotation {
  final String id;
  const Module(this.id);

  static Map<String, Class> modules = {};

  @override
  void apply(Class target, LibraryBuilder library) {
    modules[id] = target;
  }
}

class ModuleWidgetReflectable extends ClassAnnotation {
  const ModuleWidgetReflectable();

  static List<Class> moduleElements = [];

  @override
  void apply(Class target, LibraryBuilder library) {
    moduleElements.add(target);
  }
}

@CodeGen.runAfter()
void buildModuleFactories(LibraryBuilder library) {
  library.directives.add(Directive.import(CodeGen.currentFile));
  library.directives.add(Directive.import('module.dart'));
  library.body.add(refer('ModuleRegistry')
      .newInstance([
        literalMap({
          for (var module in Module.modules.entries)
            module.key: refer('ModuleInstance').newInstance([
              refer(module.value.name).newInstance([]),
              literalMap({
                for (var method in module.value.methods)
                  if (method.resolvedAnnotations.any((d) => d is ModuleItem))
                    method.resolvedAnnotations.firstWhere((d) => d is ModuleItem).id:
                        refer('ModuleFactory').newInstance([
                      Method((m) => m
                        ..lambda = true
                        ..requiredParameters.addAll([
                          Parameter((p) => p.name = 'c'),
                          Parameter((p) => p.name = 'm'),
                          Parameter((p) => p.name = 'id'),
                        ])
                        ..body = refer('m').property(method.name!).call([
                          for (var p in method.requiredParameters)
                            if (p.type?.symbol == 'BuildContext')
                              refer('c')
                            else if (p.type?.symbol == 'String?')
                              refer('id')
                        ]).code).closure
                    ], {}, [
                      refer(module.value.name),
                      refer(method.returns!.symbol!.replaceFirst('?', ''))
                    ]),
              }),
            ], {}, [
              refer(module.value.name)
            ]).code,
        })
      ])
      .assignFinal('registry')
      .statement);
}

class ModuleItem {
  final String id;
  const ModuleItem(this.id);
}
