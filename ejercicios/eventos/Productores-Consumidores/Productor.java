package poe;

import java.util.function.Supplier;

/**
 * Clase cuyas instancias son productores de datos de tipo genérico y
 * que serán ejecutados por un hilo. 
 * @param <E> el tipo de los datos producidos
 */
public class Productor<E> implements Runnable {
	private final static int TIEMPO_MIN = 1500;
	private final static int TIEMPO_MAX = 3000;
    private final Buffer<E> box;
    private final Supplier<? extends E> fGenerator;
    
    /**
     * Crea un productor que guardará en el buffer dado cada dato
     * producido por una instancia de la interfaz funcional especificada.
     * @param box el buffer de almacenamiento
     * @param fGenerator la interfaz funcional (método {@code get()})
     */
    public Productor(Buffer<E> box, Supplier<? extends E> fGenerator) {
        this.box = box;
        this.fGenerator = fGenerator;
    }
    
    private E producir() {
    	SimularProceso sp = new SimularProceso(TIEMPO_MIN, TIEMPO_MAX);
    	// tiempo de producción simulado
    	sp.procesar();
    	return fGenerator.get();
    }

    @Override
    public void run() {
        while (true) {
        	// producir dato y guardar en el buffer
            box.guardar(Thread.currentThread().getName(), producir());
        }
    }
}
