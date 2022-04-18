
package poe;

import java.util.concurrent.ThreadLocalRandom;

/**
 * Clase cuya instancia inicia la ejecución de los productores y de
 * los comsumidores (hilo principal). Los productores generan datos de
 * tipo genérico para los consumidores mediante un buffer auxiliar de
 * almacenamiento.
 */
public class ProductorConsumidor {
	private Buffer<Character> box;	// buffer de almacenamiento
	private Thread[] productores;	// productores
	private Thread[] consumidores;	// consumidores
	
	private final static int NUMERO_PRODUCTORES = 6;
	private final static int NUMERO_CONSUMIDORES = 1;
	
	/**
	 * Crea los productores, los consumidores y el buffer
	 * mediante el que intercambian información (datos)
	 */
	public ProductorConsumidor() {
		productores = new Thread[NUMERO_PRODUCTORES];
		consumidores = new Thread[NUMERO_CONSUMIDORES];
		box = new Buffer<Character>();
		
		// hilos productores
		for (int k = 0; k < NUMERO_PRODUCTORES; k++) {
			productores[k] = new Thread(new Productor<Character>(box,
					() -> {
						return (char)ThreadLocalRandom.current().nextInt(141, 173);
					}),	"Productor-" + k);
			productores[k].start();
		}

		// hilos consumidores
		for (int k = 0; k < NUMERO_CONSUMIDORES; k++) {
			consumidores[k] = new Thread(new Consumidor<Character>(box,
					ch -> { }), "Consumidor-" + k);
			consumidores[k].start();
		}
		
	}
			
	public static void main(String[] args) {

		new ProductorConsumidor();

	}

}
