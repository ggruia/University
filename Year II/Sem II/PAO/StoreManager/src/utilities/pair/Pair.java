package utilities.pair;

public record Pair<T1, T2> (T1 first, T2 second) implements PairInterface<T1, T2> {

    @Override
    public String toString() {
        return String.format("Pair (first: %s, second: %s)",
                first().toString(), second().toString());
    }
}
