package servidor;

import comun.AccionNoPermitida;
import comun.ISaludador;

/**
 * Clase del objeto de operaciones de servicio (OOS).
 *
 */
public class SaludadorOOS implements ISaludador {
	// área de datos
	private int estado;		// estado de control
	private String str;		// estado de datos
	
	private final static String SALUDO_DEFECTO = "¡Hola. Soy el saludador!";
	
	/**
	 * Crea el objeto de servicio con el saludo por defecto.
	 */
	public SaludadorOOS() {
		this(SALUDO_DEFECTO);
	}
	
	/**
	 * Crea el objeto de servicio con el saludo que se especifica.
	 * @param str el saludo del objeto
	 */
	public SaludadorOOS(String str) {
		this.str = (str == null || str.isEmpty()) ? SALUDO_DEFECTO : str;
		this.estado = 0;
	}
	
	@Override
	public String saluda() {
		estado = 1;
		return str;
	}
	
	@Override
	public void cambiaSaludo(String str) throws AccionNoPermitida {
		if(estado == 0) throw new AccionNoPermitida();
		this.str = str.isEmpty() || str == null ? SALUDO_DEFECTO : str;
	}
	
	@Override
	public void reset() {
		estado = 0;
	}

}
