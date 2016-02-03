package com.prokarma.spring;

public class Designation {

	private int Id;
	private String name;
	private String Desig;

	public Designation(int Id, String name, String Desig) {
		this.Id = Id;
		this.name = name;
		this.Desig = Desig;
	}

	public int getId() {
		return Id;
	}

	public void setId(int Id) {
		this.Id = Id;
	}

	public String getname() {
		return name;
	}

	public void setname(String name) {
		this.name = name;
	}

	public String getDesig() {
		return Desig;
	}

	public void setDesig(String Desig) {
		this.Desig = Desig;
	}

	public String toString() {
		return Id + " " + name + " " + Desig;
	}

}