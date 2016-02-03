package com.prokarma.spring;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;

public class DesignationQuery implements DesignationDAO {

	
	

	@SuppressWarnings("unchecked")
	public void insertDesignation(Designation dsg) {
		ApplicationContext context = new ClassPathXmlApplicationContext("context.xml");
		NamedParameterJdbcTemplate namedParameterJdbcTemplate = (NamedParameterJdbcTemplate) context.getBean("jdbcTemplet");
		String query = "INSERT INTO DESIGNATION (ID, NAME, DESIGNATION) VALUES (:Id,:name,:Desig)";
		Map namedParameters = new HashMap();
		namedParameters.put("Id", Integer.valueOf(dsg.getId()));
		namedParameters.put("name", dsg.getname());
		namedParameters.put("Desig", dsg.getDesig());
		
		namedParameters.put("Id", 4);
		namedParameters.put("name","YYY");
		namedParameters.put("Desig", "Develop");
		namedParameterJdbcTemplate.update(query, namedParameters);
		
		
		
	}

	@SuppressWarnings("unchecked")
	public Designation selectDesignation(int Id) {
		ApplicationContext context = new ClassPathXmlApplicationContext("context.xml");
		NamedParameterJdbcTemplate namedParameterJdbcTemplate = (NamedParameterJdbcTemplate) context.getBean("jdbcTemplet");
		String query = "SELECT * FROM DESIGNATION WHERE ID=:Id";
		SqlParameterSource namedParameters = new MapSqlParameterSource("Id",
				Integer.valueOf(Id));

		return (Designation) namedParameterJdbcTemplate.queryForObject(query,namedParameters, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						return new Designation(resultSet.getInt("ID"),
								resultSet.getString("NAME"), resultSet
										.getString("DESIGNATION"));
					}
				});
	}

}
