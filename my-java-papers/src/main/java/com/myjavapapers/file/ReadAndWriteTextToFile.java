package com.myjavapapers.file;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.commons.lang.StringUtils;

public class ReadAndWriteTextToFile {
	
	public static void main(String args[]) throws IOException {
		//separateAllMessagesAndWriteToFiles();
		extractEventMessagesAndWriteToFile();
	}


	private static void extractEventMessagesAndWriteToFile() {
		System.out.println("Testing Git");
		int tihEventMessages= 0;
		int cpEventFiles = 0;
		int rlCPEventFiles = 0;
		int apEventFiles = 0;
		//int etaEventFiles = 0;
		int rlEventFiles = 0;
		int irEventFiles = 0;
		int otherTIHEventFiles = 0;
		int totalEventMessages = 0;
		try {
			for (int i = 0; i <= 25; i++) {
				String content = inputXML("C:\\Users\\xprk791\\GDE\\workspace\\TechPracticeProjects\\my-java-papers\\tih-files\\2015-08-14\\"+ i +".xml");
				StringTokenizer stringTokenizer = new StringTokenizer(content,",");
				while (stringTokenizer.hasMoreTokens()) {
					totalEventMessages++;
					String textmessage = stringTokenizer.nextToken();
					if (msgStrContains(textmessage, "tih_flag=\"Y\"")){
						tihEventMessages++;
						if (msgStrContains(textmessage, "evnt_code=\"CP\"") && msgStrContains(textmessage,  "stop_code=\"CP\"")){
							writeToFile(textmessage,"File_"+cpEventFiles++,"C:/Users/xprk791/Desktop/temp/tih/CP-Events");
							System.out.println("CP Event File wrote : "+cpEventFiles);
						}
						else if (msgStrContains(textmessage, "evnt_code=\"RL\"") && msgStrContains(textmessage,"stop_code=\"CP\"")){
							writeToFile(textmessage,"File_"+rlCPEventFiles++,"C:/Users/xprk791/Desktop/temp/tih/RL-CP-Events");
							System.out.println("RL-CP Event File wrote : "+rlCPEventFiles);
						}
						else if (msgStrContains(textmessage, "evnt_code=\"AP\"")){
							writeToFile(textmessage,"File_"+apEventFiles++,"C:/Users/xprk791/Desktop/temp/tih/AP-Events");
							System.out.println("AP Event File wrote : "+apEventFiles);
						}else if (msgStrContains(textmessage, "evnt_code=\"RL\"")){
							writeToFile(textmessage,"File_"+rlEventFiles++,"C:/Users/xprk791/Desktop/temp/tih/RL-Events");
							System.out.println("ETA Event File wrote : "+rlEventFiles);
						}
						else if (msgStrContains(textmessage, "evnt_code=\"IR\"")){
							writeToFile(textmessage,"File_"+irEventFiles++,"C:/Users/xprk791/Desktop/temp/tih/IR-Events");
							System.out.println("ETA Event File wrote : "+irEventFiles);
						}
						else {
							writeToFile(textmessage,"File_"+otherTIHEventFiles++,"C:/Users/xprk791/Desktop/temp/tih/Other-TIH-Events");
							System.out.println("ETA Event File wrote : "+otherTIHEventFiles);
						}
						
					}
					
				}
			}
			
			System.out.println("Total Event Messages Count  [" + totalEventMessages +"]");
			System.out.println("TIH Event Messages [" + tihEventMessages +"]");
			System.out.println("CP Event Messages Count[" + cpEventFiles +"]");
			System.out.println("RL-CP Event Messages Count[" + rlCPEventFiles +"]");
			System.out.println("AP Event Messages Count[" + apEventFiles +"]");
			//System.out.println("ETA Event Messages Count[" + etaEventFiles +"]");
			System.out.println("RL Event Messages Count[" + rlEventFiles +"]");
			System.out.println("IR Event Messages Count[" + irEventFiles +"]");
			System.out.println("otherTIH Event Messages [" + otherTIHEventFiles +"]");
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	
	private static void separateAllMessagesAndWriteToFiles() {
		try{
			separateAllMessages();
			//writeToSameFiles();
		}catch(Exception e ){
			
		}
		
		
	}

	private static void writeToSameFiles(String fileContent, String  fileName, String  filePath) {
		writeToFile(fileContent, fileName, filePath);
	}

	private static void separateAllMessages() {
		for (int i = 0; i <= 23; i++) {
			String content = inputXML("C:\\Users\\xprk791\\GDE\\workspace\\TechPracticeProjects\\my-java-papers\\tih-files\\2015-08-14\\"+ i +".xml");
			String modifiedContent = StringUtils.replace(content, "</textMessage>", "</textMessage>,");
			System.out.println("File" + i +"Content Replaced Successfully");
			writeToSameFiles(modifiedContent,i+"","C:\\Users\\xprk791\\GDE\\workspace\\TechPracticeProjects\\my-java-papers\\tih-files\\2015-08-14\\");
		}
	}

	private static Boolean tihEventCheck(String textmessage) {
		if (textmessage.contains("evnt_code=\"AP\"")){
			return Boolean.TRUE;
		} else if (textmessage.contains("evnt_code=\"CP\"") && textmessage.contains("stop_code=\"CP\"")){
			return Boolean.TRUE;
		} else if (textmessage.contains("evnt_code=\"RL\"") && textmessage.contains("stop_code=\"CP\"")){
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	private static Boolean  tihCommodityCheck(String textmessage) {
		List<String> tihStccs = getTIHCommoditiesList();
		for (String tihStcc : tihStccs) {
			String searchString = "stcc_code=\""+ tihStcc.trim() +"\"";
			if (textmessage.contains(searchString)){
				System.out.println("STCC Code found " + tihStcc);
				return Boolean.TRUE;
			}
		}
		return Boolean.FALSE;
	}


	private static void writeToFile(String fileContent,String fileName,String filePath) {
		try {
			String baseDir = "C:/Users/xprk791/Desktop/temp/tih";
			if (StringUtils.isNotBlank(filePath)){
				baseDir = filePath;
			}
			File newFile = new File(baseDir, fileName+".xml");
			if (!newFile.exists()) {
				newFile.createNewFile();
		    }
			 FileOutputStream foutput = new FileOutputStream(newFile);
			byte[] c = fileContent.getBytes();
			foutput.write(c);
			foutput.flush();
			foutput.close();
		}  catch (IOException e) {
			e.printStackTrace();
		}
	}

	protected static String inputXML(final String fileName) {

		final StringBuffer strContent = new StringBuffer();
		DataInputStream dataInputStream = null;
		try {
			dataInputStream = new DataInputStream(new FileInputStream(new File(
					fileName)));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		final BufferedReader bufferedReader = new BufferedReader(
				new InputStreamReader(dataInputStream));
		String ch;
		try {
			while ((ch = bufferedReader.readLine()) != null) {
				strContent.append(ch);
			}
			dataInputStream.close();
		} catch (final Exception exception) {
			System.out.println(exception);
		}
		return strContent.toString();
	}

	private static boolean msgStrContains(String xmlStrMessage, String searchStr){
		if (StringUtils.containsIgnoreCase(xmlStrMessage, searchStr)){
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	private static List<String> getTIHCommoditiesList() {
		//String[] tihStccs = {"2812815","2813914","2813920","2813922","2813932","2813946","2813950","2813964","2813975","2815151","2815207","2815210","2818008","2818009","2818023","2818037","2818057","2818063","2818101","2818104","2818123","2818131","2818138","2818168","2818184","2818239","2818288","2818331","2818410","2818416","2818454","2818820","2818830","2818890","2818915","2818920","2819216","2819325","2819340","2819415","2819416","2819422","2819434","2819484","2819535","2819815","2819919","2819961","2819962","2819971","2819972","2819997","2879934","2879936","2879951","2899799","2912130","3533945"};  
		String[] tihStccs = {"4821019"," 4935231"," 4927039"," 4904211"," 4904210"," 4927037"," 4927038"," 4933327"," 4927035"," 4927036"," 4927034"," 4927031"," 4921495"," 4921497"," 4932010"," 4821722"," 4921487"," 4927014"," 4927019"," 4927018"," 4927011"," 4921288"," 4927012"," 4927010"," 4921287"," 4921695"," 4921473"," 4821029"," 4920715"," 4932352"," 4927024"," 4923298"," 4927025"," 4927026"," 4927028"," 4927029"," 4921275"," 4927022"," 4927023"," 4920108"," 4920107"," 4920106"," 4910370"," 4920105"," 4920104"," 4920103"," 4930050"," 4920102"," 4909306"," 4909307"," 4920515"," 4830030"," 4920516"," 4920513"," 4920511"," 4920510"," 4920101"," 4930260"," 4920518"," 4920113"," 4918180"," 4920115"," 4920502"," 4921254"," 4920503"," 4920504"," 4921255"," 4921252"," 4921251"," 4927007"," 4927006"," 4920110"," 4927009"," 4920111"," 4927008"," 4920112"," 4920508"," 4927004"," 4920509"," 4930030"," 4921248"," 4920530"," 4920534"," 4921245"," 4920535"," 4920536"," 4920380"," 4920381"," 4920382"," 4920122"," 4920135"," 4920399"," 4921239"," 4920522"," 4920523"," 4920526"," 4920527"," 4920528"," 4930024"," 4920394"," 4921756"," 4920392"," 4920398"," 4920395"," 4920396"," 4921744"," 4921741"," 4921742"," 4921745"," 4921746"," 4920352"," 4920178"," 4920558"," 4920351"," 4907409"," 4920557"," 4920354"," 4920176"," 4920353"," 4920175"," 4920559"," 4920174"," 4920554"," 4920173"," 4920553"," 4920172"," 4920171"," 4920555"," 4920359"," 4920550"," 4931201"," 4920551"," 4920552"," 4920355"," 4920356"," 4920357"," 4921730"," 4921404"," 4921405"," 4921000"," 4921401"," 4921402"," 4921003"," 4920343"," 4920165"," 4920342"," 4920164"," 4920167"," 4920547"," 4920160"," 4920348"," 4920349"," 4920346"," 4920347"," 4904879"," 4920344"," 4921207"," 4921004"," 4921006"," 4921009"," 4921008"," 4921202"," 4921413"," 4921414"," 4921211"," 4921722"," 4921010"," 4920576"," 4920575"," 4920371"," 4920577"," 4920373"," 4921727"," 4920375"," 4920378"," 4920379"," 4920570"," 4920571"," 4920572"," 4920573"," 4920574"," 4921216"," 4921019"," 4921213"," 4921016"," 4936110"," 4921023"," 4921024"," 4921020"," 4923113"," 4920567"," 4920360"," 4920566"," 4920565"," 4920564"," 4920569"," 4920568"," 4920368"," 4920369"," 4920562"," 4923117"," 4920563"," 4920560"," 4920561"," 4921027"," 4921029"," 4921420"," 4921028"," 4920310"," 4921439"," 4921438"," 4921437"," 4923209"," 4920319"," 4920316"," 4920315"," 4920318"," 4920317"," 4920312"," 4920311"," 4920314"," 4916138"," 4920313"," 4921587"," 4918507"," 4921447"," 4921440"," 4921441"," 4920309"," 4918505"," 4920308"," 4920307"," 4920305"," 4920304"," 4907434"," 4921304"," 4932385"," 4920303"," 4920301"," 4920195"," 4920193"," 4921558"," 4920194"," 4920331"," 4920198"," 4921458"," 4920191"," 4920192"," 4920190"," 4930204"," 4920337"," 4920184"," 4920320"," 4920321"," 4920187"," 4920188"," 4920189"," 4921063"," 4920180"," 4920181"," 4921462"," 4921463"," 4921465"," 4920325"," 4920324"," 4920326"};  
		List<String> tihStccList = Arrays.asList(tihStccs);
		return tihStccList;
	}
}
