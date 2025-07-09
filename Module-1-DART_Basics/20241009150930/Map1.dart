// 1.Write a Dart program to create a map of student names and their corresponding ages and print the map.

void main() {
  Map<String, dynamic> students = {
    "Abinay": 17,
    "Balu": 18,
    "Catherine": 16,
    "Dhinakaran": 17,
    "Faazil": 18,
  };
  print("Student Name : Age");
  students.forEach((key, value) => print("$key:$value"));
}
