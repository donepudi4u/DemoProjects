package com.myjavapapers.utils;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;

/**
 * @author xprk300
 */
public class DateUtility implements Serializable
{

    private static final long serialVersionUID = 1L;
    static SimpleDateFormat standard = new SimpleDateFormat("MM/dd/yyyy");
    static SimpleDateFormat full24 = new SimpleDateFormat("MM/dd/yyyy HH:mm");
    static SimpleDateFormat enaFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    public static Calendar addDays(final Calendar date, final int days)
    {
        if (date == null)
        {
            return null;
        }
        final Calendar newDate = Calendar.getInstance();
        newDate.set(Calendar.DATE, date.get(Calendar.DATE));
        newDate.set(Calendar.MONTH, date.get(Calendar.MONTH));
        newDate.set(Calendar.YEAR, date.get(Calendar.YEAR));
        newDate.add(Calendar.DATE, days);
        return newDate;
    }

    public static boolean compareDate(final Calendar startDate, final Calendar endDate)
    {
        startDate.set(Calendar.HOUR_OF_DAY, 0);
        startDate.set(Calendar.MINUTE, 0);
        startDate.set(Calendar.SECOND, 0);
        startDate.set(Calendar.MILLISECOND, 0);

        endDate.set(Calendar.HOUR_OF_DAY, 0);
        endDate.set(Calendar.MINUTE, 0);
        endDate.set(Calendar.SECOND, 0);
        endDate.set(Calendar.MILLISECOND, 0);

        // if end date is before startDate return true
        if (endDate.before(startDate))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public static Calendar getCalendarFromDate(final Date date)
    {
        if (date == null)
            return null;
        final Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal;
    }

    public static Calendar getCalendarFromString(final String date)
    {
        final Calendar cal = Calendar.getInstance();
        cal.setTime(getDateFromString(date));
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal;
    }

    public static Date getDateFromString(final String dateString)
    {
        if (dateString == null)
        {
            return null;
        }
        Date date = null;
        try
        {
            date = standard.parse(dateString);
        }
        catch (final ParseException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return date;
    }

    public static String getDateString(final Calendar date)
    {
        if (date == null)
        {
            return null;
        }
        return standard.format(date.getTime());
    }

    public static String getDateString(final Date date)
    {
        if (date == null)
        {
            return null;
        }
        return standard.format(date);
    }

    public static String getDateTime24String(final Calendar date)
    {
        if (date == null)
        {
            return null;
        }
        return full24.format(date.getTime());
    }

    public static String getENADate()
    {
        final Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, 2);
        return enaFormat.format(cal.getTime());
    }

    public static String getFormatedDate(final Date date, final String format)
    {
        final SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        return dateFormat.format(date);
    }

    public static boolean isTodayFallInBetweenDates(final Calendar startDate, final Calendar endDate)
    {
        if (startDate == null || endDate == null)
        {
            return false;
        }
        final Calendar today = Calendar.getInstance();
        today.set(Calendar.SECOND, 0);
        today.set(Calendar.MILLISECOND, 0);
        startDate.set(Calendar.SECOND, 0);
        startDate.set(Calendar.MILLISECOND, 0);
        endDate.set(Calendar.SECOND, 0);
        endDate.set(Calendar.MILLISECOND, 0);
        if (today.equals(startDate) || today.equals(endDate) || (today.after(startDate) && today.before(endDate)))
        {
            return true;
        }
        return false;
    }

    public static boolean isValidDate(final String dateString)
    {
        standard.setLenient(false);
        try
        {
            standard.parse(dateString.trim());
        }
        catch (final ParseException pe)
        {
            return false;
        }
        return true;
    }

    public static String getDayDisplayString(final Date date) {
		if (date == null) {
			return StringUtils.EMPTY;
		}

		return DateTimeFormat.forPattern("yyyyMMddHHmmss").print(new DateTime(date));
	}
    
    public static String getDisplayString(final Date date) {
		return getDisplayString(date, null);
	}
    
    public static String getDisplayString(final Date date, final TimeZone timeZone) {
		return getDisplayString(date, timeZone, false);
	}
    public static String getDisplayString(final Date date, final TimeZone timeZone, final boolean isDisplayDateOnly) {
		DateTime dt	= null;

		if (date == null) {
			return StringUtils.EMPTY;
		}

		if (timeZone != null) {
			//dt = new DateTime(date, DateTimeZone.forID(timeZone.getTimeZoneId()));
		} else {
			dt = new DateTime(date);
		}

		if (isDisplayDateOnly) {
			return dt.toString(DateTimeFormat.shortDate());
		} else {
			return dt.toString(DateTimeFormat.shortDateTime());
		}
	}
    
}
