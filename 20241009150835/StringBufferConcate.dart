// 1.Write a Dart program to concatenate two strings using StringBuffer.

void main() {
  var firstname = StringBuffer('Dhinakaran');
  String lastName = "Kalaimani";
  firstname.write(" " + lastName); 
  var fullName = firstname.toString(); 
  print(fullName);
}
