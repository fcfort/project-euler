package p89;

import com.google.common.base.Charsets;
import org.junit.Test;

import java.io.*;
import java.util.Arrays;
import java.util.stream.Stream;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static p89.P89.fromRomanNumeral;
import static p89.P89.getPossibleDigitsFor;
import static p89.RomanNumeral.I;
import static p89.RomanNumeral.V;

public class P89Test {
  @Test
  public void testSingleDigit() {
    assertEquals(1, fromRomanNumeral("I"));
    assertEquals(5, fromRomanNumeral("V"));
    assertEquals(10, fromRomanNumeral("X"));
    assertEquals(50, fromRomanNumeral("L"));
    assertEquals(100, fromRomanNumeral("C"));
    assertEquals(500, fromRomanNumeral("D"));
    assertEquals(1000, fromRomanNumeral("M"));
  }

  @Test
  public void testTwoSame() {
    assertEquals(2, fromRomanNumeral("II"));
    assertEquals(10, fromRomanNumeral("VV"));
    assertEquals(20, fromRomanNumeral("XX"));
    assertEquals(100, fromRomanNumeral("LL"));
    assertEquals(200, fromRomanNumeral("CC"));
    assertEquals(1000, fromRomanNumeral("DD"));
    assertEquals(2000, fromRomanNumeral("MM"));
  }

  @Test
  public void testThreeSame() {
    assertEquals(3, fromRomanNumeral("III"));
    assertEquals(15, fromRomanNumeral("VVV"));
    assertEquals(30, fromRomanNumeral("XXX"));
    assertEquals(150, fromRomanNumeral("LLL"));
    assertEquals(300, fromRomanNumeral("CCC"));
    assertEquals(1500, fromRomanNumeral("DDD"));
    assertEquals(3000, fromRomanNumeral("MMM"));
  }

  @Test
  public void testDecreasing() {
    assertEquals(6, fromRomanNumeral("VI"));
  }

  @Test
  public void testDecreasingByTwo() {
    assertEquals(11, fromRomanNumeral("XI"));
  }

  @Test
  public void testIncreasing() {
    assertEquals(4, fromRomanNumeral("IV"));
  }

  @Test
  public void testMultipleDecrements() {
    assertEquals(7, fromRomanNumeral("IIIX"));
  }

  @Test
  public void test182() {
    assertEquals(182, fromRomanNumeral("CLXXXII"));
  }

  @Test
  public void test342() {
    assertEquals(342, fromRomanNumeral("CCCXLII"));
  }

  @Test
  public void test1984() {
    assertEquals(1984, fromRomanNumeral("MCMLXXXIV"));
  }

  @Test
  public void getPossibleDigitsFor4() {
    assertArrayEquals(
        new RomanNumeralDigit[] {new RomanNumeralDigit(null, I), new RomanNumeralDigit(I, V)},
        getPossibleDigitsFor(4, new DLVStatus(), null).toArray());
  }

  @Test
  public void testProblemGreedy() throws Exception {
    P89 solution = new P89(new GreedyMinifier());

    long answer = getProblemAnswer(solution);

    System.out.println("Got answer " + answer);
  }

  private static long getProblemAnswer(P89 solution) throws Exception {
    long answer = 0;

    try (BufferedReader r = getProblemSetReader()) {
      answer =
          r.lines()
              .mapToLong(
                  line -> {
                    String minForm = solution.toMinimalForm(line);
                    System.out.println("Got min form " + minForm + " for line " + line);
                    long lineDiff = line.length() - minForm.length();
                    if (lineDiff < 0) {
                      throw new RuntimeException(
                          "Found minified version longer than input at " + line);
                    }
                    return lineDiff;
                  })
              .sum();
    }
    return answer;
  }

  private static BufferedReader getProblemSetReader() {
    InputStream stream = P89Test.class.getClassLoader().getResourceAsStream("p89/romans.txt");
    return new BufferedReader(new InputStreamReader(stream, Charsets.UTF_8));
  }
}
