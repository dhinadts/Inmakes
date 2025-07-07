void main() {
  String input = "Dhinakaran";
  
  // Create an empty StringBuffer
  StringBuffer reversedBuffer = StringBuffer();

  // Loop from the last character to the first
  for (int i = input.length - 1; i >= 0; i--) {
    reversedBuffer.write(input[i]);
  }

  // Get the reversed string
  String reversedString = reversedBuffer.toString();

  print("Original String: $input");
  print("Reversed String: $reversedString");
}


// 2.Implement a program to reverse a given string using StringBuffer.