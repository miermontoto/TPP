package comun;

/**
 * Excepción para operación desconocida. 
 */
public class AccionNoPermitida extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5634864553348079172L;

	/**
	 * Operación de servicio desconocida.
	 */
	public AccionNoPermitida() {
		super();
	}
	
	/**
	 * Operación de servicio desconocida.
	 * @param str mensaje de error
	 */
	public AccionNoPermitida(String str) {
		super(str);
	}
}
