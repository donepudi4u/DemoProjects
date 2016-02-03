package com.prokarma.spring;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


public class DesignationMain {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext(
				"context.xml");
		DesignationDAO designationDAO = (DesignationDAO) context
				.getBean("designationDAO");
		Designation myBean = new Designation(1, "KapilSingh",
				"Java Programmer");
	//	designationDAO.insertDesignation(myBean);
		System.out.println(designationDAO.selectDesignation(1));
	}

}
