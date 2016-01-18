package com.myjavapapers.dozer.beans;

public class SpottingInstruction {
	private int priorityNumber;
	private String spottingInstructionTypeCode;
	private InterchangeInstruction interchangeInstruction;

	public int getPriorityNumber() {
		return priorityNumber;
	}

	public void setPriorityNumber(int priorityNumber) {
		this.priorityNumber = priorityNumber;
	}

	public String getSpottingInstructionTypeCode() {
		return spottingInstructionTypeCode;
	}

	public void setSpottingInstructionTypeCode(
			String spottingInstructionTypeCode) {
		this.spottingInstructionTypeCode = spottingInstructionTypeCode;
	}

	public InterchangeInstruction getInterchangeInstruction() {
		return interchangeInstruction;
	}

	public void setInterchangeInstruction(
			InterchangeInstruction interchangeInstruction) {
		this.interchangeInstruction = interchangeInstruction;
	}

}
