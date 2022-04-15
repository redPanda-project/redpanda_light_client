enum GMType {
  GARLIC_MESSAGE(1),
  FLASCHEN_POST(2),
  CLIENT_MESSAGE(3),
  ACK(4),
  ECHO(7),
  TEST(6);

  const GMType(this.value);

  final num value;
}
