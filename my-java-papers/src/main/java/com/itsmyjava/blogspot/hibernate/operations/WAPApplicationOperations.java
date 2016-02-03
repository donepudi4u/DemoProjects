package com.itsmyjava.blogspot.hibernate.operations;

import java.util.List;

import org.hibernate.Criteria;

import com.itsmyjava.blogspot.hibernate.common.HibernateConfiguration;
import com.itsmyjava.blogspot.hibernate.vo.WapApplication;

public class WAPApplicationOperations extends HibernateConfiguration {

	@SuppressWarnings("unchecked")
	public List<WapApplication> getApplicationDetails() {
		//String sql = "From WapApplication";
		Criteria criteria = getHibernateCriteria(WapApplication.class);
		//criteria.add(Restrictions.eq("applicationId", "WET"));
		criteria.setFirstResult(1);
		criteria.setMaxResults(4);
//		return (List<WapApplication>) queryForList(sql);
		return (List<WapApplication>) queryForList(criteria);
	}

}
