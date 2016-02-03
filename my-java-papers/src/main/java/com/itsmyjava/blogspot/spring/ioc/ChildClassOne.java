package com.itsmyjava.blogspot.spring.ioc;

import java.util.Calendar;

public class ChildClassOne extends BaseClassOne {

	@Override
	public String getName() {

		return "This is Child Class One";
	}
	
	public void getDisplayDate(){
		System.out.println(getDateUtility().getDateTime24String(Calendar.getInstance()));
	}

}
