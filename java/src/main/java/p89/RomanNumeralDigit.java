package p89;

import com.google.common.collect.ImmutableList;

import javax.annotation.Nullable;
import java.util.List;
import java.util.Objects;

/** A roman numeral digit, possibly consisting of a subtractive pair. */
class RomanNumeralDigit {
  static List<RomanNumeralDigit> LEGAL_PAIRS =
      ImmutableList.of(
          new RomanNumeralDigit(RomanNumeral.I, RomanNumeral.V),
          new RomanNumeralDigit(RomanNumeral.I, RomanNumeral.X),
          new RomanNumeralDigit(RomanNumeral.X, RomanNumeral.L),
          new RomanNumeralDigit(RomanNumeral.X, RomanNumeral.C),
          new RomanNumeralDigit(RomanNumeral.C, RomanNumeral.D),
          new RomanNumeralDigit(RomanNumeral.C, RomanNumeral.M));

  private final @Nullable RomanNumeral first;
  private final RomanNumeral second;

  RomanNumeralDigit(@Nullable RomanNumeral first, RomanNumeral second) {
    this.first = first;
    this.second = second;
  }

  @Nullable
  RomanNumeral getFirst() {
    return first;
  }

  RomanNumeral getSecond() {
    return second;
  }

  long getValue() {
    return second.getValue() - (first == null ? 0 : first.getValue());
  }

  String asString() {
    return (first == null ? "" : first.name()) + second.name();
  }

  @Override
  public String toString() {
    return asString();
  }

  @Override
  public boolean equals(Object o) {
    if (o == null) {
      return false;
    }

    if (getClass() != o.getClass()) {
      return false;
    }

    final RomanNumeralDigit other = (RomanNumeralDigit) o;

    return Objects.equals(first, other.getFirst()) && Objects.equals(second, other.getSecond());
  }

  @Override
  public int hashCode() {
    return Objects.hash(this.first, this.second);
  }
}
