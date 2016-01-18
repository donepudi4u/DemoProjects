package com.myjavapapers.dozer.beans;

import java.util.ArrayList;
import java.util.List;

public class Customer {
	
	private int firmNnumber;
	private OperatingStation operatingStation;
	private boolean CSLCutover;
	private boolean orderX ;
	private List<SpottingInstruction> spottingInstructions = new ArrayList<SpottingInstruction>();
	public int getFirmNnumber() {
		return firmNnumber;
	}
	public void setFirmNnumber(int firmNnumber) {
		this.firmNnumber = firmNnumber;
	}
	public OperatingStation getOperatingStation() {
		return operatingStation;
	}
	public void setOperatingStation(OperatingStation operatingStation) {
		this.operatingStation = operatingStation;
	}
	public boolean isCSLCutover() {
		return CSLCutover;
	}
	public void setCSLCutover(boolean cSLCutover) {
		CSLCutover = cSLCutover;
	}
	public boolean isOrderX() {
		return orderX;
	}
	public void setOrderX(boolean orderX) {
		this.orderX = orderX;
	}
	public List<SpottingInstruction> getSpottingInstructions() {
		return spottingInstructions;
	}
	public void setSpottingInstructions(
			List<SpottingInstruction> spottingInstructions) {
		this.spottingInstructions = spottingInstructions;
	}

}
