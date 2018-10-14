package p89;

import java.util.EnumSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Holds which of D, L, V have been used already. They can only be used once per roman numeral
 * string.
 */
class DLVStatus {
  static final Set<RomanNumeral> DLV = EnumSet.of(RomanNumeral.D, RomanNumeral.L, RomanNumeral.V);

  private final Set<RomanNumeral> used;

  DLVStatus() {
    used = EnumSet.noneOf(RomanNumeral.class);
  }

  void use(RomanNumeral rn) {
    if (!DLV.contains(rn)) {
      throw new RuntimeException("Must be one of DLV");
    }

    if (used.contains(rn)) {
      throw new RuntimeException(rn.name() + " was already used");
    }

    used.add(rn);
  }

  boolean hasUsed(RomanNumeral rn) {
    return used.contains(rn);
  }

  @Override
  public String toString() {
    return DLV.stream().map(Enum::name).collect(Collectors.joining());
  }
}
