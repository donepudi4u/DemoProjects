package com.itsmyjava.blogspot.hibernate.operations;

import org.junit.Test;

public class WapUserTableOpearionsTest  {
	WapUserTableOpearions userTableOpearions = new WapUserTableOpearions();
	@Test
	public void wapUserTable() {
		userTableOpearions.wapUserTableGetOperation();
		
	}
	@Test
	public void insertDataToUserTable(){
		userTableOpearions.insertDataToUserTable();
	}
}
