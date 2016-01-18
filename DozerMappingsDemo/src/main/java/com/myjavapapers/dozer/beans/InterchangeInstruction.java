package com.myjavapapers.dozer.beans;

public class InterchangeInstruction {
	private int id;
	private String interchangeCarrier;
	private String switchCarrier;
	private SystemStation systemStation;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getInterchangeCarrier() {
		return interchangeCarrier;
	}

	public void setInterchangeCarrier(String interchangeCarrier) {
		this.interchangeCarrier = interchangeCarrier;
	}

	public String getSwitchCarrier() {
		return switchCarrier;
	}

	public void setSwitchCarrier(String switchCarrier) {
		this.switchCarrier = switchCarrier;
	}

	public SystemStation getSystemStation() {
		return systemStation;
	}

	public void setSystemStation(SystemStation systemStation) {
		this.systemStation = systemStation;
	}

}
