package com.myjavapapers.jms.main;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.itsmyjava.blogspot.spring.ioc.ChildClassTwo;
import com.itsmyjava.blogspot.spring.ioc.EmployeeBean;

public class MainClass {

	public static void main(String[] args) {
		 MainClass mainClass = new MainClass();
		 mainClass.loadBeans();
		//	testDateValue();
	}

	public static void testDateValue() {
		   int SECOND = 1000;
		   int MINUTE = 60 * SECOND;
		   int HOUR = 60 * MINUTE;
		   int DAY = 24 * HOUR;

		// TODO: this is the value in ms
		long ms = 8000000;
		StringBuffer text = new StringBuffer("");
		if (ms > DAY) {
		//	text.append(ms / DAY).append(":");
			ms %= DAY;
		}
		if (ms > HOUR) {
			text.append(ms / HOUR).append(":");
			ms %= HOUR;
		}
		if (ms > MINUTE) {
			text.append(ms / MINUTE).append("");
			ms %= MINUTE;
		}
		if (ms > SECOND) {
			//text.append(ms / SECOND).append(":");
			ms %= SECOND;
		}
		//text.append(ms + " ms");
		System.out.println(text.toString());

	}

	private static void getBeansCount() {
		ApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring-event-processor.xml");
		System.out.println("Number of beans Loaded:"+ applicationContext.getBeanDefinitionCount());
	}

	private void loadBeans() {
		ApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring-beans.xml");
		System.out.println(applicationContext.getBeanDefinitionCount());
		EmployeeBean employeeBean = (EmployeeBean) applicationContext.getBean("employeebean");
		System.out.println(employeeBean.getName());
		System.out.println(employeeBean.getCompanyName());
		System.out.println(employeeBean.getAge());

	}

}
