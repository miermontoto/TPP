package servidor;

import java.io.IOException;

import lib.ChannelException;
import lib.CommServer;
import lib.ProtocolMessages;

public class Hilos implements Runnable {
	private int idClient;				// ID del cliente
	private CommServer com;				// canal de comunicación del servidor
	
	/**
	 * Crea un hilo de ejecución para el OOS del cliente identificado
	 * como se especifica.
	 * @param idClient el identificador del cliente
	 * @param com el canal de comunicación del servidor
	 */
	public Hilos(int idClient, CommServer com) {
		this.idClient = idClient;
		this.com = com;
	}

	/**
	 * Ejecuta el hilo correspondiente a un cliente. Crea el objeto de
	 * operaciones de servicio (OOS) para este cliente y permite
	 * la conversación con el cliente (intercambia mensajes) hasta
	 * el momento en que éste se desconecte.
	 * @see java.lang.Runnable#run()
	 */
	@Override
	public void run() {
		SaludadorOOS objServicio = null;	// objeto de operaciones de servicio
		ProtocolMessages request;			// mensaje entrante (petición del cliente)
		ProtocolMessages response;			// mensaje salidente (respuesta para el cliente)

		try {
			// 1. Crear el objeto de servicio en el hilo para un cliente
			objServicio = new SaludadorOOS();

			// 2. Intercambiar mensajes con ese cliente
			while (!com.closed(idClient)) {
				try {
		    		// 2.1 Esperar a recibir del cliente la orden serializada
					request = com.waitEvent(idClient);
					
					// 2.2 Evaluar la orden recibida
		    		response = com.processEvent(idClient, objServicio,
		    				request);
					
		    		if (response != null) { // operación con respuesta
		    			// 2.3 Enviar la respuesta al cliente
		    			com.sendReply(idClient, response);
	    			}
				}
				catch (ClassNotFoundException e) {
					// excepción no crítica (se pierde un mensaje)
					System.err.printf(
							"Error en la petición del cliente %d: %s\n",
							idClient, e.getMessage());
				}
			}
		} catch (IOException | ChannelException e) {
			System.err.printf("Error: %s\n", e.getMessage());
		} finally {
			// 3. Cerrar el objeto de servicio para el cliente desconectado
			if (objServicio != null) {
				objServicio.close();
			}
		}
	}

}
