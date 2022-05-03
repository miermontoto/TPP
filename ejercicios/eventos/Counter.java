/**
 * CounterMain
 */
public class CounterMain {
    private final static int NUM_THREADS = 10;

    public static void main(String[] args) {
        Counter counter = new Counter();
        Thread[] threads = new Thread[NUM_THREADS];
        for (int i = 0; i < NUM_THREADS; i++) {
            threads[i] = new Thread(new CounterThread(counter));
            threads[i].start();
        }

        while(Thread.activeCount() > 1) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private class Counter {

        private int counter;

        public Counter() {
            this.counter = 0;
        }

        public void add1() {
            this.counter++;
        }

        public int get() {
            return this.counter;
        }
    }

    private class ThreadCounter implements Runnable {

        private final static int THREAD_INCREMENT = 1000;
        private Counter counter;

        public ThreadCounter(Counter c) {
            this.counter = c;
        }

        public void run() {
            for(int i = 0; i < THREAD_INCREMENT; i++) {
                synchronized(counter) {
                    counter.add1();
                }
            }
        }
    }
}


