package com.itsmyjava.blogspot.hibernate.vo;

import java.io.Serializable;

public class WapEquipment implements Serializable {

	private static final long serialVersionUID = 1L;

	private String queryName;
	private String userID;
	private String ApplicationId;
	private String equipmentInitial;
	private String equipmentNumber;
	private Integer equipmentSortSequence;

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getQueryName() {
		return queryName;
	}

	public void setQueryName(String queryName) {
		this.queryName = queryName;
	}

	public String getApplicationId() {
		return ApplicationId;
	}

	public void setApplicationId(String applicationId) {
		ApplicationId = applicationId;
	}

	public String getEquipmentInitial() {
		return equipmentInitial;
	}

	public void setEquipmentInitial(String equipmentInitial) {
		this.equipmentInitial = equipmentInitial;
	}

	public String getEquipmentNumber() {
		return equipmentNumber;
	}

	public void setEquipmentNumber(String equipmentNumber) {
		this.equipmentNumber = equipmentNumber;
	}

	public Integer getEquipmentSortSequence() {
		return equipmentSortSequence;
	}

	public void setEquipmentSortSequence(Integer equipmentSortSequence) {
		this.equipmentSortSequence = equipmentSortSequence;
	}

	@Override
	public String toString() {
		return "WapEquipment [queryName=" + queryName + ", userID=" + userID
				+ ", ApplicationId=" + ApplicationId + ", equipmentInitial="
				+ equipmentInitial + ", equipmentNumber=" + equipmentNumber
				+ ", equipmentSortSequence=" + equipmentSortSequence + "]";
	}
	
	

}
