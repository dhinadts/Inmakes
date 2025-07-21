class Animal {
  String? name;
  Animal(this.name);
  void sound() {
    print("Sound fn is called....");
  }
}

class Dog extends Animal {
  String? name;
  Dog(this.name) : super(name);
  @override
  void sound() {
    print("Altered by method override of super function");
  }

  void show() {
    print("Show function... $name");
  }
}

void main() {
  Dog dog = Dog('Dhina');
  dog.sound();
  dog.show();

  dog.name = 'kara';
  dog.show();
}
