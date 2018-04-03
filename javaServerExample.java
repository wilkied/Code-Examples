/*
**	Author: Debra Wilkie
**	Class:  CS372 Intro to Computer Networks
**  Date: October 29, 2017
**	Project Requirements: Server side chat program in java; Client side chat program in c
**	This program performs the server side of a chat program. It accepts a port number
**  The connection sets up a server socket and sets up an input and output stream
**  It waits for the client to connect and replies with the handle: JavaMan>
**  Once a message is received it can reply until the command "\quit"
**	at which point the server port will be disconnected.
*/

import java.io.*;
import java.net.*;
public class javaServerExample
{
  public static void main(String[] args) throws Exception
  {
      //Port number needs to be input
	  int portNumber = Integer.parseInt(args[0]);
	  String handle = "JavaMan> ";
	  
	  //Creating a new Server Socket to set up communication
	  ServerSocket serverSocket = new ServerSocket(portNumber);
      System.out.println("Server ready for chatting on port " + portNumber);
      Socket clientSocket = serverSocket.accept( );                          
      //Reading input from the keyboard for server communication
      BufferedReader keyRead = new BufferedReader(new InputStreamReader(System.in));
	  
	  //Sending to client via the output Stream  
      OutputStream ostream = clientSocket.getOutputStream(); 
      PrintWriter pwrite = new PrintWriter(ostream, true);

      //Receiving from client  
      InputStream istream = clientSocket.getInputStream();
      BufferedReader receiveRead = new BufferedReader(new InputStreamReader(istream));

      String receiveMessage, sendMessage;
	  //The string used to close the socket and escape the while loop
	  String quit = "\\quit";
	  
      while(true)
      {
        //if you have a message
		if((receiveMessage = receiveRead.readLine()) != null)  
        {
           if (receiveMessage.equals(quit)) { break; }
		   System.out.print("CoolC> "); 
		   System.out.println(receiveMessage);
		   
		   System.out.print("JavaMan> ");		   
        }         
        sendMessage = keyRead.readLine(); 
		if (sendMessage.equals(quit)) { 
			pwrite.println(sendMessage);
			break;
		}
        pwrite.println(handle + sendMessage);             
        pwrite.flush();
      }
	  System.out.println("Server closing");
	  pwrite.close();
	  keyRead.close();
	  clientSocket.close();
    }                    
} 


                    