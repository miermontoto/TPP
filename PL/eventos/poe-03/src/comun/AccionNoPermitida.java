package comun;

public class AccionNoPermitida extends Exception {
	private static final long serialVersionUID = -5634864553348079172L;

	public AccionNoPermitida() {
		super();
	}

	public AccionNoPermitida(String mensaje_error) {
		super(mensaje_error);
	}
}
