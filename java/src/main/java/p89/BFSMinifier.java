package p89;

import javax.annotation.Nullable;
import java.util.*;

import static p89.P89.getPossibleDigitsFor;

final class BFSMinifier implements Minifier {
  @Override
  public String minify(long value) {
    return toMinimalRomanNumeral(value);
  }

  static String toMinimalRomanNumeral(long value) {
    Queue<QueueObject> q = new LinkedList<>();
    q.offer(new QueueObject(value, "", new DLVStatus(), null));

    Set<String> possibleSolutions = new HashSet<>();

    String minSolution = null;

    while (!q.isEmpty()) {
      QueueObject node = q.remove();
      if (minSolution != null && node.soFar.length() > 2 * minSolution.length()) {
        // do nothing here, too deep
      } else if (node.value == 0) {
        // We've only found one possible solution of many since the search is not smart enough to
        // know that
        // it has decreased optimally towards the shortest soln.
        // E.g. MCMCMCMCMLIXIXIV is equally valid as MMMMDCLXXII
        //        System.out.println("Got answer: " + node.soFar);
        possibleSolutions.add(node.soFar);
        if (minSolution == null || node.soFar.length() < minSolution.length()) {
          minSolution = node.soFar;
        }
      } else if (node.value < 0) {
        // do nothing, we should ignore this node since it can't be a possible soln
      } else if (node.value > 0) {
        // Add the next possible RNs, including one greater than the number to the graph
        //        System.out.println(
        //            "At "
        //                + node.soFar
        //                + " Got possible children: "
        //                + getPossibleDigitsFor(node.value, node.dlvStatus, node.prevDigit));
        for (RomanNumeralDigit rnd :
            getPossibleDigitsFor(node.value, node.dlvStatus, node.prevDigit)) {
          DLVStatus newDLVStatus = node.dlvStatus.copy();
          if (DLVStatus.DLV.contains(rnd.getSecond())) {
            newDLVStatus.use(rnd.getSecond());
          }
          q.offer(
              new QueueObject(
                  node.value - rnd.getValue(), node.soFar + rnd.asString(), newDLVStatus, rnd));
        }
      }
    }

    if (possibleSolutions.isEmpty()) {
      throw new RuntimeException("Could not find soln for " + value);
    }

    return Collections.min(possibleSolutions);
  }

  private static class QueueObject {
    final long value;
    final String soFar;
    final DLVStatus dlvStatus;
    final @Nullable RomanNumeralDigit prevDigit;

    QueueObject(
        long value, String soFar, DLVStatus dlvStatus, @Nullable RomanNumeralDigit prevDigit) {
      this.value = value;
      this.soFar = soFar;
      this.dlvStatus = dlvStatus;
      this.prevDigit = prevDigit;
    }

    @Override
    public String toString() {
      return "["
          + value
          + "],["
          + soFar
          + "]["
          + dlvStatus.toString()
          + "]["
          + (prevDigit == null ? "null" : prevDigit.asString())
          + "]";
    }
  }
}
