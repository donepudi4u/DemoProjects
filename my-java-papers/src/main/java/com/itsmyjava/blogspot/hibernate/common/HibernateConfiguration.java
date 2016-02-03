package com.itsmyjava.blogspot.hibernate.common;

import java.io.Serializable;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

public class HibernateConfiguration {
	private static SessionFactory sessionFactory;
	private static Session session;

	public SessionFactory getHibernateSessionFactory() {
		try {
			if(null == sessionFactory ){
				sessionFactory = new Configuration().configure("hibernate.cfg.xml")
						.buildSessionFactory();
			}
		} catch (Exception e) {
			System.out.println("Exception while creating session factory");
		}
		return sessionFactory;
	}

	public Session getHibernateSession() {
		if(null == session){
			session = getHibernateSessionFactory().openSession();
		}
		return session;
	}

	public Transaction beginHiberanteTransaction() {
		return getHibernateSession().beginTransaction();
	}

	public void commitTransaction() {
		getHibernateSession().getTransaction().commit();
	}
	
	public Object get(Class claz , Serializable id){
		return getHibernateSession().get(claz, id);
	}
	
	public void save(Object object){
		getHibernateSession().save(object);
	}
	
	public Criteria createCriteria(Class clazz){
		return getHibernateSession().createCriteria(clazz);
	}
	
	public List list(Class clazz){
		return createCriteria(clazz).list();
	}
	
	public void closeSession(){
		getHibernateSession().close();
	}
	
	public void clearSession(){
		getHibernateSession().clear();
	}
	
	public Query getHibernateQuery(String queryString){
		return getHibernateSession().createQuery(queryString);		
	}
	
	public List queryForList(String queryString){
		return getHibernateQuery(queryString).list();
	}

	public List queryForList(Query query){
		return query.list();
	}

	public List queryForList(Criteria criteria){
		return criteria.list();
	}
	
	public Criteria getHibernateCriteria(Class clazz){
		return getHibernateSession().createCriteria(clazz);
	}
}
