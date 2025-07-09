// 2.Develop a program to find the length of each string in a list of strings and store it in a map.

void main() {
  List<String> names = ["Abinay", "Balu", "Catherine", "Dhinakaran", "Faazil"];

  Map<String, int> nameLengths = {};

  for (var name in names) {
    nameLengths[name] = name.length;
  }

  print("Each String's Lengths in the Map: \n $nameLengths");
}
