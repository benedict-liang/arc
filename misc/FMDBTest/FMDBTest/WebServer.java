import java.util.*;
import java.io.*;
import java.net.*;
import java.lang.*;

public class WebServer {

	public static void main (String args[]) throws Exception 
	{
		int portNumber = getPortNumberFromInput(args);

		ServerSocket serverSocket = new ServerSocket(portNumber);
		while (true) {
			//accept connection
			Socket s = serverSocket.accept();

			//get input from client (browser)	
			InputStream is = s.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));

			//from server to client
			OutputStream os = s.getOutputStream();
			DataOutputStream output = new DataOutputStream(os);


			String inputString = br.readLine();
			String fields[] = inputString.split(" ");
			String filename = getFileName(fields);
			filename = System.getProperty("user.home") + "/a1/" + filename;

			//get first line
			if (fields[0].equals("GET")) {

				//filter get query string
				String queryStringGET = "";
				String filenameArray[] = filename.split("\\?");
				if (filenameArray.length > 1) {
					filename = filenameArray[0];
					queryStringGET = filenameArray[1];
				}

				String envRequestMethod = "REQUEST_METHOD=GET";
				String envQueryString = "QUERY_STRING=" + queryStringGET;
				String combinedEnvString = envRequestMethod + " " + envQueryString;

				executeGETRequest(filename, output, queryStringGET, combinedEnvString);
			}
			
			else if (fields[0].equals("POST")) {
				String[] envVariablesArray = new String[2]; 
				String header = getPOSTHeader(br, envVariablesArray);

				//set environment variables
				String envRequestMethod = "REQUEST_METHOD=POST";
				String envContentType = "CONTENT_TYPE=" + envVariablesArray[0];
				String envContentLength = "CONTENT_LENGTH=" + envVariablesArray[1];
				String combinedEnvString = envRequestMethod + " " + envContentType + " " + envContentLength;

				String[] parametersArray = new String[2];
				byte[] buffer = executePerlFile(filename, header, parametersArray, combinedEnvString, true);
				
				//set content type and size of buffer
				String contentType = parametersArray[0];
				int size = Integer.parseInt(parametersArray[1]);

				//if p works
				output.writeBytes("HTTP/1.0 200 OK\r\n");
				output.writeBytes(contentType + "\r\n");
				output.write(buffer, 0, size);
			}

			//close socket
			s.close();
		}
	}

	/******************************************
	** Helper Methods
	******************************************/

	/**
	* return port number from input,
	* 		if array length less than 1, exit program
	**/
	private static int getPortNumberFromInput(String[] args) {
		if (args.length < 1) {
			System.out.println("Please include a port number!");
			System.exit(0);
		}
		try {
			int portNumber = Integer.parseInt(args[0]);
			if (portNumber < 1024 || portNumber > 65535) {
				System.out.println("Port Number not in range.");
				System.exit(0);
			}
			return portNumber;
		} catch (NumberFormatException e) {
			System.out.println("Input must be a number.");
			System.exit(0);
		}
		return 0;
	}

	/**
	* Gets file name from the header field. Processes it by removing the initial slash.
	* 
	* return file name (without initial slash)
	**/
	private static String getFileName(String[] fields) {
		String filename = fields[1];
		if (filename.startsWith("/")) {
			//remove initial slash
			filename = filename.substring(1);
		}

		return filename;
	}

	/**
	* Runs the perl file.
	* Stores content type and buffer size in the parametersArray via referencing.
	*
	* return content buffer
	**/
	private static byte[] executePerlFile(String filename, String parameters, String[] parametersArray, String envVariables) throws IOException {
		return executePerlFile(filename, parameters, parametersArray, envVariables, false);
	}

	private static byte[] executePerlFile(String filename, String parameters, String[] parametersArray, String envVariables, boolean isPOST) throws IOException {
		byte[] buffer = new byte[0];
		String command = "/usr/bin/env " + envVariables + " ";
		Process process = null;

		if (!isPOST) {
			command += "/usr/bin/perl " + filename + " " + parameters;
			process = Runtime.getRuntime().exec(command);
		}
		else {
			command += "/usr/bin/perl " + filename;
			process = Runtime.getRuntime().exec(command);
			OutputStream processOS = process.getOutputStream();
			DataOutputStream processOutput = new DataOutputStream(processOS);

			processOutput.writeBytes(parameters);
			processOutput.close();
		}

		InputStream processIS = process.getInputStream();

		byte byteInput = (byte) processIS.read();
		if (byteInput !=-1) {
			ArrayList<Byte> contentTypeArr = new ArrayList<Byte>();
			ArrayList<Byte> arr = new ArrayList<Byte>();

			//get first line
			while (byteInput != '\n') {
				contentTypeArr.add(byteInput);
				byteInput = (byte) processIS.read();
			}

			String contentType = String.valueOf(contentTypeArr.toArray());

			while (byteInput != -1) {
				arr.add(byteInput);
				byteInput = (byte) processIS.read();
			}

			int size = arr.size();
			buffer = new byte[size];

			for (int i = 0; i < buffer.length; i++) {
				buffer[i] = arr.get(i);
			}

			parametersArray[0] = contentType;
			parametersArray[1] = String.valueOf(size);
 		}

		return buffer;
	}

	/******************************************
	** GET Methods
	******************************************/

	/**
	* Executes GET request for file types: .css, .gif, and .pl.
	*
	**/
	private static void executeGETRequest(String filename, DataOutputStream output, String queryStringGET, String envVariables) throws Exception {
		boolean isFileCSS = filename.endsWith("css");
		boolean isFileGif = filename.endsWith("gif");
		boolean isFilePl = filename.endsWith("pl");

		byte[] buffer = new byte[0];
		int size = 0;
		String contentType = "";
		
		if (isFilePl) {
			String[] parametersArray = new String[2];
			buffer = executePerlFile(filename, queryStringGET, parametersArray, envVariables);

			//set content type and size of buffer
			contentType = parametersArray[0];
			size = Integer.parseInt(parametersArray[1]);
		}
		else if (isFileCSS || isFileGif) {

			File file = new File(filename);
			if (file.canRead()) {
				//send file back
				size = (int)file.length();
				buffer = new byte[size];
				FileInputStream fileInputStream = new FileInputStream(filename);
				//read file input stream to buffer array
				fileInputStream.read(buffer);

				//set content type
				if (isFileCSS) {
					contentType = "Content-Type: text/css\r\n";	
				}
				else {
					contentType = "Content-Type: image/gif\r\n";
				}
			}
		}
		else
		{
			// File cannot be read.  Reply with 404 error.
			output.writeBytes("HTTP/1.0 404 Not Found\r\n");
			output.writeBytes("\r\n");
			output.writeBytes("No such page, please try again");
		}

		if (isFileCSS || isFileGif || isFilePl) {
			output.writeBytes("HTTP/1.0 200 OK\r\n");
			output.writeBytes(contentType + "\r\n");
			output.write(buffer, 0, size);
		}
	}

	/******************************************
	** POST Methods
	******************************************/

	/**
	* Obtain header from POST request.
	*
	* return POST header
	**/
	private static String getPOSTHeader(BufferedReader br, String[] envVariablesArray) throws Exception {
		int contentLength = 0;
		String contentType = "";
		String inLine = null;
		while (((inLine = br.readLine()) != null) && (!(inLine.equals("")))) {
			if (inLine.startsWith("Content-Type")) {
				String[] temp = inLine.split(" ");
				contentType = temp[1];
			}
			if (inLine.startsWith("Content-Length")) {
				String[] temp = inLine.split(" ");
				contentLength = Integer.parseInt(temp[1]);
			}
		}
		
		envVariablesArray[0] = contentType;
		envVariablesArray[1] = String.valueOf(contentLength);

		return getPOSTHeaderDataField(br, contentLength);
	}

	/**
	* Gets POST data field without the response headers from the POST request.
	*
	* return POST header data field
	**/
	private static String getPOSTHeaderDataField(BufferedReader br, int contentLength) throws Exception {
		byte[] byteArr = new byte[contentLength];
		for (int i=0; i<contentLength; i++) {
			byteArr[i] = (byte)br.read();
		}

		return new String(byteArr);
	}
}
