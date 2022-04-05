public class Robot {

    /*
     * Grafo de eventos:
     * estado:    |  0  |  1  |  2  |  3  |  4  |
     * desplazar  |  1  |  1  | ANP |  3  | ANP |
     * girar      | ANP |  1  |  2  | ANP | ANP |
     * desactivar | ANP | ANP |  1  |  1  | ANP |
     * reiniciar  |  0  |  0  |  0  |  0  |  0  |
     * alarmaD    |  2  |  2  |  -  |  4  |  -  |
     * alarmaG    |  -  |  3  |  4  |  -  |  -  |
     * 
     * Donde el estado 2 es el estado en el que se encuentra el robot cuando
     * suena la alarma 'D', el estado 3 es el estado cuando suena la alarma
     * 'G', y el estado 4 es el estado en el que se encuentra el robot cuando
     * suenan ambas alarmas a la vez.
     * 
     * Solo se puede desactivar una alarma, por lo que si suenan las dos no
     * se puede desactivar ninguna.
     * 
     * En el estado incial solo se puede desplazar, no girar.
     */
    private int estado;
    private double distancia; // Distancia del origen de coordenadas.
    private double angulo;

    public Robot() {
        estado = 0;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    /**
     * Método desplazar().
     * Puede lanzar 'alarmaD()' si se encuentra con un obstáculo.
     * Provoca que el robot se mueva linealmente con respecto al origen.
     */
    public void desplazar(double d) {
        try {
            System.out.print("desplazar(" + d + "): ");
            if(estado % 2 == 0 && estado != 0) throw new UnsupportedOperationException("desplazar");
            if(estado == 0) estado = 1;
            // Calcular la distancia del origen al desplazarse 'd' unidades 
            // teniendo en cuenta el ángulo actual.
            distancia += d * Math.cos(angulo);

            // Si la distancia al origen es cero, volver al estado '0'.
            if(distancia == 0) estado = 0;
            imprimirInfo();
        } catch (UnsupportedOperationException e) {
            System.out.println("Acción no permitida.");
        }
    }

    /**
     * Método girar().
     * Puede lanzar 'alarmaG()' si se encuentra con un obstáculo.
     * Se le añaden 'alpha' grados al ángulo actual.
     */
    public void girar(double alpha) throws UnsupportedOperationException {
        try {
            System.out.print("girar(" + alpha + "): ");
            if(estado != 1 && estado != 2) throw new UnsupportedOperationException("girar");

            angulo += alpha;
            imprimirInfo();
        } catch (UnsupportedOperationException e) {
            System.out.println("Acción no permitida.");
        }
    }

    /**
     * Método desactivar().
     * Desactiva la alarma correspondiente.
     * Si ambas o ninguna alarma está activada, lanza una excepción.
     */
    public void desactivar() throws UnsupportedOperationException {
        try {
            System.out.print("desactivar(): ");
            if(estado != 2 && estado != 3) throw new UnsupportedOperationException("desactivar");
            if(distancia == 0) estado = 0;
            else estado = 1;
            System.out.println("Se ha desactivado una alarma.");
        } catch (UnsupportedOperationException e) {
            System.out.println("Acción no permitida.");
        }
    }

    /**
     * Método reiniciar().
     * Reinicia el robot a su estado inicial.
     */
    public void reiniciar() {
        System.out.print("reiniciar(): ");
        estado = 0;
        distancia = 0;
        angulo = 0;
        imprimirInfo();
    }

    /**
     * Método alarmaD().
     * Retorna la distancia.
     * @return distancia actual del origen.
     */
    public double alarmaD() {
        System.out.print("alarmaD(): ");
        estado = 2;
        imprimirInfo();
        return distancia;
    }

    /**
     * Método alarmaG().
     * @return ángulo actual del robot.
     */
    public double alarmaG() {
        System.out.print("alarmaG(): ");
        estado = 3;
        imprimirInfo();
        return angulo;
    }

    /**
     * Método que imprime información general sobre el estado actual del robot.
     */
    private void imprimirInfo() {
        System.out.printf("Estado: %d, distancia: %.2fu, ángulo: %.2fº\n", estado, distancia, angulo);
    }

    public static void main(String[] args) {
        Robot robot = new Robot();

        // Indicar la traza para esta serie de eventos:
        // 𝑔𝑖𝑟𝑎𝑟(30) , 𝑑𝑒𝑠𝑝𝑙𝑎𝑧𝑎𝑟(25.5) , 𝑔𝑖𝑟𝑎𝑟(45) , 𝑑𝑒𝑠𝑝𝑙𝑎𝑧𝑎𝑟(100) , 𝑎𝑙𝑎𝑟𝑚𝑎𝐷()
        // que retorna 75.8, 𝑑𝑒𝑠𝑝𝑙𝑎𝑧𝑎𝑟(−20), 𝑔𝑖𝑟𝑎𝑟(45) y 𝑟𝑒𝑖𝑛𝑖𝑐𝑖𝑎𝑟().
        robot.girar(30);
        robot.desplazar(25.5);
        robot.girar(45);
        robot.desplazar(100);
        robot.alarmaD();
        robot.desactivar();
        robot.desplazar(-20);
        robot.girar(45);
        robot.reiniciar();
    }
}
