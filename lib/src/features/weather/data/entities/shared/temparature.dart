class Temperature{
  Temperature({required this.temp}) {
    celsius = temp;
    fahrenheit = (temp * 1.8) + 32;
  }

  num temp;
  late num celsius;
  late num fahrenheit;
}