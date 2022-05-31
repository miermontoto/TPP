package comun;

public class BarcoMalPosicionado extends Exception {
	private static final long serialVersionUID = -2993019501292356458L;

	public BarcoMalPosicionado() {
		super();
	}

	public BarcoMalPosicionado(String mensaje_error) {
		super(mensaje_error);
	}
}
