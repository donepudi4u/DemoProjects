package com.jazz.str.vo;

import java.util.List;

public class RichTextFieldVo {

	private String textValue;
	private List<String> imageFiles;
	private List<String> attachementFiles;
	private List<String> Attachments;
	private String SCMRecord;
	private String PostCompletionComments;
	
	public RichTextFieldVo(String textValue, List<String> imageFiles, List<String> attachementFiles,List<String> Attachments,String SCMRecord , String PostCompletionComments) {
		super();
		this.textValue = textValue;
		this.imageFiles = imageFiles;
		this.attachementFiles = attachementFiles;
		this.Attachments = Attachments;
		this.SCMRecord = SCMRecord;
		this.PostCompletionComments = PostCompletionComments;
	}
	
	public RichTextFieldVo(List<String> Attachments) {
		this.Attachments = Attachments;
	}
	
	public RichTextFieldVo(String SCMRecord) {
		this.SCMRecord = SCMRecord;
	}
	
	public RichTextFieldVo(String SCMRecord,String PostCompletionComments) {
		this.SCMRecord =SCMRecord;
		this.PostCompletionComments = PostCompletionComments;
	}
	
	public String getTextValue() {
		return textValue;
	}
	public void setTextValue(String textValue) {
		this.textValue = textValue;
	}
	public List<String> getImageFiles() {
		return imageFiles;
	}
	public void setImageFiles(List<String> imageFiles) {
		this.imageFiles = imageFiles;
	}
	public List<String> getAttachementFiles() {
		return attachementFiles;
	}
	public void setAttachementFiles(List<String> attachementFiles) {
		this.attachementFiles = attachementFiles;
	}

	public List<String> getAttachments() {
		return Attachments;
	}

	public void setAttachments(List<String> attachments) {
		Attachments = attachments;
	}
	

	public String getSCMRecord() {
		return SCMRecord;
	}

	public void setSCMRecord(String sCMRecord) {
		SCMRecord = sCMRecord;
	}

	
	public String getPostCompletionComments() {
		return PostCompletionComments;
	}

	public void setPostCompletionComments(String postCompletionComments) {
		PostCompletionComments = postCompletionComments;
	}

	@Override
	public String toString() {
		return "RichTextFieldVo [textValue=" + textValue + ", imageFiles=" + imageFiles + ", attachementFiles="
				+ attachementFiles + ", Attachments=" + Attachments + ", SCMRecord=" + SCMRecord
				+ ", PostCompletionComments=" + PostCompletionComments + "]";
	}
}
