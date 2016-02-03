package com.myjavapapers.utils;

import java.util.Date;


public class NullPointerCheck {
	public static void main(String[] args) {
		Object[] objs = new Object[] {"ABC" , null, new Date()};
		for (Object object : objs) {
			System.out.println(object);
		}
	}

}
