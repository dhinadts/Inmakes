void main() {
  int day = 7;

  switch (day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      print('Weekday');
      break;
    case 6:
    case 7:
      print('Weekend');
      break;
    default:
      print('Invalid day');
  }
}
