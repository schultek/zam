

// +++++++

class Tisch {

  String name;

  Tisch(this.name);

  String test1(String hallo) {
    return "Ich bin "+hallo+name;
  }

  Stuhl neuerStuhl() {
    Stuhl s1 = Stuhl();
    return s1;
  }

  Stuhl wegziehen(Stuhl stuhl) {
    stuhl.nutzung = (stuhl.nutzung - 1);
    return stuhl;
  }
}

class Stuhl {

  int nutzung = 5;

  Stuhl();

  int sitzen() {
    nutzung = nutzung + 1;
    return nutzung;
  }
}

void main() {


  Tisch tisch1 = Tisch("Olaf");

  String name = "Olaf";

  Stuhl stuhl1 = tisch1.neuerStuhl();

  tisch1.wegziehen(stuhl1);

  tisch1.wegziehen(stuhl1);

  int x = stuhl1.sitzen(); // 4

  int y = tisch1.neuerStuhl().sitzen(); // = 6

  int z = tisch1.wegziehen(tisch1.neuerStuhl()).sitzen(); // = 5

  String name4 = tisch1.test1(tisch1.test1(tisch1.test1(name + " Schubert") + " Schubert"));





  Stuhl stuhl2 = tisch1.neuerStuhl();

  stuhl2.sitzen();

  Stuhl stuhl3 = tisch1.wegziehen(stuhl2); // 5

  tisch1.wegziehen(stuhl1);

  int a = stuhl3.sitzen();

  int b = stuhl2.sitzen() + a;

  print(b);
  // was ist b ?



  // int, double, bool, float, String -> Valuetype / Wertetype
  // List, alles andere -> Referencetype / Referenztyp

  stuhl2 == stuhl3
  stuhl2 != stuhl1

  a != b



  List<int> l1 = [];

  List<int> l2 = l1;
  

  l1.add(1);

  // l2 = [1];

}