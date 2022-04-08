package comun;

import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Interfaz de servicio.
 */
public interface JuegoBarcos extends lib.DefaultService {
	/**
	 * Dimensión de los tableros
	 */
	public final static int DIMENSION = 10;

	/**
	 * Lista de tamaños de barcos a colocar en el océano
	 */
	public final static List<Integer> BARCOS =
			// Versión para pruebas
			Stream.of(3, 2).collect(Collectors.toCollection(LinkedList::new));
//			// Versión popular
//			Stream.of(4, 3, 3, 2, 2, 2, 1, 1, 1, 1).collect(Collectors.toCollection(LinkedList::new));
//			// Versión MB electrónica de 1989
//			Stream.of(5, 4, 3, 3, 2).collect(Collectors.toCollection(LinkedList::new));
//			 Versión MB en papel 1938
//			Stream.of(5, 4, 3, 2, 2, 1, 1).collect(Collectors.toCollection(LinkedList::new));

	/**
	 * Estado del OOS cuando el juego finaliza
	 */
	public final static int FINAL_JUEGO = 10;
	
	/**
	 * La representación como cadena de caracteres del tablero océano.
	 * @return la cadena de caracteres que representa el tablero océano
	 */
	String tableroBarcos();
	
	/**
	 * La representación como cadena de caracteres del tablero de tiros.
	 * @return la cadena de caracteres que representa el tablero de tiros
	 */
	String tableroTiros();
	
	/**
	 * Retorna la lista de tamaños de barco que restan por ubicar en el
	 * tablero océano.
	 * @return la lista de tamaños de barco a colocar en el océano
	 * @throws AccionNoPermitida si el estado del juego no es el inicial
	 */
	List<Integer> barcosPorColocar() throws AccionNoPermitida;
	
	/**
	 * Coloca un barco en las coordenas especificadas del tablero océano.
	 * @param str la cadena con las coordenadas de inicio y fin del tablero
	 * @throws IllegalArgumentException si el formato de coordenadas es incorrecto
	 * @throws CoordenadasNoValidas si las coordenadas dadas desbordan el océano
	 * @throws BarcoMalPosicionado si el barco es contiguo a otro (sin agua entre ambos)
	 * @throws TamanioBarcoNoValido si el tamaño del barco no es el adecuado
	 * @throws AccionNoPermitida si el estado del juego no es el inicial
	 */
	void colocarBarco(String str)
			throws CoordenadasNoValidas, BarcoMalPosicionado, TamanioBarcoNoValido, AccionNoPermitida;
	
	/**
	 * Retorna {@code true} si el jugador tiene un oponente o se le puede
	 * asignar, con lo que puede dar comienzo el juego.
	 * @return {@code true} si hay dos jugadores emparejados y, por tanto,
	 * puede comenzar el juego
	 * @throws AccionNoPermitida si el juego ha comenzado
	 */
	boolean iniciarJuego() throws AccionNoPermitida;
	
	/**
	 * Retorna 0, 1 o {@code FINAL_JUEGO}, si el jugador no tiene el turno
	 * de juego, si lo tiene, o se alcanza el final de la partida, respectivamente.
	 * @return 0, 1, o {@code FINAL_JUEGO}
	 * @throws AccionNoPermitida si el juego no ha comenzado
	 */
	int turno() throws AccionNoPermitida;
	
	/**
	 * Coordenadas del tablero oceáno del oponente donde se ataca.
	 * @param tiro las coordenadas
	 * @return {@code "Agua"}, {@code "Tocado"} o {@code "Hundido"} según se
	 * halla fallado, alcanzado un barco o hundido, respectivamente
	 * @throws AccionNoPermitida si el juego no ha comenzado o ha finalizado,
	 * o bien si el jugador no tiene el turno
	 * @throws CoordenadasNoValidas si las coordenadas especificadas son
	 * incorrectas o están fuera de los límites del tablero océano
	 */
	String coordenadasTiro(String tiro)
			throws AccionNoPermitida, CoordenadasNoValidas;
	
	/**
	 * Retorna el número de barco del océano que no estén hundidos.
	 * @return número de barcos no hundidos
	 */
	int numBarcosEnOceano();
	
}
