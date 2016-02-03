package com.myjavapapers.utils;

import static java.util.Calendar.DATE;
import static java.util.Calendar.DAY_OF_WEEK;
import static java.util.Calendar.HOUR_OF_DAY;
import static java.util.Calendar.LONG;
import static java.util.Calendar.MILLISECOND;
import static java.util.Calendar.MINUTE;
import static java.util.Calendar.MONTH;
import static java.util.Calendar.SECOND;
import static java.util.Calendar.SHORT;
import static java.util.Calendar.WEEK_OF_MONTH;
import static java.util.Calendar.YEAR;
import static java.util.Calendar.getInstance;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Map;

/**
 * This is a Utility class contains utility methods related to the Date and Calendar objects.
 * 
 * @author Chandra Sekhar Chaganti
 */
public class DateUtils
{

    /**
     * Convert factor for long time into integer time
     */
    public static final int LONG_TO_INT_CONVERTER = 1000;

    /**
     * Adds the given number of days to give date (or subtracts if it's a negative value) and returns a new Calendar
     * object. The passed-in calendar is not modified.
     * 
     * @param baseCal
     * @param dateOffset
     * @return
     */
    public static Calendar addDays(final Calendar baseCal, final int dateOffset)
    {
        final Calendar copy = (Calendar) baseCal.clone();
        copy.set(DATE, copy.get(DATE) + dateOffset);
        return copy;
    }

    public static Calendar addMonths(final Calendar baseCal, final int monthOffset)
    {
        final Calendar copy = (Calendar) baseCal.clone();
        copy.set(MONTH, copy.get(MONTH) + monthOffset);
        return copy;
    }

    /**
     * Utility method to calculate number of days between two given dates
     * 
     * @param startDate
     *            the starting date
     * @param endDate
     *            the ending date
     * @return the total number of days between the given dates
     */
    public static int diffInDays(final Date startDate, final Date endDate)
    {
        return (int) ((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24));

    }

    /**
     * Creates a calendar instance from the give Date object exactly as is. Time is preserved.
     * 
     * @param date
     * @return
     */
    public static Calendar getAsCalendar(final Date date)
    {
        if (date == null)
            return null;

        final Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        return cal;
    }

    public static Date getBackDate(final Date date, final int noOfDaysBack)
    {
        if (date != null)
        {
            final Date d = new Date();

            final long milli = date.getTime() - ((noOfDaysBack) * 86400 * 1000);

            d.setTime(milli);

            return d;
        }

        return new Date();
    }

    public static Date getBackDate(final int noOfDaysBack)
    {
        final Date d = new Date();

        return getBackDate(d, noOfDaysBack);
    }

    /**
     * Creates a calendar instance from the given date with the H, M, S, and ms times zeroed out.
     * 
     * @param date
     * @return
     */
    public static Calendar getCalendarWithoutTime(final Date date)
    {
        final Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        resetCalendarHMS(cal);
        return cal;
    }

    public static Calendar getCurrentMonth(final Locale locale)
    {
        return getInstance(locale);
    }

    public static Date getDate(final int year, final int month, final int date, final int hrs, final int min)
    {
        final Calendar c = new GregorianCalendar(year, month, date, hrs, min);
        return c.getTime();
    }

    /**
     * Helper method to return Date if a string containing date in MM/DD/YYYY format is passed as input
     * 
     * @param date1
     * @return Date
     */

    public static Date getDateFromString(final String date1)
    {
        int month = 0;
        int date = 0;
        int year = 0;
        if (date1 != null && date1.trim().length() > 0)
        {
            try
            {
                month = Integer.parseInt(date1.substring(0, 2));
                date = Integer.parseInt(date1.substring(3, 5));
                year = Integer.parseInt(date1.substring(6, 10));
                final Calendar resDate = Calendar.getInstance();
                resDate.set(year, month - 1, date, 0, 0, 0);
                resDate.set(Calendar.MILLISECOND, 0);
                return (resDate.getTime());

            }
            catch (final Exception e)
            {
                return null;
            }
        }
        return null;
    }

    public static String getDateString(final Date date, final String pattern)
    {
        String dateString = "";

        try
        {
            final SimpleDateFormat formater = new SimpleDateFormat(pattern);
            dateString = formater.format(date);
        }
        catch (final Exception e)
        {
            // Ignore and return "";
        }

        return dateString;
    }

    /**
     * Helper method to return Date with time if a string containing date in MM/dd/yyyy HH:mm:ss format is passed as
     * input
     * 
     * @param date1
     * @return Date
     */

    public static Date getDateTimeFromString(final String date1)
    {
        int month = 0;
        int date = 0;
        int year = 0;
        int minute = 0;
        int hrs = 0;
        int sec = 0;
        if (date1 != null && date1.trim().length() > 0)
        {
            try
            {
                month = Integer.parseInt(date1.substring(0, 2));
                date = Integer.parseInt(date1.substring(3, 5));
                year = Integer.parseInt(date1.substring(6, 10));
                hrs = Integer.parseInt(date1.substring(11, 13));
                minute = Integer.parseInt(date1.substring(14, 16));
                sec = Integer.parseInt(date1.substring(17, 19));
                final Calendar resDate = Calendar.getInstance();
                resDate.set(year, month - 1, date, 0, 0, 0);
                resDate.set(Calendar.MILLISECOND, 0);
                resDate.set(Calendar.SECOND, sec);
                resDate.set(Calendar.MINUTE, minute);
                resDate.set(Calendar.HOUR, hrs);
                return (resDate.getTime());

            }
            catch (final Exception e)
            {
                return null;
            }
        }
        return null;
    }

    /**
     * Helper method to return the Date with Maximum time i.e 23:59:59 from the given String which must be in the format
     * MM/DD/YYYY.
     * 
     * @param date1
     * @return
     */
    public static Date getDateWithMaxTimeFromString(final String date1)
    {
        int month = 0;
        int date = 0;
        int year = 0;
        if (date1 != null && date1.trim().length() > 0)
        {
            try
            {
                month = Integer.parseInt(date1.substring(0, 2));
                date = Integer.parseInt(date1.substring(3, 5));
                year = Integer.parseInt(date1.substring(6, 10));
                final Calendar resDate = Calendar.getInstance();
                resDate.set(year, month - 1, date, 0, 0, 0);
                resDate.add(Calendar.DAY_OF_MONTH, 1);
                resDate.add(Calendar.SECOND, -1);

                resDate.set(Calendar.MILLISECOND, 0);

                return (resDate.getTime());

            }
            catch (final Exception e)
            {
                return null;
            }
        }
        return null;
    }

    /**
     * Careful, this method resets ms, sec, and min, but not hour. I'm not sure if it's supposed to be like that, but I
     * don't want to change it and break anything. It's been like this a long time.
     * 
     * @param date
     * @return
     */
    public static Date getDateWithOutTimeStamp(final Date date)
    {
        try
        {
            final Calendar c1 = Calendar.getInstance();
            c1.setTime(date);
            c1.set(Calendar.MILLISECOND, 0);
            c1.set(Calendar.SECOND, 0);
            c1.set(Calendar.MINUTE, 0);
            return c1.getTime();
        }
        catch (final Exception e)
        {
            return null;
        }
    }

    public static Calendar getDayEndMoment(final Calendar cal)
    {
        final Calendar clone = (Calendar) cal.clone();
        clone.set(HOUR_OF_DAY, 23);
        clone.set(MINUTE, 59);
        clone.set(SECOND, 59);
        clone.set(MILLISECOND, 0); // ms must be 0, not 999, else SQL Timestamp jacks up
        return clone;
    }

    private static String getDayOfWeekName(final int dayOfWeek, final int style, final Locale locale)
    {
        final Calendar cal = Calendar.getInstance();

        final Map<String, Integer> displayNames = cal.getDisplayNames(DAY_OF_WEEK, style, locale);
        for (final String name : displayNames.keySet())
            if (displayNames.get(name) == dayOfWeek)
                return name;
        return null;
    }

    public static String getDayOfWeekName(final int dayOfWeek, final Locale locale)
    {
        return getDayOfWeekName(dayOfWeek, LONG, locale);
    }

    public static String getDayOfWeekNameAbbv(final int dayOfWeek, final Locale locale)
    {
        return getDayOfWeekName(dayOfWeek, SHORT, locale);
    }

    /**
     * Calculates the number of days between two calendar days in a manner which is independent of the Calendar type
     * used.
     * 
     * @param d1
     *            The first date.
     * @param d2
     *            The second date.
     * @return The number of days between the two dates. Zero is returned if the dates are the same, one if the dates are
     *         adjacent, etc. The order of the dates does not matter, the value returned is always >= 0. If Calendar
     *         types of d1 and d2 are different, the result may not be accurate.
     */
    public static int getDaysBetween(Calendar d1, Calendar d2, final boolean absoluteValue)
    {
        boolean datesSwapped = false;

        if (d1 != null && d2 != null)
        {
            if (d1.after(d2))
            { // swap dates so that d1 is start and d2 is end
                final java.util.Calendar temp = d1;
                d1 = d2;
                d2 = temp;
                datesSwapped = true;
            }
            int days = d2.get(java.util.Calendar.DAY_OF_YEAR) - d1.get(java.util.Calendar.DAY_OF_YEAR);
            final int y2 = d2.get(java.util.Calendar.YEAR);
            if (d1.get(java.util.Calendar.YEAR) != y2)
            {
                d1 = (java.util.Calendar) d1.clone();
                do
                {
                    days += d1.getActualMaximum(java.util.Calendar.DAY_OF_YEAR);
                    d1.add(java.util.Calendar.YEAR, 1);
                }
                while (d1.get(java.util.Calendar.YEAR) != y2);
            }

            if (datesSwapped && !absoluteValue)
                return -(days);
            else
                return days;
        }

        return 0;
    }

    /**
     * Returns no.of days between specified days. Result is always a positive number.
     */
    public static int getDaysBetween(final Date d1, final Date d2)
    {
        return getDaysBetween(d1, d2, true);
    }

    /**
     * Returns no.of days between specified days. If absoluteValue is true, result is always a positive number. If
     * absoluteValue is false, and d2 is less than d1 result would be negative.
     */
    public static int getDaysBetween(final Date d1, final Date d2, final boolean absoluteValue)
    {
        if (d1 != null && d2 != null)
        {
            final Calendar c1 = new GregorianCalendar();
            c1.setTime(d1);

            final Calendar c2 = new GregorianCalendar();
            c2.setTime(d2);

            return getDaysBetween(c1, c2, absoluteValue);
        }

        return 0;
    }

    public static int getDaysBetweenInclusive(final Date d1, final Date d2)
    {
        return getDaysBetween(d1, d2, true) + 1;
    }

    /**
     * Returns the start moment of the day as a new instance. Time info is zeroed out.
     * 
     * @param cal
     * @return
     */
    public static Calendar getDayStartMoment(final Calendar cal)
    {
        final Calendar clone = (Calendar) cal.clone();
        clone.set(HOUR_OF_DAY, 0);
        clone.set(MINUTE, 0);
        clone.set(SECOND, 0);
        clone.set(MILLISECOND, 0);
        return clone;
    }

    /**
     * Returns a new calendar instance set to the first day of the given month.
     * 
     * @param cal
     * @return
     */
    public static Calendar getFirstDayOfMonth(final Calendar cal)
    {
        final Calendar copy = (Calendar) cal.clone();
        copy.set(DATE, 1);
        return copy;
    }

    /**
     * Returns a Calendar instance that represents the first Sunday of the first week of the month, even if it's part of
     * the previous month. NOTE: This is Sunday-Saturday week specific! Example: For May 2012 input: May 1, 2012 is a
     * Tuesday, so this method would return Sunday, April 29, 2012, because it's the first day that would show on a real
     * calendar. For July 2012 input: July 1, 2012 is a Sunday, so this method would return the same day, July 1, 2012,
     * since it's the first day that would show on a real calendar.
     * 
     * @param cal
     * @return
     */
    public static Calendar getFirstDayOfSquareMonth(final Calendar cal)
    {
        final Calendar copy = getFirstDayOfMonth(cal);
        final int offset = -(getFirstDayOfWeekOfMonth(copy) - 1);
        return addDays(copy, offset);
    }

    /**
     * Returns the starting Sunday of the current week.
     * 
     * @param calendar
     * @return
     */
    public static Calendar getFirstDayOfWeek(final Calendar calendar)
    {
        return getAsCalendar(getFirstDayOfWeek(calendar.getTime()));
    }

    /**
     * this method will find current week start date of given date
     * 
     * @return dt Date
     */
    public static Date getFirstDayOfWeek(final Date date)
    {

        if (date == null)
            return null;

        final Calendar cal = Calendar.getInstance();
        cal.setTime(date);

        final int offset = cal.get(Calendar.DAY_OF_WEEK) - 1;
        cal.add(Calendar.DATE, -offset);

        resetCalendarHMS(cal);
        return cal.getTime();

    }

    /**
     * Returns the DAY_OF_WEEK that the given month starts on.
     * 
     * @param cal
     * @return
     */
    public static int getFirstDayOfWeekOfMonth(final Calendar cal)
    {
        return getFirstDayOfMonth(cal).get(DAY_OF_WEEK);
    }

    public static Date getFutureDate(final Date date, final int noOfDaysToAdd, final int noOfHourToAdd,
        final int noOfMinToADD, final int noOfSecToAdd)
    {
        if (date != null)
        {

            final Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            cal.add(Calendar.DATE, noOfDaysToAdd);
            cal.add(Calendar.HOUR, noOfHourToAdd);
            cal.add(Calendar.MINUTE, noOfMinToADD);
            cal.add(Calendar.SECOND, noOfSecToAdd);
            return cal.getTime();
        }

        return new Date();
    }

    /**
     * @return
     */
    public static Integer getIntTime()
    {
        return new Integer((int) (Calendar.getInstance().getTimeInMillis() / LONG_TO_INT_CONVERTER));
    }

    /**
     * Returns a new calendar instance set to the last day of the given month.
     * 
     * @param cal
     * @return
     */
    public static Calendar getLastDayOfMonth(final Calendar cal)
    {
        return addDays(getFirstDayOfMonth(addMonths(cal, 1)), -1);
    }

    /**
     * Returns a Calendar instance that represents the last Saturday of the last week of the month, even if it's part of
     * the next month. NOTE: This is Sunday-Saturday week specific! Example: For May 2012 input: May 31, 2012 is a
     * Thursday, so this method would return Saturday, June 2, 2012, because it's the last day that would show on a real
     * calendar. For June 2012 input: June 30, 2012 is a Saturday, so this method would return the same day, June 30,
     * 2012, since it's the last day that would show on a real calendar.
     * 
     * @param cal
     * @return
     */
    public static Calendar getLastDayOfSquareMonth(final Calendar cal)
    {
        final Calendar copy = getFirstDayOfSquareMonth(cal);
        return addDays(copy, getNumberOfWeeksInMonth(cal) * 7 - 1);
    }

    /**
     * Returns the ending Saturday of the current week.
     * 
     * @param calendar
     * @return
     */
    public static Calendar getLastDayOfWeek(final Calendar calendar)
    {
        final Calendar cal = (Calendar) calendar.clone();
        cal.add(Calendar.DATE, 7 - cal.get(Calendar.DAY_OF_WEEK));
        return cal;
    }

    /**
     * this method will find last week start date of given date
     * 
     * @return dt Date
     */
    public static Date getLastWeekStartDate(final Date dt)
    {
        try
        {
            Date lastWeekStartDate = null;
            final Calendar cal = Calendar.getInstance();
            cal.setTime(dt);
            final int dayofWeek = cal.get(Calendar.DAY_OF_WEEK);
// this will tell how many days to be reduced to get last week start date
            final int daysToReduce = dayofWeek + 6;
            cal.add(Calendar.DATE, -daysToReduce);
            final SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yyyy");
            lastWeekStartDate = fmt.parse(fmt.format(cal.getTime()));
            return lastWeekStartDate;

        }
        catch (final Exception ex)
        {
            return null;
        }
    }

    public static Calendar getMonthEndMoment(final Calendar selectedMonth)
    {
        final Calendar endTime = getFirstDayOfMonth(selectedMonth);

        // Add a month so it's the first of the next month
        endTime.add(MONTH, 1);

        // Subtract a day so it's the last day of the previous month
        endTime.add(DATE, -1);

        // Make it the end of the day
        endTime.set(HOUR_OF_DAY, 23);
        endTime.set(MINUTE, 59);
        endTime.set(SECOND, 59);
        endTime.set(MILLISECOND, 0); // ms must be 0, not 999, else SQL Timestamp jacks up
        return endTime;
    }

    public static Calendar getMonthStartMoment(final Calendar selectedMonth)
    {
        final Calendar endTime = getFirstDayOfMonth(selectedMonth);
        endTime.set(HOUR_OF_DAY, 0);
        endTime.set(MINUTE, 0);
        endTime.set(SECOND, 0);
        endTime.set(MILLISECOND, 0);

        return endTime;
    }

    public static Calendar getNextMonth(final Calendar reference)
    {
        final Calendar cal = (Calendar) reference.clone();
        cal.add(MONTH, 1);

        return cal;
    }

    public static int getNumberOfWeeksInMonth(final Calendar cal)
    {
        return cal.getActualMaximum(WEEK_OF_MONTH);
    }


    public static Calendar getPrevMonth(final Calendar reference)
    {
        final Calendar cal = (Calendar) reference.clone();
        cal.add(MONTH, -1);

        return cal;
    }

    public static Date getTrimmedDateWithoutTime(final Date date)
    {
        final String dateString = getDateString(date, "MM/dd/yyyy");
        return getDateFromString(dateString);
    }

    public static boolean inSameWeek(final Date date1, final Date date2)
    {
        final Calendar currentCal = getCalendarWithoutTime(date2);
        final int dayOfWeek = 7 - currentCal.get(Calendar.DAY_OF_WEEK);

        currentCal.add(Calendar.DATE, dayOfWeek);
        final Calendar calOne = getCalendarWithoutTime(date1);

        if (!calOne.after(currentCal))
        {
            return true;
        }

        return false;
    }


    public static boolean isSameDayMonthAndYear(final Calendar c1, final Calendar c2)
    {
        return (c1.get(DATE) == c2.get(DATE)) && (c1.get(MONTH) == c2.get(MONTH) && (c1.get(YEAR) == c2.get(YEAR)));
    }

    public static boolean isSameDayMonthAndYear(final Date d1, final Date d2)
    {
        return isSameDayMonthAndYear(getAsCalendar(d1), getAsCalendar(d2));
    }

    public static boolean isSameMonthAndYear(final Calendar c1, final Calendar c2)
    {
        return (c1.get(MONTH) == c2.get(MONTH) && (c1.get(YEAR) == c2.get(YEAR)));
    }

    public static boolean isSameMonthAndYear(final Date d1, final Date d2)
    {
        final Calendar c1 = Calendar.getInstance();
        c1.setTime(d1);

        final Calendar c2 = Calendar.getInstance();
        c2.setTime(d2);

        return isSameMonthAndYear(c1, c2);
    }

    /**
     * This is a helper method for the isThisBackDemand to check whether given date lies within last week
     * 
     * @param date
     *            the date for which the check is to be done
     * @return true if the given date lies with in last week and false otherwise
     */
    public static boolean isWithInLastWeek(final Date date)
    {
        final Calendar calendar = Calendar.getInstance();
        final long currentDays = calendar.getTime().getTime() / (1000 * 60 * 60 * 24);

        // System.out.println("Current Days : " + currentDays);

        final long weekBegnningDays = currentDays - calendar.get(Calendar.DAY_OF_WEEK) + 1;
        // System.out.println("Week Begnning Days : " + weekBegnningDays);

        final long lastWeekBeginningDays = weekBegnningDays - 7;
        // System.out.println("Last Week Beginning Days : " +
        // lastWeekBeginningDays);

        final long givenDateDays = date.getTime() / (1000 * 60 * 60 * 24);
        // System.out.println("Days in given Date : " + givenDateDays);

        if (givenDateDays >= lastWeekBeginningDays && givenDateDays < weekBegnningDays)
        {
            return true;
        }

        return false;
    }

    /**
     * Resets the hour, minute, second, millisecond fields to 0 for the given calendar. Returns the SAME instance;
     * 
     * @param cal
     */
    public static Calendar resetCalendarHMS(final Calendar cal)
    {
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal;
    }

    public static Calendar today()
    {
        return Calendar.getInstance();
    }
    
    public static void main(String[] args) {
    	System.out.println(getDateWithOutTimeStamp(Calendar.getInstance().getTime()));
	}

}
