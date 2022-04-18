package poe;

import java.util.function.Consumer;

/**
 * Clase cuyas instancias son consumidores de datos de tipo genérico y
 * que serán ejecutados por un hilo. 
 * @param <E> el tipo de los datos que consumen
 */
public class Consumidor<E> implements Runnable {
	private final static int TIEMPO_MIN = 1300;
	private final static int TIEMPO_MAX = 2400;
    private final Buffer<E> box;
    private final Consumer<? super E> fConsumer;

    /**
     * Crea un consumidor que obtendrá un dato del buffer dado y lo
     * consume mediante una instancia de la interfaz funcional
     * especificada.
     * @param box el buffer de almacenamiento
     * @param fConsumer la interfaz funcional (método {@code accept(e)}
     */
    public Consumidor(Buffer<E> box, Consumer<? super E> fConsumer) {
        this.box = box;
        this.fConsumer = fConsumer;
    }

    private void consumir(E data) {
    	SimularProceso sp = new SimularProceso(TIEMPO_MIN, TIEMPO_MAX);
    	// obtener dato del bf
    	fConsumer.accept(box.sacar(Thread.currentThread().getName()));
    	// tiempo de consumición simulado
    	sp.procesar();
    }

    @Override
    public void run() {
        while (true) {
        	// sacar dato del buffer y consumir
        	consumir(box.sacar(Thread.currentThread().getName()));
        }
    }
}