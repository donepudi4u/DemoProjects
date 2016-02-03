package com.itsmyjava.blogspot.spring.ioc;

public class EmployeeBean extends PersonBean {

	private String companyName;

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

}
