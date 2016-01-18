package com.myjavapapers.dozer.beans;

public class GetOperatingInstructions {
	private Customer customer;

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	@Override
	public String toString() {
		return "GetOperatingInstructions [customer=" + customer + "]";
	}

}
