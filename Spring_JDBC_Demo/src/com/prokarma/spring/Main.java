package com.prokarma.spring;

import javax.sql.DataSource;

import org.springframework.context.ApplicationContext;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import org.springframework.jdbc.core.JdbcTemplate;

class Main {

	public static void main(String args[]) throws Exception {

		ApplicationContext ac = new ClassPathXmlApplicationContext(

		"context.xml");

		// DataSource dataSource = (DataSource) ac.getBean("dataSource");

		DataSource dataSource = (DataSource) ac.getBean("dataSource");

		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

		System.out.println(jdbcTemplate.queryForList(

		"select id from stu_rec", Long.class));

	}

}