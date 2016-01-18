package com.myjavapaers.dozer;

import java.io.File;

import org.apache.xmlbeans.XmlException;
import org.dozer.DozerBeanMapperSingletonWrapper;
import org.dozer.Mapper;

import com.myjavapaers.dozer.utils.FileUtils;
import com.myjavapapers.dozer.beans.GetOperatingInstructions;
import com.uprr.app.ama.xmlvo.customer.operating_Instructions_2_1.GetOperatingInstructionsReplyDocument;

public class DozerMappingsMainTestClass {

	public static void main(String[] args) {
		Mapper mapper = DozerBeanMapperSingletonWrapper.getInstance();
		GetOperatingInstructions operatingInstructions = new GetOperatingInstructions();
		try{
			mapper.map(getOperatingInstructionsData(), operatingInstructions);
		}catch (Exception e){
			System.out.println(e);
		}
		
		System.out.println(operatingInstructions);

	}

	private static Object getOperatingInstructionsData() {

		try {
			GetOperatingInstructionsReplyDocument operatingInstructionsReplyDocument = GetOperatingInstructionsReplyDocument.Factory
					.parse(getServiceReplyDoc());
			//operatingInstructionsReplyDocument.getGetOperatingInstructionsReply().getCustomer()
			return operatingInstructionsReplyDocument;
		} catch (XmlException e) {
			e.printStackTrace();
		}

		return null;
	}

	private static String getServiceReplyDoc() {
		return FileUtils.getContents(new File(
				"C:/Users/xprk791/Desktop/get-operation-instruction-2_1.xml"));
	}

}
