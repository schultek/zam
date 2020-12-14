part of module;

class ModuleMethodMirror {

  String name, id;
  Type type;

  ModuleMethodMirror(this.name, this.id, this.type);
}

class ModuleMirror {

  String id;

  List<ModuleMethodMirror> methods = [];
  ClassMirror classMirror;

  ModuleMirror(this.id, this.classMirror);

  void addMethod(String name, String id, Type type) {
    methods.add(ModuleMethodMirror(name, id, type));
  }

}

class ModuleRegistry {

  static List<ModuleMirror> modules = [];

  static registerModules() {
    initializeReflectable();

    var reflector = Reflectable.getInstance(Module);

    var widgetReflector = Reflectable.getInstance(ModuleWidgetReflectable);
    var moduleWidgetType = widgetReflector.reflectType(ModuleWidget);

    reflector.annotatedClasses.forEach((module) {
      String id = module.simpleName.toLowerCase();
      if (id.endsWith("module")) id = id.substring(0, id.length - 6);
      ModuleMirror moduleMirror = ModuleMirror(id, module);

      print("Found module with id ${moduleMirror.id}");

      for (MethodMirror method in module.instanceMembers.values) {
        for (Object o in method.metadata) {
          if (o is ModuleItem) {
            print("Found method ${method.simpleName} with id ${o.id} and type ${method.reflectedReturnType}");
            bool isModuleWidget = widgetReflector.canReflectType(method.reflectedReturnType) && widgetReflector.reflectType(method.reflectedReturnType).isSubtypeOf(moduleWidgetType) && widgetReflector.reflectType(method.reflectedReturnType).simpleName != moduleWidgetType.simpleName;
            assert(isModuleWidget, "Annotated methods must define a valid module widget return type!");
            int parameterCount = method.parameters.length;
            assert(parameterCount == 0, "Annotated methods must have no parameters!");

            moduleMirror.addMethod(method.simpleName, id + "/" + o.id, method.reflectedReturnType);
          }
        }
      }

      var constructors = module.declarations.values.where((declare) {
        return declare is MethodMirror && declare.isConstructor;
      }).map((d) => d as MethodMirror).toList();

      assert(constructors.length == 1, "Modules must have a constructor.");
      assert(constructors[0].simpleName == module.simpleName, "Modules must have a default constructor.");

      int parameterCount = constructors[0].parameters.length;
      assert(parameterCount == 1, "Module constructors must have exactly 1 parameter.");
      var param = constructors[0].parameters[0];
      assert(!param.isNamed &&
          param.reflectedType == ModuleData, "Module constructors must have a parameter of type ModuleData.");

      modules.add(moduleMirror);
    });
  }

  static List<ModuleWidgetFactory> getModuleWidgetFactories(ModuleData moduleData) {
    return modules.expand((module) {
      var moduleInstance = module.classMirror.newInstance("", [moduleData]);
      var instanceMirror = Reflectable.getInstance(Module).reflect(moduleInstance);
      return module.methods.map((method) {
        return ModuleWidgetFactory(method.id, method.type, () => instanceMirror.invoke(method.name, []));
      });
    }).toList();
  }

}

@immutable
class ModuleWidgetFactory {

  final String id;
  final Type type;
  final ModuleWidget Function() _factory;

  const ModuleWidgetFactory(this.id, this.type, this._factory);

  ModuleWidget getWidget() {
    var widget = this._factory();
    widget._setId(this.id);
    return widget;
  }
}