package com.itsmyjava.blogspot.hibernate.operations;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.itsmyjava.blogspot.hibernate.common.HibernateConfiguration;
import com.itsmyjava.blogspot.hibernate.vo.WapEquipment;

public class WapEquipmentTableOperations extends HibernateConfiguration {

	public WapEquipment getWapEquipmenDetailsUsingCompositekey() {
		WapEquipment equipment = new WapEquipment();
		equipment.setQueryName("CARS IN YARD");
		equipment.setUserID("IGEN005");
		equipment.setApplicationId("WET");
		equipment.setEquipmentInitial("UP");
		equipment.setEquipmentNumber("84511");
		WapEquipment equipmentResults = (WapEquipment) get(WapEquipment.class,
				equipment);
		System.out.println(equipmentResults);
		return equipmentResults;
	}

	@SuppressWarnings("unchecked")
	public void getWapEquipmentCompleteValues() {
		List<WapEquipment> wapEquipmentList = (List<WapEquipment>)list(WapEquipment.class);
		for (WapEquipment wapEquipment : wapEquipmentList) {
			System.out.println(wapEquipment);
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<WapEquipment> getWapEquipmentDataByQuery(){
		String sqlQuery = "From WapEquipment E where E.userID = 'XPRK791'";
		List<WapEquipment> equipmentDetailsList = (List<WapEquipment>)queryForList(sqlQuery);
		for (WapEquipment wapEquipment : equipmentDetailsList) {
			System.out.println(wapEquipment);
		}
		return equipmentDetailsList;
	}

	@SuppressWarnings("unchecked")
	public List<WapEquipment> getWapEquipmentDataByQueryUsingpagination(){
		String sqlQuery = "From WapEquipment E where E.userID = 'XPRK791'";
		Query query = getHibernateQuery(sqlQuery);
		query.setFirstResult(1);
		query.setMaxResults(10);
		List<WapEquipment> equipmentDetailsList = (List<WapEquipment>)queryForList(query);
		for (WapEquipment wapEquipment : equipmentDetailsList) {
			System.out.println(wapEquipment);
		}
		return equipmentDetailsList;
	}
	
	@SuppressWarnings("unchecked")
	public List<WapEquipment> getEquipmentDetailsByUserNameAndApplicationID(){
		Criteria criteria = getHibernateCriteria(WapEquipment.class);
		criteria.add(Restrictions.eq("userID", "XPRK791"));
		criteria.add(Restrictions.eq("queryName", "CHASISEVENTS"));
		// Adding order ascending /descending 
		criteria.addOrder(Order.desc("equipmentSortSequence"));
		// Adding projections
		//criteria.setProjection(Projections.sum("equipmentSortSequence"));	
		List<WapEquipment> equipmentList = (List<WapEquipment>)queryForList(criteria);
		//List equipmentList =  queryForList(criteria);
		 
		//System.out.println("Total Coint: " + equipmentList.get(0) );
		 
		for (WapEquipment wapEquipment : equipmentList) {
			System.out.println(wapEquipment);
		}		
		
		return equipmentList;
	}

}
