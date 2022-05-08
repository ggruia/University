package menus;

import java.util.ArrayList;
import java.util.Map;

public class Help {
    public Help () {}

    public static void printHelp(String context, Map<String, String> map) {
        var keys = new ArrayList<>(map.keySet());
        int maxLen = keys.stream().map(String::length).max(Integer::compareTo).get();

        // help!
        System.out.println();
        System.out.printf("< %s >%n", context.toUpperCase());
        System.out.println("=".repeat(context.length() + 4));
        for (int i = 0; i < keys.size(); i++) {
            var spaces1 = " ".repeat((int) Math.log10(keys.size()) - (int) Math.log10(i + 1));
            var spaces2 = " ".repeat(maxLen - keys.get(i).length());
            System.out.printf("%d. %s%s%s - %s%n", i + 1, spaces1, keys.get(i), spaces2, map.get(keys.get(i)));
        }
        System.out.println("? - help");
        System.out.println("! - exit");
        System.out.println();
    }
}
