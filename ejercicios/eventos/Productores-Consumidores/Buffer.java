package poe;

import java.util.ArrayDeque;
import java.util.Deque;

/**
 * Clase sincronizada (monitor) cuyas instancias son buffers en los
 * que se almacenan datos de un tipo genérico. El buffer se gestiona
 * como una cola FIFO. 
 * @param <E> el tipo de los datos que se almacenan
 */
public class Buffer<E> {
    private Deque<E> data; // doble cola
    
    private final static int BUFFER_SIZE = 25;
 
    /**
     * Crea un buffer vacío de capacidad {@code BUFFER_SIZE}.
     */
    public Buffer() {
    	data = new ArrayDeque<E>(BUFFER_SIZE);
    }
    
    /**
     * Un hilo de ejecución obtiene un elemento del buffer.
     * @param name el nombre del hilo
     * @return el primer elemento del buffer
     */
    public synchronized E sacar(String name) {
        while (data.isEmpty()) { // buffer vacío
        	System.out.printf(
        			"%s intenta extraer un dato de un buffer vacío\n",
        			name);
            try {
                wait();
            } catch (InterruptedException e) { }
        }
        
        notifyAll();
        return data.removeFirst();
    }
 
    /**
     * Un hilo de ejecución guarda en el buffer el elemento especificado.
     * @param name el nombre del hilo
     * @param info el elemento guardar
     */
	public synchronized void guardar(String name, E info) {
        while (data.size() == BUFFER_SIZE) { // buffer lleno
        	System.out.printf(
        			"%s intenta guardar un dato en un buffer lleno\n",
        			name);
            try {
                wait();
            } catch (InterruptedException e) { }
        }
        
        data.addLast(info);
        notifyAll();
    }
}
