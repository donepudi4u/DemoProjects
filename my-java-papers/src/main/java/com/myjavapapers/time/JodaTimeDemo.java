package com.myjavapapers.time;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.Duration;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import com.myjavapapers.utils.DateUtilityTest;

public class JodaTimeDemo {

	public static void main(String[] args) {
		//Duration duration = new Duration(1413293111948L,System.currentTimeMillis());
		//long duration = System.currentTimeMillis(); // 1413293111948
	//	System.out.println(duration); MM/dd/yyyy
	//	System.out.println(Duration.standardDays(System.currentTimeMillis() - (DateUtilityTest.getCalendarFromString("10/09/2014").getTimeInMillis())));
		
		//System.out.println(getDate(new Date().toString(), "YYYY-MM-DD:HH:MM:SS"));
		printDate();

	}
	
	public static Date getDate(final String dateTimeS, final String format) {
		if (StringUtils.isEmpty(dateTimeS)) {
			return null;
		}
		DateTimeFormatter fmt	= DateTimeFormat.forPattern(format);
		DateTime dateTime		= fmt.parseDateTime(dateTimeS);

		return dateTime.toDate();
	}
	
	private static void printDate(){
	 try {
		 SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yy hh:mm a");
			String dateInString = "9/16/14 1:07 PM";
		 
			Date date = formatter.parse(dateInString);
			System.out.println(date);
			System.out.println(formatter.format(date));
	 
		} catch (ParseException e) {
			e.printStackTrace();
		}

	 
 }
	
}
