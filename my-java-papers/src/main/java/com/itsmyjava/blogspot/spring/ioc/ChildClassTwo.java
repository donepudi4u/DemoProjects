package com.itsmyjava.blogspot.spring.ioc;

import java.util.Date;

public class ChildClassTwo extends BaseClassOne {

	@Override
	public String getName() {
		return "This is Child Class Two";
	}
	
	public void printDate(){
		getDateUtility();
		System.out.println(getDateUtility().getDateString(new Date()));
	}

}
