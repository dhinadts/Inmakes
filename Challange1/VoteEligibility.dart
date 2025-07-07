void main() {
 var person = {'age': 35, 'name': 'Antony M'};

  if (person['age'] as int > 18) {
    print('${person['name']} is eligible to vote');
  } else {
    print('${person['name']} is not eligible to vote');
  }
}
