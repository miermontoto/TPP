package servidor;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import comun.AccionNoPermitida;
import comun.BarcoMalPosicionado;
import comun.CoordenadasNoValidas;
import comun.JuegoBarcos;
import comun.TamanioBarcoNoValido;

public class Servicio implements JuegoBarcos {
	
	private final static String PATTERN_COORD = "^(\\p{Alpha}\\d{1,2}\\s*){2}$";

	// Información común para todos los OOSs

	/**
	 * Jugadores conectados al servicio y esperando para jugar
	 * (se requiere que el jugador haya colocado todos sus barcos)
	 */
	private volatile static List<Integer> jugadoresEnEspera = new LinkedList<>();

	/**
	 * Tableros con la disposición de los barcos de los jugadores
	 * (como clave se utiliza el identificador del cliente)
	 */
	private volatile static Map<Integer, Tablero> oceanoJugadores = new HashMap<>();

	/**
	 * Oponentes en juego (clave y valor, identificador del cliente)
	 */
	private volatile static Map<Integer, Integer> oponente = new HashMap<>();

	/**
	 *  Indica si es el turno de juego de un jugador.
	 */ 
	private volatile static Map<Integer, Boolean> turnoJugador = new HashMap<>();

	/**
	 * Número de barcos no hundidos de cada jugador en el océano.
	 */
	private volatile static Map<Integer, Integer> barcosEnOceano = new HashMap<>();

	// Información exclusiva de un OOS
	private int idClient;						// identificador
	private List<Integer> barcosRestantes;		// tamaños de barcos pendientes de colocar en el tablero
	private Tablero oceano;						// tablero propio con los barcos
	private Tablero tiros;						// tablero contrario, inicialmente en blanco
	private int estado;							// estado del juego

	/**
	 * Constructor de la clase.
	 */
	public Servicio(int id) {
		// Inicializar el OOS
		estado = 0;
		idClient = id;
		oceano = new Tablero();
		tiros = new Tablero();
		barcosRestantes = new LinkedList<>(JuegoBarcos.BARCOS);
		
		// Actualizar estructuas de datos volátiles
		oceanoJugadores.put(idClient, this.oceano);
		turnoJugador.put(idClient, false);
		barcosEnOceano.put(idClient, 0);
	}
	/**
	 * Retorna las coordenadas proporcionadas por la cadena dada.
	 * @param str representación como cadena de caracteres de las coordenadas
	 * @return las coordenadas
	 * @throws CoordenadasNoValidas si el formato de la cadena no es correcto
	 * o la posición dada desborda el tablero
	 */
	private Pair<Integer, Integer> position(String str)
			throws CoordenadasNoValidas {

		if (str == null || str.isEmpty() || !str.matches("^\\p{Alpha}\\d{1,2}$")) {
			throw new CoordenadasNoValidas(
					"Patrón de coordenadas: ^\\p{Alpha}\\d{1,2}$");
		}

		int row = str.toUpperCase().charAt(0) - (int)'A';
		int col = str.charAt(1) - (int)'0';

		if (str.length() > 2) {
			col = col * 10 + str.charAt(2) - (int)'0';
		}

		if (row < 0 || row > DIMENSION ||
				col < 0 || col > DIMENSION) {
			throw new CoordenadasNoValidas("Tablero desbordado");
		}

		return new Pair<>(row, col);
	}

	@Override
	public void colocarBarco(String str)
			throws CoordenadasNoValidas, BarcoMalPosicionado, TamanioBarcoNoValido, AccionNoPermitida {
		if (this.estado != 0) {
			throw new AccionNoPermitida("colocarBarco");
		}

		if (str == null || str.isEmpty() || !str.matches(PATTERN_COORD)) {
			throw new IllegalArgumentException(
					String.format("Patrón de coordenadas: %s", PATTERN_COORD));
		}

		Pattern pattern = Pattern.compile("\\p{Alpha}\\d{1,2}");
		Matcher matcher = pattern.matcher(
				str.subSequence(0, str.length()));
		matcher.find();
		String str0 = matcher.group();
		matcher.find();
		String str1 = matcher.group();

		Pair<Integer, Integer> p0 = position(str0);
		Pair<Integer, Integer> p1 = position(str1);

		Integer size = this.oceano.colocarBarco(p0, p1, this.barcosRestantes);

		// se ha colocado un barco de tamaño size
		this.barcosRestantes.remove(size);
		barcosEnOceano.put(this.idClient, barcosEnOceano.get(this.idClient) + 1);
		
		// Si ya no quedan barcos por colocar, se cambia al siguiente estado.
		if (this.barcosRestantes.isEmpty()) this.estado = 1;
		
	}

	/**
	 * Cambia el estado del OOS del jugador según haya hecho blanco
	 * o no en el último tiro. <p>
	 * Si se ha hecho blanco, se mueve el estado hacia delante una posición.
	 * En el caso de estar en el tercer turno consecutivo, se pierde el turno. <p>
	 * Si no se ha hecho blanco, se pierde el turno.
	 * @param blanco {@code true} si el tiro ha alcanzado un barco
	 * del oponente
	 */
	private void actualizarEstado(boolean blanco) {
		this.estado = blanco && estado != 5 ? estado++ : 2;
	}

	// Métodos de la interfaz JuegoBarcos

	@Override
	public String tableroBarcos() {
		return oceano.toString();
	}

	@Override
	public String tableroTiros() {
		return tiros.toString();
	}

	@Override
	public List<Integer> barcosPorColocar() throws AccionNoPermitida {
		if(estado != 0) throw new AccionNoPermitida("barcosPorColocar");
		return this.barcosRestantes;
	}

	/**
	 * Método que empareja a dos jugadores y comienza la partida.
	 * El jugador que invoca a este método es el primero en jugar. <p>
	 * <h3> Información de estados </h3>
	 * <ul> <li> 0: ANP </li>
	 * <li> 1: 1/2 </li>
	 * <li> 2: ANP </li>	
	 * <li> 3: ANP </li>
	 * <li> 4: ANP </li>
	 * <li> 5: ANP </li> </ul>
	 */
	@Override
	public boolean iniciarJuego() throws AccionNoPermitida {
		// Si no se está en el estado 1, no se puede iniciar el juego.
		if (this.estado != 1) throw new AccionNoPermitida("iniciarJuego");

		if(oponente.containsKey(idClient)) estado = 2;
		else {
			if(jugadoresEnEspera.isEmpty()) jugadoresEnEspera.add(idClient);
			else {
				// Si solo está el cliente en la lista de espera, devolver falso.
				if(jugadoresEnEspera.size() == 1 && jugadoresEnEspera.contains(idClient)) return false;

				// Si hay dos o más clientes en la lista de espera, se inicia el juego.
				jugadoresEnEspera.remove(idClient); // Se elimina al propio jugador de la lista de espera.
				int idOponente = jugadoresEnEspera.remove(0); // Se obtiene el ID del oponente.
				oponente.put(idClient, idOponente); // Se establecen las relaciones entre los clientes.
				oponente.put(idOponente, idClient);
				estado = 2; // Se cambia el estado.
			}
		}
		return estado == 2;
	}

	/**
	 * Método que informa sobre el estado de la partida una vez comenzada.
	 * @return {@code 0}, {@code 1} o {@code JuegoBarcos.FINAL_JUEGO} si el jugador
	 * no tiene el turno, si lo tiene o se ha terminado la partida respectivamente.
	 */
	@Override
	public int turno() throws AccionNoPermitida {
		if(this.estado < 2) throw new AccionNoPermitida("turno");
		if(turnoJugador.get(idClient)) {
			if(this.estado == 2) this.estado = 3;
			return 1;
		} else {
			if(turnoJugador.get(oponente.get(idClient))) return 0;
			else return JuegoBarcos.FINAL_JUEGO;
		}
	}

	@Override
	public String coordenadasTiro(String tiro) throws AccionNoPermitida, CoordenadasNoValidas {
		if(this.estado < 3) throw new AccionNoPermitida("coordenadasTiro");
		if(tiro == null || tiro.isEmpty() || !tiro.matches(PATTERN_COORD)) {
			throw new CoordenadasNoValidas(
					String.format("Patrón de coordenadas: %s", PATTERN_COORD));
		}

		Pair<Integer, Integer> p = position(tiro);

		Celda res = oceanoJugadores.get(oponente.get(idClient)).tiro(p.first(), p.second());
		boolean check = false;
		String newStatus = "Agua";
		if(res == Barco.TOCADO) {check = true; return "Tocado";}
		if(res.esBarco()) {check = true; return "Hundido";}
		actualizarEstado(check);
		tiros.tabla[p.first()][p.second()] = res;
		if(newStatus.equals("Hundido")) tiros.registrarBarco((Barco) res);
		return newStatus;
	}

	@Override
	public int numBarcosEnOceano() {
		return barcosEnOceano.get(this.idClient);
	}

}
