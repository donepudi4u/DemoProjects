package com.myjavapapers.utils;

import org.apache.commons.lang.StringUtils;

public class MyStringUtils {

	public static void main(String[] args) {
		testSplit();
		// System.out.println(Float.valueOf("7.0"));
		// System.out.println(Integer.getInteger("7"));
		// System.out.println(StringUtils.removeEndIgnoreCase("7.0", ".0"));

	}

	private static void testSplit() {
		String[] parameters = { "FALSE", "TRUE" };
		System.out.println(StringUtils.split(null, ","));
		boolean boolean1 = Boolean.getBoolean(parameters[1]);
		System.out.println("Boolean :  "+boolean1);
		if(Boolean.getBoolean(parameters[1]) ){
			System.out.println("Inside TRUE****");
		}

		if (new Boolean(parameters[1])) {
			System.out.println("Inside TRUE");
		}
	}
}
