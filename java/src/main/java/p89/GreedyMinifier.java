package p89;

import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import static p89.P89.getPossibleDigitsFor;

final class GreedyMinifier implements Minifier {
  @Override
  public String minify(long value) {
    long valueRemaining = value;
    List<RomanNumeralDigit> digits = new LinkedList<>();
    DLVStatus dlvStatus = new DLVStatus();
    RomanNumeralDigit prev = null;

    while (valueRemaining > 0) {
      List<RomanNumeralDigit> possibleDigits =
          getPossibleDigitsFor(valueRemaining, dlvStatus, prev);

      RomanNumeralDigit largestPossibleDigit =
          possibleDigits.stream().max(Comparator.comparing(RomanNumeralDigit::getValue)).get();

      if (DLVStatus.DLV.contains(largestPossibleDigit.getSecond())) {
        dlvStatus.use(largestPossibleDigit.getSecond());
      }

      valueRemaining -= largestPossibleDigit.getValue();
      prev = largestPossibleDigit;
      digits.add(largestPossibleDigit);
    }

    if (valueRemaining < 0) {
      throw new RuntimeException("Got negative answer");
    }

    return digits.stream().map(RomanNumeralDigit::asString).collect(Collectors.joining());
  }
}
