package servidor;

import lib.CommServer;
import lib.ProtocolMessages;
import optional.Trace;

public class Servidor {
	
	private static void registrarOperaciones(CommServer com) {
		com.addFunction("saluda",
				(o, x) -> ((SaludadorOOS) o).saluda());
		com.addAction("cambiaSaludo",
				(o, x) -> ((SaludadorOOS) o).cambiaSaludo((String) x[0]));
		com.addAction("reset", (o, x) -> ((SaludadorOOS) o).reset(), true);
	}
	
	public static void main(String[] args) throws Exception {
		CommServer com;				// canal de comunicación del servidor
		SaludadorOOS objServicio;	// objeto de operaciones de servicio
		ProtocolMessages request;	// mensaje entrante (petición del cliente)
		ProtocolMessages response;	// mensaje salidente (respuesta para el cliente)
		int idClient;				// identificador del cliente
		
		// 1. Crear canal de comunicación
		com = new CommServer();
			
		// operaciones opcionales
		Trace.activateTrace(com); // activa el seguimento en consola del servidor
//		com.activateMessageLog(); // activa el registro de mensajes del servidor en un archivo
		
		// 2. Registrar las operaciones de servicio
		registrarOperaciones(com);
		
		// 3. Bucle infinito
		while (true) { // el servicio siempre ha de estar disponible
			// 3.1 Esperar por un cliente (espera bloqueante) e identificar
			idClient = com.waitForClient();
			
			// 3.2 Crear el objeto de servicio para el cliente que se ha conectado
			objServicio = new SaludadorOOS("Buenos días, tardes, noches.");
			
			// 3.3 Intercambiar mensajes con el cliente
			while (!com.closed(idClient)) {
	    		// 4.1 Esperar a recibir del cliente la orden serializada
				request = com.waitEvent(idClient);
	    		
				// 4.2 Evaluar la orden recibida
	    		response = com.processEvent(idClient, objServicio,
	    				request);

	    		if (response != null) { // operación con respuesta
	    			// 4.3 Enviar la respuesta al cliente
	    			com.sendReply(idClient, response);
    			}
			}
			
			// 3.4 Cerrar el objeto de servicio del cliente desconectado
			objServicio.close();
		}
	}
}
