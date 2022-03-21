package cliente;

import java.io.IOException;
import java.net.UnknownHostException;

import lib.ChannelException;
import lib.CommClient;
import lib.ProtocolMessages;
import lib.UnknownOperation;


public class Cliente2 {

	private static CommClient com;	// canal de comunicación del cliente
	
	private static String saludame() throws IOException, ChannelException {
		Object resultado = null;
		
		// crear mensaje a enviar
		ProtocolMessages peticion =
				new ProtocolMessages("saluda");
		// enviar mensaje de solicitud al servidor
		com.sendEvent(peticion);
		try {
			// esperar respuesta, excepto si la petición es oneway
			ProtocolMessages respuesta = com.waitReply();
			// procesar respuesta o excepción
			resultado = com.processReply(respuesta);
		} catch (ClassNotFoundException e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (UnknownOperation e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (Exception e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
		}
		
		return (String)resultado;
	} // saludame
		
    public static void main(String[] args) {
    	
	    try {
			// crear el canal de comunicación y establecer la
			// conexión con el servicio por defecto en localhost
			com = new CommClient();
			
			// activa el registro de mensajes del cliente
//			com.activateMessageLog();  // opcional
		} catch (UnknownHostException e) {
			System.err.printf("Servidor desconocido. %s\n", e.getMessage());
			e.printStackTrace();
			System.exit(-1);	// salida con error
		} catch (IOException | ChannelException e) {
			System.err.printf("Error: %s\n", e.getMessage());
			e.printStackTrace();
			System.exit(-1);	// salida con error
		}
		
		try {
			for (int k = 0; k < 3; k++) {
				saludame();
			}
		} catch (IOException | ChannelException e) {
			System.err.printf("Error: %s\n", e.getMessage());
			e.printStackTrace();
		} catch (Exception e) { // excepción del servicio
			System.err.printf("Error: %s\n", e.getMessage());
			e.printStackTrace();
		} finally {
			// cierra el canal de comunicación y
			// desconecta el cliente
			com.disconnect();
		}
		
	} // main
    
    
} // class Saludador
