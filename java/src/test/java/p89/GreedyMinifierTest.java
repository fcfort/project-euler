package p89;

import com.google.common.collect.ImmutableMap;
import org.junit.Test;

import java.util.Arrays;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class GreedyMinifierTest {

  private static final Map<String, String> TEST_CASES = ImmutableMap.of("XXXXVIIII", "XLIX");

  private static final GreedyMinifier MINIFIER = new GreedyMinifier();

  @Test
  public void testCases() {
    P89 soln = new P89(MINIFIER);

    for (Map.Entry<String, String> e : TEST_CASES.entrySet()) {
      assertEquals(e.getValue(), soln.toMinimalForm(e.getKey()));
    }
  }

  @Test
  public void testSimplifySingleDigit() {
    Arrays.stream(RomanNumeral.values())
        .forEach(rn -> assertEquals(rn.name(), MINIFIER.minify(rn.getValue())));
  }

  @Test
  public void testSimplifyFourToIV() {
    assertEquals("IV", MINIFIER.minify(4));
  }

  @Test
  public void testSimplify6ToVI() {
    assertEquals("VI", MINIFIER.minify(6));
  }

  @Test
  public void testSimplify56ToLVI() {
    assertEquals("LVI", MINIFIER.minify(56));
  }

  @Test
  public void testSimplifySixteenToXVI() {
    assertEquals("XVI", MINIFIER.minify(16));
  }

  @Test
  public void testSimplifyNineteenToXIX() {
    assertEquals("XIX", MINIFIER.minify(19));
  }

  @Test
  public void testSimplify49ToXLIX() {
    assertEquals("XLIX", MINIFIER.minify(49));
  }

  @Test
  public void testSimplify1606ToMDCVI() {
    assertEquals("MDCVI", MINIFIER.minify(1606));
  }
}
