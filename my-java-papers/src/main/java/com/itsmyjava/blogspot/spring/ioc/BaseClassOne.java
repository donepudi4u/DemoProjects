package com.itsmyjava.blogspot.spring.ioc;

import com.myjavapapers.utils.DateUtility;

public abstract class BaseClassOne {
	
	public abstract String getName();
	
	private DateUtility dateUtility ;

	public DateUtility getDateUtility() {
		return dateUtility;
	}

	public void setDateUtility(DateUtility dateUtility) {
		this.dateUtility = dateUtility;
	}
	

}
