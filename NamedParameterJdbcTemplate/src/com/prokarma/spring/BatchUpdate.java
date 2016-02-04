package com.prokarma.spring;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;

public class BatchUpdate {

	public void doBatch() {
		final int count = 2;
		XmlBeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource(
				"context.xml"));
		String query = "insert into stu_rec (id, name, gender,branch) values (:id, :name, :gender, :branch)";
		Map map = new HashMap();
		map.put("id", "1010");
		map.put("name", "FFF");
		map.put("gender", "Female");
		map.put("branch", "MBA");

		NamedParameterJdbcTemplate jdbcTemplate = (NamedParameterJdbcTemplate) beanFactory
				.getBean("jdbcTemplet");
		jdbcTemplate.update(query, map);
		System.out.println("Values inserted sucessfuly" + map);
		String query2 = "update stu_rec set name='XXXX' where branch=:branch";
		SqlParameterSource paramSource = new MapSqlParameterSource("branch",
				"Computers");
		jdbcTemplate.update(query2, paramSource);
		System.out.println("update is success");

	}

}
