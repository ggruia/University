package utilities.date;

import java.time.LocalDate;

public class DateService {
    private LocalDate currentDate;
    private static DateService instance = null;

    public DateService() {}

    public static DateService getInstance() {
        if (instance == null)
        {
            instance = new DateService();
            instance.currentDate = LocalDate.now();
        }
        return instance;
    }

    public LocalDate getDate() {
        return this.currentDate;
    }

    public void setDate(LocalDate currentDate) {
        this.currentDate = currentDate;
    }

    public void passDay() {
        setDate(getDate().plusDays(1));
    }

    public boolean hasPassed(LocalDate targetDate, int days) {
        if(targetDate.plusDays(days).isBefore(getDate()))
            return true;
        return false;
    }
}
