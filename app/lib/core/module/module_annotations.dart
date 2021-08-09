import 'package:super_annotations/super_annotations.dart';

class Module extends ClassAnnotation {
  const Module();

  static List<Class> modules = [];

  @override
  void apply(Class target, LibraryBuilder library) {
    modules.add(target);
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
          for (var module in Module.modules)
            module.name: refer('ModuleInstance').newInstance([
              refer(module.name).newInstance([]),
              literalMap({
                for (var method in module.methods)
                  if (method.annotations
                      .any((a) => a is InvokeExpression && (a.target as Reference).symbol == 'ModuleItem'))
                    method.name: refer('ModuleFactory').newInstance([
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
                      refer(module.name),
                      refer(method.returns!.symbol!.replaceFirst('?', ''))
                    ]),
              }),
            ], {}, [
              refer(module.name)
            ]).code,
        })
      ])
      .assignFinal("registry")
      .statement);
}

class ModuleItem {
  final String id;
  const ModuleItem({required this.id});
}
