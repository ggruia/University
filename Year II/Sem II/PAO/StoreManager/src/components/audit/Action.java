package components.audit;

import java.time.LocalDate;

public class Action {
    private final String context;
    private final String action;
    private final LocalDate date;

    public Action(String context, String action, LocalDate date) {
        this.context = context;
        this.action = action;
        this.date = date;
    }

    public Action(String context, String action) {
        this.context = context;
        this.action = action;
        this.date = null;
    }

    @Override
    public String toString() {
        return String.format("Audit (context: %s, action: %s, date: %s)",
                getContext(), getAction(), getDate());
    }

    public String getContext() {
        return context;
    }
    public String getAction() {
        return action;
    }
    public LocalDate getDate() {
        return date;
    }
}
