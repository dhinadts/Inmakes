class Student {
  String? _name;
  int? _age;

  // Getter
  String? get name {
    return _name;
  }

  int? get age {
    return _age;
  }
  // Setter

  set name(String? name) {
    _name = name;
  }

  set age(int? age) {
    if (age! >= 18 && age <= 30) {
      _age = age;
    } else {
      _age = 0;
      print("Error");
      // throw ArgumentError("Age must between 18 and 30");
    }
    // _age = age;
  }
}

void main() {
  var person = Student();
  person.name = 'dhina';
  person.age = 35;
  print(person.name);
  print(person.age);
}
