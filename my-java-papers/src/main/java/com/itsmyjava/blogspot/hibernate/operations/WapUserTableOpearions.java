package com.itsmyjava.blogspot.hibernate.operations;

import com.itsmyjava.blogspot.hibernate.common.HibernateConfiguration;
import com.itsmyjava.blogspot.hibernate.vo.WapUser;

public class WapUserTableOpearions extends HibernateConfiguration {

	public void wapUserTableGetOperation() {
		try {
			WapUser user = (WapUser)get(WapUser.class, "xprk791");
			System.out.println(user.getUserId());
			System.out.println(user.getFirmNum());
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	
	public void insertDataToUserTable(){
		 WapUser user2 = new WapUser(); 
		 user2.setUserId("xprk791");
		 user2.setFirmNum(187049); 
		 save(user2);
		 commitTransaction();
		 
	}
}
