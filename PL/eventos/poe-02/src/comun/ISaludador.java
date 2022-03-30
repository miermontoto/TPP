package comun;

/**
 * Interfaz de las operaciones de servicio.
 */
public interface ISaludador extends lib.DefaultService {
	
	/**
	 * Retorna una cadena de texto.
	 * @return una cadena de texto
	 */
	String saluda();
	
	/**
	 * Retorna el número de usuarios conectados al servicio.
	 * @return número de usuarios que utilizan el servicio
	 */
	int usuariosConectados();
	
	/**
	 * Modifica el texto de saludo con la cadena que se especifica
	 * (operación opcional).
	 * @param str el nuevo saludo
	 * @throws UnsupportedOperationException si esta operación no
	 * está soportada
	 * @throws AccionNoPermitida si en el estado actual del sistema
	 * la operación no se puede realizar
	 */
	default void cambiaSaludo(String str) throws AccionNoPermitida {
		throw new UnsupportedOperationException();
	}
	
	/**
	 * Reinicia el servicio.
	 * @throws UnsupportedOperationException si esta operación no
	 * está soportada
	 */
	default void reset() {
		throw new UnsupportedOperationException();
	}

}
