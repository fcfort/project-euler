package p89;

import org.junit.Test;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertFalse;

public class DLVStatusTest {
  @Test
  public void testDlvStartsAllUnused() {
    DLVStatus d = new DLVStatus();

    assertFalse(d.hasUsed(RomanNumeral.D));
    assertFalse(d.hasUsed(RomanNumeral.L));
    assertFalse(d.hasUsed(RomanNumeral.V));
  }

  @Test
  public void testUseD() {
    DLVStatus d = new DLVStatus();
    d.use(RomanNumeral.D);

    assertTrue(d.hasUsed(RomanNumeral.D));
    assertFalse(d.hasUsed(RomanNumeral.L));
    assertFalse(d.hasUsed(RomanNumeral.V));
  }

  @Test
  public void testUseL() {
    DLVStatus d = new DLVStatus();
    d.use(RomanNumeral.L);

    assertFalse(d.hasUsed(RomanNumeral.D));
    assertTrue(d.hasUsed(RomanNumeral.L));
    assertFalse(d.hasUsed(RomanNumeral.V));
  }

  @Test
  public void testUseV() {
    DLVStatus d = new DLVStatus();
    d.use(RomanNumeral.V);

    assertFalse(d.hasUsed(RomanNumeral.D));
    assertFalse(d.hasUsed(RomanNumeral.L));
    assertTrue(d.hasUsed(RomanNumeral.V));
  }
}
