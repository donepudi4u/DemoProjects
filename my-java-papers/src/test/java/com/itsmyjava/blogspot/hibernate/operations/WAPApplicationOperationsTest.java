package com.itsmyjava.blogspot.hibernate.operations;

import java.util.List;

import org.junit.Test;

import com.itsmyjava.blogspot.hibernate.vo.WapApplication;

public class WAPApplicationOperationsTest {
	WAPApplicationOperations applicationOperations = new WAPApplicationOperations();
	
	@Test
	public void testGetApplicationDetails() {
		List<WapApplication> applicationDetails = applicationOperations.getApplicationDetails();
		for (WapApplication wapApplication : applicationDetails) {
			System.out.println(wapApplication);
		}
	}

}
