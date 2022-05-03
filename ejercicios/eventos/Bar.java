public class Bar {
    private int aforo;
    private Semaphore s;

    public Bar(int aforo) {
        this.aforo = aforo;
        s = new Semaphore(aforo, true);
    }

    public void entrar() {
        s.acquire();
        synchronized(this) {
            aforo--;
        }
    }

    public void salir() {
        synchronized(this) {
            aforo++;
        }
        s.release();
    }

    public void consumir() {

    }


    private class Cliente implements Runnable {
        private Bar bar;

        public Cliente(Bar bar) {
            this.bar = bar;
        }

        public void run() {
            bar.entrar();
            System.out.println("Entra");
            bar.consumir();
            System.out.println("Consume");
            bar.salir();
            System.out.println("Sale");
        }
    }
}
