import java.util.concurrent.Semaphore;

public class EjercicioExclusiónSync implements Runnable {

    private volatile int n;
    private volatile Object mutex;

    public EjercicioExclusiónSync() {
        this.n = 0;
        mutex = new Object();
    }

    public void crearHilos() {
        Thread hilo1 = new Thread(this);
        Thread hilo2 = new Thread(this);
        hilo1.start();
        hilo2.start();
    }

    public int value() {
        return n;
    }

    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            synchronized(mutex) {
                n++;
                n--;
            }
        }
    }
    public static void main(String[] args) throws InterruptedException {
        EjercicioExclusiónSync e = new EjercicioExclusiónSync();

        e.crearHilos();

        while(Thread.activeCount() > 1) {
            Thread.sleep(5);
        }

        System.out.println("El valor de n es: " + e.value());
    }
}
