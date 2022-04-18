package servidor;

import java.io.IOException;
import lib.ChannelException;
import lib.CommServer;
import optional.Trace;

public class Servidor {
	
	private static void registrarOperaciones(CommServer com) {		
		// registro de las operaciones de servicio
		com.addAction("colocarBarco",
				(o, x) -> ((Servicio)o).colocarBarco((String) x[0]));
		com.addFunction("obtenerBarcos",
				(o, x) -> ((Servicio)o).tableroBarcos());
		com.addFunction("obtenerTiros",
				(o, x) -> ((Servicio)o).tableroTiros());
		com.addFunction("barcosPorColocar",
				(o, x) -> ((Servicio)o).barcosPorColocar());
		com.addFunction("iniciarJuego",
				(o, x) -> ((Servicio)o).iniciarJuego());
		com.addFunction("turno",
				(o, x) -> ((Servicio)o).turno());
				
	} // registrarOperaciones

	public static void main(String[] args) {
		CommServer com;			// canal de comunicación del servidor
		int idClient;			// identificador del cliente
		
		try {
			// 1. Crear canal de comunicación
			com = new CommServer();
			
			// activa la traza en el servidor (por defecto está
			// desactivada). Se recomienda activarla para que en
			// consola se muestre la acción del servidor
			Trace.activateTrace(com);
			
			// activa el registro de mensajes del servidor (por
			// defecto está desactivado, operación opcional)
			com.activateMessageLog();

			// 2. Registrar las operaciones de servicio
			registrarOperaciones(com);
			
			// ofrecer el servicio (queda a la escucha)
			while (true) {
				// 3.1 Esperar por un cliente (operación bloqueante) e identificar
				idClient = com.waitForClient();
				
				// 3.2 Lanzar un hilo donde se creará el OOS y tendrá
				//     lugar el intercambio de mensajes con el cliente
				new Thread(new Hilos(idClient, com)).start();				
			} // while
		} catch (IOException | ChannelException e) {
			// excepciones críticas, se para el servidor
			System.err.printf("Error: %s\n", e.getMessage());
			e.printStackTrace();
		}
		
	} // main
					
} // class Servidor
