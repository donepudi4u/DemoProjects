package com.itsmyjava.blogspot.hibernate.vo;

import java.io.Serializable;

public class WapApplication implements Serializable {

	private static final long serialVersionUID = 1L;
	private String applicationId;
	private String applicationDesc;

	public String getApplicationId() {
		return applicationId;
	}

	public void setApplicationId(String applicationId) {
		this.applicationId = applicationId;
	}

	public String getApplicationDesc() {
		return applicationDesc;
	}

	public void setApplicationDesc(String applicationDesc) {
		this.applicationDesc = applicationDesc;
	}

	@Override
	public String toString() {
		return "WapApplication [applicationId=" + applicationId
				+ ", applicationDesc=" + applicationDesc + "]";
	}

}
