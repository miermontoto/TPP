package comun;

public class TamanioBarcoNoValido extends Exception {
	private static final long serialVersionUID = -2993019501292356458L;

	public TamanioBarcoNoValido() {
		super();
	}

	public TamanioBarcoNoValido(String mensaje_error) {
		super(mensaje_error);
	}
}
