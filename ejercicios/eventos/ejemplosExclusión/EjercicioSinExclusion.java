public class EjercicioSinExclusion implements Runnable {

    private volatile int n;

    public EjercicioSinExclusion() {
        this.n = 0;
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
            // sección crítica
            n++;
            n--;
        }
    }
    public static void main(String[] args) throws InterruptedException {
        EjercicioSinExclusion e = new EjercicioSinExclusion();

        e.crearHilos();

        while(Thread.activeCount() > 1) {
            Thread.sleep(10);
        }

        System.out.println("El valor de n es: " + e.value());
    }
}
