package comun;

public class CoordenadasNoValidas extends Exception {
	private static final long serialVersionUID = -2993019501292356458L;

	public CoordenadasNoValidas() {
		super();
	}

	public CoordenadasNoValidas(String mensaje_error) {
		super(mensaje_error);
	}
}
