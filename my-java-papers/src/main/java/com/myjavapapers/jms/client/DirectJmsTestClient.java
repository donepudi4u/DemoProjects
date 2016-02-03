package com.myjavapapers.jms.client;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Hashtable;

import javax.jms.JMSException;
import javax.jms.Queue;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueSender;
import javax.jms.QueueSession;
import javax.jms.TextMessage;
import javax.naming.Context;
import javax.naming.InitialContext;

public class DirectJmsTestClient {

	static int NUMBER_OF_ITERATIONS = 1;
	private static final String XMF_TEST_MESSAGE = getContents(new File("C:/Users/xprk791/GDE/UP Apps/AMA/TIH Recordings/CEO-Messages/GATX95640-CP-CP.xml"));

	public static void main(String[] args) throws FileNotFoundException,
			IOException {
		System.out.println("DirectJmsTestClient.main() : start");
		for (int i = 1; i <= NUMBER_OF_ITERATIONS; i++) {
			System.out.println("\nStart Test " + i);
			new DirectJmsTestClient(args);
		}
		System.out.println("\nDirectJmsTestClient.main() : end");

	}

	public DirectJmsTestClient(String[] args) {
		String userName = "dama999";
		String password = "UPwqd797";
		String receivingQueueName = "COM.PROKARMA.TEST.QUEUE.ONE";
		Hashtable<String, String> environment = null;
		Context context = null;
		QueueConnectionFactory factory = null;
		String PROVIDER_URL = "tibjmsnaming://localhost:7222";
		String QCF = "CEO-QCF-00";

		QueueConnection connection = null;
		QueueSession session = null;
		QueueSender msgProducer = null;
		Queue destination = null;
		

		try {
			// set the environment variable and create context
			environment = new Hashtable<String, String>();
			environment.put(Context.INITIAL_CONTEXT_FACTORY,"com.tibco.tibjms.naming.TibjmsInitialContextFactory");
			environment.put(Context.PROVIDER_URL, PROVIDER_URL);
			environment.put(Context.SECURITY_PRINCIPAL, userName);
			environment.put(Context.SECURITY_CREDENTIALS, password);
			context = new InitialContext(environment);
			System.out.println("Set environment variable and create context");

			// create factory
			factory = (QueueConnectionFactory) context.lookup(QCF);
			System.out.println("Factory Created");

			// create connection
			connection = factory.createQueueConnection(userName, password);
			System.out.println("Connection Created");

			// create the session
			session = connection.createQueueSession(false,
					javax.jms.Session.AUTO_ACKNOWLEDGE);
			System.out.println("Session Created");

			// create the destination
			destination = session.createQueue(receivingQueueName);
			System.out.println("Destination Created");

			// create the producer
			msgProducer = session.createSender(destination);
			System.out.println("msgProducer Created\n");

			// publish messages
			String xml = XMF_TEST_MESSAGE;
			System.out.println("File read");

			TextMessage msg = session.createTextMessage();
			msg.setText(xml);
			
			// Set the TIH message details
			buildTIHMEssage(msg); 
			
			System.out.println("The XML message is: " + msg.getText());
			msgProducer.send(msg);
			System.out.println("Message Sent\n");
		} catch (Exception e) {
			System.out.println("Exception: " + e);
		} finally {
			releaseResources(connection, session, msgProducer);
		}
	}

	private void buildTIHMEssage(TextMessage msg) {
		try {
			msg.setStringProperty("evnt_id", "19779003720"); // Event ID
			msg.setStringProperty("evnt_dt", "20141017031700"); //
			msg.setStringProperty("evnt_code", "CP-CP");  //
			msg.setStringProperty("evnt_type", "CEO");  //
			msg.setStringProperty("stat_code", "");   // source event type 
			msg.setStringProperty("upd_task_user_id", "DKMF999");
			msg.setStringProperty("upd_task_id", "EY");
			msg.setStringProperty("eqmt_init", "GATX");    // Equipment Initial
			msg.setStringProperty("eqmt_nbr", "95640");   // Equipment Number
			msg.setStringProperty("tcs_car_kind", "T25");  // Car kind
			msg.setStringProperty("le_code", "L");          // L/E code
			msg.setStringProperty("wb_nbr", "245550");           // Way bill #
			msg.setStringProperty("evnt_wb_nbr", "245550");           // Way bill #
			msg.setStringProperty("wb_dt", "20141014");            //Way bill date
			msg.setStringProperty("wb_type", "SWBILLX");          // Waybill type
			msg.setStringProperty("mvmt_auth_code", "");
			msg.setStringProperty("mv_type", "RHSWISW");
			msg.setStringProperty("tcs_csn", "1101624432");          // CSN
			msg.setStringProperty("stcc_code", "4909382");        // STCC code
			msg.setStringProperty("cmdy_abrv", "FLMLIQ");        // STCC Desc
			msg.setStringProperty("orig_ofln_stn_id", "1562");
			msg.setStringProperty("orig_stn_id", "");      // Origin station ID.
			msg.setStringProperty("on_jct_stn_id", "5543");    // Origin Junction id (IF Origin station id is null)
			msg.setStringProperty("tcs_finl_ofln_stn_id", ""); // Final Off line staion id
			msg.setStringProperty("finl_stn_id", "5543");
			msg.setStringProperty("off_jct_stn_id", "");
			msg.setStringProperty("shpr_frm_nbr", "377050");   // Shipper Firm Number
			msg.setStringProperty("cnse_frm_nbr", "837761");  // Consignee Firm Number
			msg.setStringProperty("co_part_frm_nbr", "094070"); // Care of party firm number
			msg.setStringProperty("ultm_co_firm_nbr", "856793"); // ultimate care of party firm number 
			msg.setStringProperty("evnt_stn_id", "5543"); // Event station id
			msg.setStringProperty("evnt_crc7", "CC150"); // Event circ7
			msg.setStringProperty("evnt_tz", "0"); //  -2 = PST, -1 = MST, 0 = CST, 1= EST, Default : CST 
			msg.setStringProperty("inbd_trn_symb", "LKY38"); // train symbol.
			msg.setStringProperty("chas_eqmt_init", ""); // chasis initial
			msg.setStringProperty("chas_eqmt_nbr", ""); // chasis number
			msg.setStringProperty("dp_ntfn_lata_addr", ""); // notification address.
		} catch (JMSException e) {
			System.out.println(e);
		}

		
	}

	private void releaseResources(QueueConnection connection,
			QueueSession session, QueueSender msgProducer) {
		if (msgProducer != null) {
			try {
				msgProducer.close();
				System.out.println("msgProducer Closed");
			} catch (JMSException e) {
				System.out.println("Error closing msgProducer: " + e);
			}
		}
		if (session != null) {
			try {
				session.close();
				System.out.println("Session Closed");
			} catch (JMSException e) {
				System.out.println("Error closing Session: " + e);
			}
		}
		if (connection != null) {
			try {
				connection.close();
				System.out.println("Connection Closed");
			} catch (JMSException e) {
				System.out.println("Error closing Connection: " + e);
			}
		}
	}

	@SuppressWarnings("unused")
	private static String readFile() throws FileNotFoundException, IOException {
		// Read the file whose content has to be passed as String
		BufferedReader br = new BufferedReader(new FileReader(XMF_TEST_MESSAGE));
		String nextLine = "";
		StringBuffer sb = new StringBuffer();
		while ((nextLine = br.readLine()) != null) {
			sb.append(nextLine);
			sb.append(System.getProperty("line.separator"));
		}
		br.close();
		// Convert the content into to a string
		String clobData = sb.toString();

		// Return the data.
		return clobData;
	}

	static public String getContents(File aFile) {
		StringBuffer contents = new StringBuffer();
		BufferedReader input = null;
		try {
			input = new BufferedReader(new FileReader(aFile));
			String line = null;

			while ((line = input.readLine()) != null) {
				contents.append(line);
			}
		} catch (FileNotFoundException e) {
			System.out.println("Exception: " + e);
		} catch (IOException e) {
			System.out.println("Exception: " + e);
		} finally {
			try {
				if (input != null) {
					input.close();
				}
			} catch (IOException e) {
				System.out.println("Exception: " + e);
			}
		}
		return contents.toString();
	}
}