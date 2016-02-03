package com.myjavapapers.utils;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFHeader;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;

import com.itsmyjava.blogspot.hibernate.vo.FileDetailsVO;
public class ExcelCreation {
	

	public static void main(String[] args) {
		createExcelFile();
	}

		public static void main2(String[] args) {
			try {
				FileOutputStream fileOut = new FileOutputStream("poi-test.xls");
				HSSFWorkbook workbook = new HSSFWorkbook();
				HSSFSheet worksheet = workbook.createSheet("POI Worksheet");
				HSSFHeader header = worksheet.getHeader();
				header.setCenter("Dileep");
				
				// index from 0,0... cell A1 is cell(0,0)
				HSSFRow row1 = worksheet.createRow(0);

				HSSFCell cellA1 = row1.createCell(0,Cell.CELL_TYPE_STRING);
				cellA1.setCellValue("Hello");
				HSSFCellStyle cellStyle = workbook.createCellStyle();
				cellStyle.setFillForegroundColor(HSSFColor.GOLD.index);
				cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				cellA1.setCellStyle(cellStyle);

				HSSFCell cellB1 = row1.createCell(1,Cell.CELL_TYPE_STRING);
				cellB1.setCellValue("Goodbye");
				cellStyle = workbook.createCellStyle();
				cellStyle.setFillForegroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
				cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				cellB1.setCellStyle(cellStyle);

				HSSFCell cellC1 = row1.createCell(2,Cell.CELL_TYPE_STRING);
				cellC1.setCellValue(true);

				HSSFCell cellD1 = row1.createCell(3,Cell.CELL_TYPE_STRING);
				cellD1.setCellValue(new Date());
				cellStyle = workbook.createCellStyle();
				cellStyle.setDataFormat(HSSFDataFormat
						.getBuiltinFormat("m/d/yy h:mm"));
				cellD1.setCellStyle(cellStyle);

				workbook.write(fileOut);
				fileOut.flush();
				fileOut.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}

		}

		
		public static void createExcelFile(){
			FileDetailsVO details = new FileDetailsVO("poi-test4.xls","First TAB");
			details.createHeaderRow();
			details.createBodyRow();
			details.writeToExcelFile();
			HSSFWorkbook workBook = details.getWorkBook();
			byte[] excelData = workBook.getBytes();
			
			
		}

}
