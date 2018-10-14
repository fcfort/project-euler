package p89;

/** The possible roman numerals. */
enum RomanNumeral {
  I(1),
  V(5),
  X(10),
  L(50),
  C(100),
  D(500),
  M(1000);

  private final int value;

  RomanNumeral(int i) {
    value = i;
  }

  int getValue() {
    return value;
  }

  public static RomanNumeral of(String s) {
    try {
      return RomanNumeral.valueOf(s);
    } catch (IllegalArgumentException e) {
      throw new RuntimeException("Couldn't parse " + s);
    }
  }
}
