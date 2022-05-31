package servidor;

import java.io.IOException;

import lib.ChannelException;
import lib.CommServer;
import lib.ProtocolMessages;
import optional.Trace;

public class Hilos implements Runnable {
	private CommServer com;		// canal del comunicación del servidor
	private int idCliente;		// ID del cliente	
	private Servicio oos;		// OOS del cliente

	public Hilos(int idCliente, CommServer com) {
		this.idCliente = idCliente;
		this.com = com;
	}

	@Override
	public void run() {
		ProtocolMessages peticion;
		ProtocolMessages respuesta;

		try {
			Trace.print(idCliente,
					"-- Creando el objeto de servicio ... ");
			oos = new Servicio(idCliente);
			Trace.println(idCliente, "hecho.");

			while (!com.closed(idCliente)) {
				try {
					// espera una petición del cliente
					peticion = com.waitEvent(idCliente);
					// evaluar la orden recibida
					respuesta = com.processEvent(idCliente, oos, peticion);

					if (respuesta != null) { // tiene respuesta
						// enviar el resultado al cliente
						com.sendReply(idCliente, respuesta);
					}
				} catch (ClassNotFoundException e) {
					System.err.printf("Recibido del cliente %d: %s\n",
							idCliente, e.getMessage());
				}				
			}
		} catch (IOException | ChannelException e) {
			System.err.printf("Error: %s\n", e.getMessage());
		} finally {
			// cerrar el OOS
			if (oos != null) {
				oos.close();
			}
		}
	}

}
