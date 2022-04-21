package cliente;

import java.io.IOException;
import java.util.List;

import comun.JuegoBarcos;
import lib.ChannelException;
import lib.CommClient;
import lib.Menu;
import lib.ProtocolMessages;

public class Cliente {

	private static CommClient com;	// canal de comunicación del cliente (singleton)
	private static Menu m; // ChoiceMenu del cliente.
	private static Menu mo; // ChoiceMenu de barcos por colocar.

	private static void colocarBarco(int b) {

		// Se solicita por consola la posición del barco a colocar.
		System.out.print("Introduzca las coordenadas del barco: ");
		String coords = mo.input().nextLine();
		
		sendAndHandlePetition("colocarBarco", coords);
		
	} // colocarBarco

	private static void tirar() {
		// Se solicita por consola la posición del tiro.
		System.out.print("Introduzca las coordenadas del tiro: ");
		String coords = m.input().nextLine();
		
		sendAndHandlePetition("tirar", coords);
		
	} // tirar

	/**
	 * Método que limpia la salida.
	 */
	private static void limpiar() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
	}

	/**
	 * Método que devuelve la cantidad de barcos que quedan por colocar y
	 * actualiza el ChoiceMenu de barcos por colocar.
	 * @return La longitud del barco a colocar.
	 */
	private static int getBarcoAColocar() {
		mo = new Menu("Barcos disponibles", "Seleccione un barco: ");
	
		// Obtener lista de barcos disponibles que faltan por colocar.
		Object lista = sendAndHandlePetition("barcosPorColocar");
		if(lista instanceof Exception) crashPrintException((Exception) lista);
		List<Integer> barcos = (List<Integer>) lista;
		for(int longitudBarco : barcos) mo.add("Barco de tamaño " + longitudBarco, longitudBarco);
		try {return mo.getInteger();} 
		catch (NullPointerException npe) { // Si se escoge la opción 0, se sale del cliente sin errores.
			disconnectProdecure(); 
			return 0; // ← ESTO NO PUEDE PASAR! pero java es inútil.
		} 
	}

	/**
	 * Método que actualiza la lista de barcos por colocar.
	 * @return Longitud de la lista.
	 */
	private static int barcosPorColocar() {
		Object lista = sendAndHandlePetition("barcosPorColocar");
		if(lista instanceof Exception) crashPrintException((Exception) lista);
		return ((List<Integer>) lista).size();
	}

	/**
	 * Método que imprime el tablero de barcos mediante una petición al servidor.
	 */
	private static void mostrarBarcos() {
		limpiar();
		System.out.println(sendAndHandlePetition("obtenerBarcos"));
	}

	private static void mostrarTiros() {
		limpiar();
		System.out.println(sendAndHandlePetition("obtenerTiros"));
	}

	/**
	 * Método que a partir del nombre de una petición, la crea, espera por la respuesta
	 * y la devuelve. Maneja cualquier excepción que pueda generar.
	 * @param s El nombre de la petición.
	 * @param args Los argumentos de la petición.
	 * @return El objeto que devuelve el servidor. Puede ser {@code null}.
	 */
	private static Object sendAndHandlePetition(String petitionName, Object... args) {
		ProtocolMessages petition;
		if(args.length == 0) petition = new ProtocolMessages(petitionName);
		else petition = new ProtocolMessages(petitionName, args);

		try {com.sendEvent(petition);} 
		catch (IOException | ChannelException ep) {printException(ep);}

		try { // Las excepciones pueden ser de muchos tipos en este try/catch.
			ProtocolMessages respuesta = com.waitReply();
			return com.processReply(respuesta);
		} catch (Exception e) {
			printException(e);
			return e;
		}
	}

	/**
	 * Método privado que imprime cualquier excepción que devuelva el servidor.
	 * @param e Excepción a imprimir.
	 */
	private static void printException(Exception e) {
		System.err.printf("%s (%s)%n", e.getClass().getSimpleName(), e.getMessage());
	}

	/**
	 * Método que desconecta al cliente del servidor de manera correcta.
	 * También cierra los menús creados.
	 */
	private static void disconnectProdecure() {
		// 4. Cerrar la(s) interfaz(es).
		m.close();
		mo.close();

		// 5. Desconectar al cliente.
		com.disconnect();

		// 6. Cerrar el cliente.
		System.exit(0);
	}

	private static void crashPrintException(Exception e) {
		printException(e);
		System.exit(1);
	}
	
    public static void main(String[] args) {

		try {com = new CommClient();} // 1. Crear el canal de comunicación
		catch (IOException | ChannelException e) {crashPrintException(e);}
		
		try {com.activateMessageLog();} // 1.1. Activar el registro de mensajes del cliente
		catch (ChannelException e) {crashPrintException(e);}
		
		
		while(barcosPorColocar() != 0) { // colocar todos los barcos disponibles.
			mostrarBarcos();
			colocarBarco(getBarcoAColocar());
		}

		
		sendAndHandlePetition("iniciarJuego"); // Iniciar la partida (buscar oponente).
		// A partir de este punto, el cliente está en partida.
		
		try {
			do {
				Object temp = sendAndHandlePetition("turno");
				if(temp instanceof Exception) crashPrintException((Exception) temp);
				int turnStatus = (int) temp;
				if(turnStatus == 0) { // Si el jugador no tiene el turno.
					mostrarBarcos();
					try {Thread.sleep(1500);} catch (InterruptedException ie) {printException(ie);}
				} else if(turnStatus == 1) {
					mostrarTiros();
					tirar();
				}
			} while (m.runSelection());
		} catch (ChannelException | IOException e) {
			crashPrintException(e);
		} finally {disconnectProdecure();}
		
	} // main

} // class Cliente
