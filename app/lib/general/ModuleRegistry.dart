import 'package:reflectable/reflectable.dart';
import '../main.reflectable.dart';

import 'Module.dart';

class ModuleRegistry {

  static List<ClassMirror> modules = [];

  static registerModules() {
    initializeReflectable();

    var reflector = Reflectable.getInstance(ModuleReflector);
    var moduleType = reflector.reflectType(Module);

    reflector.annotatedClasses.forEach((module) {
      if (module.simpleName == "Module") return;
      assert(module.isSubclassOf(moduleType), "Module ${module.simpleName} must extend the Module class.");

      print("FOUND MODULE ${module.simpleName}");
      modules.add(module);
    });
  }

  static List<Module> getAllModules() {
    return modules.map((m) => m.newInstance("", []) as Module).toList();
  }

}




/*

faktoren:
- user defined layout
- module self prioritizing

- mehrere unterschiedliche karten pro modul möglich

examples
- next upcoming event on top
- pinned anouncement on top
- management actions high, only organizer
- welcome message on top, only on first start
- ...

programmatische generierung der homepage
  -> abfragen der module
  -> jedes modul kann beliebig fiele karten registrieren zur anzeige
  -> sortieren der module nach priorität / ordnung
  -> anzeigen der module



karten sortierung
  - index -> user defined
  - size -> full / half width
  - priority -> module defined

*/
