package com.itsmyjava.blogspot.hibernate.vo;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;

public class FileDetailsVO {

	private String fileName = StringUtils.EMPTY;
	private String workSheetName = StringUtils.EMPTY;
	String[] headers = {"Header1","Header 2","Header3XXXXXXXXXXXXXX"};
	String[] bodyData = {"value1","value2","value3"};
	//private List<String> hederNames = Arrays.asList(headers);
	private FileOutputStream outputStream;
	private HSSFWorkbook workbook;

	public FileDetailsVO(String fileName, String workSheetName) {
		super();
		this.fileName = fileName;
		this.workSheetName = workSheetName;
	}

	public String getWorkSheetName() {
		return workSheetName;
	}

	public void setWorkSheetName(String workSheetName) {
		this.workSheetName = workSheetName;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public HSSFSheet getWoorkSheet(){
		if (null != getWorkBook().getSheet(this.workSheetName)){
			return getWorkBook().getSheet(this.workSheetName);
		} 
		return getWorkBook().createSheet(this.workSheetName);
	}

	public HSSFWorkbook getWorkBook() {
		
		if(null != workbook){
			return workbook;
		} else {
			workbook = new HSSFWorkbook();
		}
		return workbook;
	}
	
	public HSSFCellStyle getCellStyle(HSSFSheet worksheet){
		return worksheet.getWorkbook().createCellStyle();
	}
	
	public void writeToExcelFile(){
		try{
			workbook.write(getFileOutPutStream());
		}catch(Exception e){
			System.out.println(e);
		}
		
	}
	
	public FileOutputStream getFileOutPutStream() throws FileNotFoundException{
		
		if(outputStream != null){
			return outputStream;
		}else {
			outputStream = new FileOutputStream(this.fileName);
		}
		return outputStream;
	}

	public void createHeaderRow() {
		HSSFRow row1  = getWoorkSheet().createRow(0);
		for (int i = 0; i < headers.length; i++) {
		HSSFCell cell = row1.createCell(i);
			cell.setCellValue(headers[i]);
			getHeaderStyle(cell);
		}
	}
	public void createBodyRow() {
		HSSFRow row1  = getWoorkSheet().createRow(1);
		for (int i = 0; i < bodyData.length; i++) {
			HSSFCell cell = row1.createCell(i);
			cell.setCellValue(bodyData[i]);
		}
	}

	public  void getHeaderStyle(HSSFCell cell) {
		HSSFCellStyle cellStyle = getWorkBook().createCellStyle();
		cellStyle.setFillForegroundColor(HSSFColor.GOLD.index);
		cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		HSSFFont font = getWorkBook().createFont();
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		cellStyle.setFont(font);
		cell.setCellStyle(cellStyle);
	}

}
