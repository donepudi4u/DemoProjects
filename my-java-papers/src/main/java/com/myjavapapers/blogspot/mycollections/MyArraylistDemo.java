package com.myjavapapers.blogspot.mycollections;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

public class MyArraylistDemo {
	
	public static void main(String[] args) {
		MyArraylistDemo demo = new MyArraylistDemo();
		demo.printList();
		
	}

	public void printList(){
		List<String> empNum = new ArrayList<String>();
		empNum.add("Emp001");
		empNum.add("Emp002");
		empNum.add("Emp003");
		empNum.add("Emp004");
		empNum.add("Emp005");
		empNum.add("Emp00");
		empNum.add("Emp001");
		
		//System.out.println(empNum.toString().replace("[", "").replace("]","").replace(" ", ""));
		
		String empNumListByCommaSeparated = StringUtils.join(empNum, ",");
		System.out.println(empNumListByCommaSeparated);
	}
}
