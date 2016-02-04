package com.prokarma.spring;

import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

public class BatchUpdateMain {

	public static void main(String[] args) {

		XmlBeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource(
				"context.xml"));

		BatchUpdate myBean = (BatchUpdate) beanFactory.getBean("batchUpdate");

		myBean.doBatch();

	}

}
