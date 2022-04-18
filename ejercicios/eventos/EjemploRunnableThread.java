import java.util.concurrent.ThreadLocalRandom;

public class EjemploRunnableThread implements Runnable {
    public EjemploRunnableThread() {}

    @Override
    public void run() {
        for(int i = 0; i < 10; i++) {
            System.out.println("Hilo " + Thread.currentThread().getName() + ": " + i);
            try {
                Thread.sleep(ThreadLocalRandom.current().nextInt(1000, 5000));
            } catch (InterruptedException e) {
                e.printStackTrace();
                return;
            }
        }
    }

    public static void main(String[] args) {
        Runnable r = new EjemploRunnableThread();

        // Imprimir hilo principal
        System.out.println("Hilo principal: " + Thread.currentThread().getName());

        // Crear varios hilos e iniciarlos
        Thread t1 = new Thread(r);
        Thread t2 = new Thread(r);
        Thread t3 = new Thread(r);
        Thread t4 = new Thread(r);
        Thread t5 = new Thread(r);

        t1.start();
        t2.start();
        t3.start();
        t4.start();
        t5.start();

        // Imprimir la prioridad y si está vivo el cuarto hilo.
        System.out.println("Hilo " + t4.getName() + ": " + t4.getPriority() + " " + t4.isAlive());

        // Cambiar el nombre del tercer hilo
        t3.setName("Hilo 3");

        // Establecer una prioridad y un nombre aleatorio al segundo hilo.
        t2.setPriority(Thread.MAX_PRIORITY);
        t2.setName("Hilo " + ThreadLocalRandom.current().nextInt(1, 10));

        // Dormir el primer hilo un cierto tiempo aleatorio.
        try {
            Thread.sleep(ThreadLocalRandom.current().nextInt(1000, 5000));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}