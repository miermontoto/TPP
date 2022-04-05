package cliente;

import java.io.IOException;

import lib.ChannelException;
import lib.CommClient;
import lib.Menu;
import lib.ProtocolMessages;
import lib.UnknownOperation;
import comun.AccionNoPermitida;

public class Cliente {

	private static CommClient com;	// canal de comunicación del cliente (singleton)
	private static Menu m;			// interfaz (singleton)
	
	private static void saludame() throws IOException, ChannelException {
		// Crear mensaje a enviar.
		ProtocolMessages peticion =
				new ProtocolMessages("saluda");
		// Enviar evento al servidor.
		com.sendEvent(peticion);
		try {
			// Esperar respuesta.
			ProtocolMessages respuesta = com.waitReply();
			// Procesar respuesta.
			Object resultado = com.processReply(respuesta);
			System.out.println(resultado);
		} catch (ClassNotFoundException | UnknownOperation e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (IOException | ChannelException e) {
			throw e;
		} catch (Exception e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
		}
		
	} // saludame
	
	private static void numUsuarios() throws IOException, ChannelException {
		// crear mensaje a enviar
		ProtocolMessages peticion =
				new ProtocolMessages("usuariosConectados");
		// enviar mensaje de solicitud al servidor
		com.sendEvent(peticion);
		try {
			// esperar respuesta, excepto si la petición es oneway
			ProtocolMessages respuesta = com.waitReply();
			// procesar respuesta o excepción
			Object resultado = com.processReply(respuesta);
			System.out.printf("Usuarios conectados: %s\n", resultado);
		} catch (ClassNotFoundException e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (UnknownOperation e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (IOException | ChannelException e) {
			throw e;
		} catch (Exception e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
		}

	} // numUsuarios

	private static void randomizarSaludo() throws IOException, ChannelException {
		String saludo = "Hola ";
		// randomizar cadena de 8 caracteres de largo.;
		for (int i = 0; i < 8; i++) saludo += (char) (Math.random() * 26 + 'a');
		// Imprimir el nuevo saludo.
		System.out.printf("Saludo: %s\n", saludo);
		// crear mensaje a enviar
		ProtocolMessages peticion =
				new ProtocolMessages("cambiaSaludo", saludo);
		// enviar mensaje de solicitud al servidor
		com.sendEvent(peticion);
		try {
			// esperar respuesta, excepto si la petición es oneway
			ProtocolMessages respuesta = com.waitReply();
			// procesar respuesta o excepción
			Object resultado = com.processReply(respuesta);
			System.out.printf("Saludo randomizado: %s\n", resultado);
		} catch (ClassNotFoundException e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (UnknownOperation e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (IOException | ChannelException e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
		} catch (Exception e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
		}

	} // randomizarSaludo

	private static void cambiandoSaludo()
			throws IOException, ChannelException {
		// Implementar esta operación: el texto del nuevo saludo deberá
		// solicitarse por teclado y tratarse convenientemente todas las
		// excepciones. Sólo se llevarán al main las excepciones críticas
		// IOException y ChannelException para dar un mensaje de error y
		// parar el cliente.

		// Se solicita por teclado el texto del nuevo saludo.
		System.out.print("Introduzca el nuevo saludo: ");
		String saludo = m.input().nextLine();
		
		// Se crea el mensaje a enviar.
		ProtocolMessages peticion =
				new ProtocolMessages("cambiaSaludo", saludo);
		// Se envía el mensaje al servidor.
		com.sendEvent(peticion);
		// Se espera la respuesta del servidor.
		try {
			ProtocolMessages respuesta = com.waitReply();
			// Se procesa la respuesta o excepción.
			Object resultado = com.processReply(respuesta);
			System.out.printf("Saludo cambiado: %s\n", resultado);
		} catch (ClassNotFoundException e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (UnknownOperation e) {
			System.err.printf("Recibido del servidor: %s\n",
					e.getMessage());
		} catch (IOException | ChannelException e) {
			throw e;
		} catch (AccionNoPermitida e) {
			System.err.println("Acción no permitida");
		} catch (Exception e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
		}
		// Se muestra el nuevo saludo.
		System.out.printf("Saludo: %s\n", saludo);
		
	} // cambiandoSaludo
	
	private static void msgReset()
			throws IOException, ChannelException {
		// crear el mensaje a enviar al servidor
		ProtocolMessages peticion = new ProtocolMessages("reset");
		// enviar el mensaje de solicitud al servidor
		// petición 'oneway', sin respuesta
		com.sendEvent(peticion);	
	} // msgReset

	public static void interfazCliente() {
		// crea el menú m
    	m = new Menu("\nSaludador", "Opción ? ");
    	
    	// añadir al menú las opciones y la función anónima
		m.add("Saludar", () -> saludame());
		m.add("Número de usuarios", () -> numUsuarios());
		m.add("Cambiar saludo", () -> cambiandoSaludo());
		m.add("Reset", () -> msgReset());
		m.add("Randomizar saludo", () -> randomizarSaludo());
	}	
	
    public static void main(String[] args) {
		// 1. Crear el canal de comunicación y establecer la
		// conexión con el servicio por defecto en localhost
		try {
			com = new CommClient();
		} catch (IOException | ChannelException e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
			System.exit(1);
		}
		
		// 1.1. Activar el registro de mensajes del cliente
		try {
			com.activateMessageLog();
		} catch (ChannelException e) {
			System.err.printf("%s: %s\n", e.getClass().getSimpleName(),
					e.getMessage());
			System.exit(1);
		}

		
		

		
		try {
			// 2. Crear la interfaz
			interfazCliente();

			// 3. Lanzar eventos mediante la interfaz
			m.run();
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
