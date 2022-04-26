package cliente;

import java.io.IOException;
import java.util.List;

import lib.ChannelException;
import lib.CommClient;
import lib.Menu;
import lib.ProtocolMessages;

public class Cliente {

	private static CommClient com;	// canal de comunicación del cliente (singleton)
	private static Menu m = new Menu("private", "test"); // ChoiceMenu del cliente.

	private static void colocarBarco() {
		// Se imprime la longitud de los barcos que quedan por colocar.
		List<Integer> lista = (List<Integer>) sendAndHandlePetition("barcosPorColocar");
		System.out.println("Barcos por colocar:");
		for(int c : lista) System.out.println("- Barco de longitud " + c);

		// Se solicita por consola la posición del barco a colocar.
		System.out.print("Introduzca las coordenadas de un barco ('exit' para salir): ");
		String coords = m.input().nextLine();
		if(coords.equals("exit")) disconnectProcedure();
		sendAndHandlePetition("colocarBarco", coords);
		
	} // colocarBarco

	private static void tirar() {
		// Se solicita por consola la posición del tiro.
		System.out.print("Introduzca las coordenadas del tiro: ");
		String coords = mo.input().nextLine();
		
		sendAndHandlePetition("tirar", coords);
		
	} // tirar

	/**
	 * Método que limpia la salida.
	 */
	private static void limpiar() {
		try {
			Runtime.getRuntime().exec("clear");
			System.out.flush();
		} catch(IOException e) {System.err.println("No se pudo limpiar la pantalla");}
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
	 * Método que imprime lo que devuelva la petición introducida.
	 */
	private static void printPetition(String petitionName) {
		limpiar();
		System.out.println(sendAndHandlePetition(petitionName));
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
		e.printStackTrace();
	}

	/**
	 * Método que desconecta al cliente del servidor de manera correcta.
	 * También cierra los menús creados.
	 */
	private static void disconnectProcedure() {
		m.close(); // Cerrar interfaz.

		com.disconnect(); // Desconectar al cliente.
		System.exit(0); // Cerrar la aplicación.
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
			colocarBarco();
		}

		mostrarBarcos();
		System.out.print("Buscando oponente... ");
		while(!sendAndHandlePetition("iniciarJuego").equals(true)) {
			try {Thread.sleep(2500);}
			catch(InterruptedException e) {crashPrintException(e);}
		}
		System.out.println("Encontrado.");
		
		
		for(;;) {
			Object temp = sendAndHandlePetition("turno");
			if(temp instanceof Exception) crashPrintException((Exception) temp);
			int turnStatus = (int) temp;
			if(turnStatus == 0) { // Si el jugador no tiene el turno.
				printPetition("obtenerBarcos");
				try {Thread.sleep(1500);} catch (InterruptedException ie) {printException(ie);}
			} else if(turnStatus == 1) {
				printPetition("obtenerTiros");
				tirar();
			} else {
				System.out.println("Partida finalizada.");
				disconnectProcedure();
			}
		}
		
		
	} // main

} // class Cliente
