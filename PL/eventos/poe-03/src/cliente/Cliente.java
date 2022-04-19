package cliente;

import java.io.IOException;
import java.util.List;

import lib.ChannelException;
import lib.CommClient;
import lib.Menu;
import lib.ProtocolMessages;
import lib.UnknownOperation;
import comun.AccionNoPermitida;

public class Cliente {

	private static CommClient com;	// canal de comunicación del cliente (singleton)
	private static Menu m; // ChoiceMenu del cliente.
	private static Menu mo; // ChoiceMenu de barcos por colocar.

	private static void colocarBarco(int b) throws IOException, ChannelException {

		// Se solicita por consola la posición del barco a colocar.
		System.out.print("Introduzca las coordenadas del barco: ");
		String coords = m.input().nextLine();
		
		// Se crea el mensaje a enviar.
		ProtocolMessages peticion = new ProtocolMessages("colocarBarco", coords);

		// Se envía el mensaje aDPOl servidor.
		com.sendEvent(peticion);
		
		// Esperar por la respuesta.
		try {
			ProtocolMessages respuesta = com.waitReply();
			// Procesar respuesta.
			Object psbexp = com.processReply(respuesta);
		} catch (ClassNotFoundException | UnknownOperation e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (IOException | ChannelException e) {
			throw e;
		} catch (Exception e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
		}
		
	} // colocarBarco

	/**
	 * Método que limpia la salida.
	 */
	private static void limpiar() {
		System.out.print("\033[H\033[2J");
	}

	/**
	 * Método que devuelve la cantidad de barcos que quedan por colocar y
	 * actualiza el ChoiceMenu de barcos por colocar.
	 * @return la cantidad de barcos que quedan por colocar.
	 * @throws Exception
	 */
	private static int barcosPorColocar() {
		mo = new Menu("Barcos disponibles", "Seleccione un barco: ");
			
				// Obtener lista de barcos disponibles que faltan por colocar.
				ProtocolMessages peticiónLista = new ProtocolMessages("barcosPorColocar");

				// Enviar evento al servidor.
				try {
					com.sendEvent(peticiónLista);
				} catch (IOException | ChannelException e) {
					System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
							e.getMessage());
				}
				int length = 0;
				try {
					// Esperar respuesta.
					ProtocolMessages respuesta = com.waitReply();
					// Procesar respuesta.
					List<Integer> resultado = (List<Integer>) com.processReply(respuesta);
					// Mostrar lista de barcos disponibles.
					for(int b : resultado) mo.add("Barco de tamaño " + b, b);
					length = mo.getInteger();
				} catch(Exception e) {
					System.err.printf("Recibido del servidor: %s\n",
							e.getMessage());
				}
				return length;
	}
	
    public static void main(String[] args) {

		try { // 1. Crear el canal de comunicación
			com = new CommClient();
		} catch (IOException | ChannelException e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
			System.exit(1);
		}
		
		try { // 1.1. Activar el registro de mensajes del cliente
			com.activateMessageLog();
		} catch (ChannelException e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
			System.exit(1);
		}
		
		
		try { // Colocar todos los barcos disponibles.
			while(barcosPorColocar() != 0) colocarBarco(mo.getInteger());
		} catch (ChannelException | IOException e1) {
			e1.printStackTrace();
		}
		

		
		try {
			// 2. Crear la interfaz
			// crea el menú m
	    	m = new Menu("\nBattleship", "Opción: ");
	    	

			// 3. Lanzar eventos mediante la interfaz
			do {
				// Imprimir el tablero.

				ProtocolMessages tablero = new ProtocolMessages("obtenerBarcos");
				com.sendEvent(tablero);

				try {
					ProtocolMessages respuesta = com.waitReply();
					Object restablero = com.processReply(respuesta);
					System.out.println(restablero);
				} catch (ClassNotFoundException | UnknownOperation e) {
					System.err.printf("Recibido del servidor: %s\n",
							e.getMessage());
				} catch (IOException | ChannelException e) {
					throw e;
				} catch (Exception e) {
					System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
							e.getMessage());
				}
			} while (m.runSelection());
		} catch (ChannelException | IOException e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
			System.exit(1);
		} finally {
			// 4. Cerrar la entrada de la interfaz
			m.close();

			// 5. Desconectar el cliente
			com.disconnect();
		}
		
	} // main

} // class Cliente
