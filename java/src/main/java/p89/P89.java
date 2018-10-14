package p89;

import com.google.common.base.Charsets;

import javax.annotation.Nullable;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;

public final class P89 {

  private Minifier minifier;

  P89(Minifier minifier) {
    this.minifier = minifier;
  }

  public static void main(String[] args) throws IOException {
    P89 soln = new P89(new GreedyMinifier());

    long answer;

    InputStream stream = P89.class.getClassLoader().getResourceAsStream("p89/romans.txt");

    try (BufferedReader r = new BufferedReader(new InputStreamReader(stream, Charsets.UTF_8))) {
      answer =
          r.lines()
              .mapToLong(
                  line -> {
                    String minForm = soln.toMinimalForm(line);
                    long lineDiff = line.length() - minForm.length();
                    if (lineDiff < 0) {
                      throw new RuntimeException(
                          "Found minified version longer than input at " + line);
                    }
                    return lineDiff;
                  })
              .sum();
    }

    System.out.println("Answer is " + answer);
  }

  String toMinimalForm(String romanNumeral) {
    long value = fromRomanNumeral(romanNumeral);

    String minified = minifier.minify(value);

    return minified.length() < romanNumeral.length() ? minified : romanNumeral;
  }

  static List<RomanNumeralDigit> getPossibleDigitsFor(
      long value, DLVStatus dlvStatus, @Nullable RomanNumeralDigit prev) {
    List<RomanNumeralDigit> digits = new LinkedList<>();

    // Solitary digits cases
    for (RomanNumeral rn : RomanNumeral.values()) {
      if (rn.getValue() <= value && !dlvStatus.hasUsed(rn)) {
        digits.add(new RomanNumeralDigit(null, rn));
      }
    }

    /*
     * Subtractive digits cases:
     *
     *  Only one I, X, and C can be used as the leading numeral in part of a subtractive pair.
     *  I can only be placed before V and X.
     *  X can only be placed before L and C.
     *  C can only be placed before D and M.
     */
    for (RomanNumeralDigit rnd : RomanNumeralDigit.LEGAL_PAIRS) {
      // DLV can only occur in the second part of an RND
      if (rnd.getValue() <= value && !dlvStatus.hasUsed(rnd.getSecond())) {
        digits.add(rnd);
      }
    }

    List<RomanNumeralDigit> filteredDigits = new LinkedList<>();

    // Descending rule. Next options must be less than or equal to the digit
    // that came previously, e.g. XIX *not* IXX.
    for (RomanNumeralDigit digit : digits) {
      if (prev == null) {
        filteredDigits.add(digit);
      } else if (digit.getValue() <= prev.getValue()) {
        filteredDigits.add(digit);
      }
    }

    return filteredDigits;
  }

  /** Returns the value of a valid roman numeral string. */
  static long fromRomanNumeral(String s) {
    long total = 0;
    long a = 0;
    RomanNumeral prev = null;

    for (String numeral : s.split("")) {
      RomanNumeral curr = RomanNumeral.of(numeral);

      if (prev == null || (curr.compareTo(prev) == 0)) {
        a += curr.getValue();
      } else if (curr.compareTo(prev) < 0) {
        total += a;
        a = curr.getValue();
      } else if (curr.compareTo(prev) > 0) {
        total += curr.getValue() - a;
        a = 0;
      }

      prev = curr;
    }

    return total + a;
  }
}
