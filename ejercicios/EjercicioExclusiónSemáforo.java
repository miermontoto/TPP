import java.util.concurrent.Semaphore;

public class EjercicioExclusiónSemáforo implements Runnable {

    private Semaphore mutex;
    private volatile int n;

    public EjercicioExclusiónSemáforo() {
        this.n = 0;
        mutex = new Semaphore(1);
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
            try {
                mutex.acquire(); // P(mutex)
                n++;
                n--;
                mutex.release(); // V(mutex)
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
    public static void main(String[] args) throws InterruptedException {
        EjercicioExclusiónSemáforo e = new EjercicioExclusiónSemáforo();

        e.crearHilos();

        while(Thread.activeCount() > 1) {
            Thread.sleep(5);
        }

        System.out.println("El valor de n es: " + e.value());
    }
}
