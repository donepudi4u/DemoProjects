package com.itsmyjava.blogspot.hibernate.operations;

import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;

import com.itsmyjava.blogspot.hibernate.vo.WapEquipment;

public class WapEquipmentTableOperationsTest {
	WapEquipmentTableOperations equipmentTableOperations = new WapEquipmentTableOperations();

	@Ignore
	public void wapEquipmentTable() {
		equipmentTableOperations = new WapEquipmentTableOperations();
		WapEquipment wapEquipmentTable = equipmentTableOperations
				.getWapEquipmenDetailsUsingCompositekey();
		Assert.assertNotNull(wapEquipmentTable);
	}

	@Ignore
	public void getWapEquipmentCompleteValues() {
		equipmentTableOperations.getWapEquipmentCompleteValues();
	}

	@Ignore
	public void getWapEquipmentDataByQuery() {
		Assert.assertNotNull(equipmentTableOperations.getWapEquipmentDataByQuery());
	}

	@Ignore
	public void getWapEquipmentDataByQueryUsingpagination() {
		Assert.assertNotNull(equipmentTableOperations.getWapEquipmentDataByQueryUsingpagination());
	}

	@Test
	public void getEquipmentDetailsByUserNameAndApplicationID() {
		Assert.assertNotNull(equipmentTableOperations.getEquipmentDetailsByUserNameAndApplicationID());
	}

}
