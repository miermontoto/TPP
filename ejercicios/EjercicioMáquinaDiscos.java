public class EjercicioMáquinaDiscos {

    private int estado;
    private double altura;
    private int numDiscos;
    private int numLastDiscosC;
    private double alturaLastDiscosC;

    public EjercicioMáquinaDiscos() {
        estado = 0;
        altura = 0;
        numDiscos = 0;
        numLastDiscosC = 0;
        alturaLastDiscosC = 0;
    }

    /**
     * Método de ejemplo "apilaA(x)"
     */
    public void apilaA(double x) {
        try {
        System.out.println("apilaA(" + x + ")");
        if(estado == 0) estado = 1;
        else if(estado == 2) estado = 3;
        else if(estado == 3) throw new UnsupportedOperationException();
        else if(estado == 4) estado = 3;

        altura += x; 
        numDiscos++;
        } catch (UnsupportedOperationException e) {
            System.out.println("Operación no soportada");
        } finally {imprimeTraza();}
    }

    /**
     * Método de ejemplo "apilaB(x)"
     */
    public void apilaB(double x) {
        try {
            System.out.println("apilaB(" + x + ")");
            if(estado == 0) estado = 1;
            else if(estado == 2) estado = 4;
            else if(estado == 3) estado = 4;
            else if(estado == 4) throw new UnsupportedOperationException();

            altura += x;
            numDiscos++;
        } catch (UnsupportedOperationException e) {
            System.out.println("Operación no soportada");
        } finally {imprimeTraza();}
    }

    /**
     * Método de ejemplo "apilaC(x)"
     */
    public void apilaC(double x) {
        try {
            if(estado == 0) throw new UnsupportedOperationException();
            System.out.println("apilaC(" + x + ")");
            if(estado == 1) estado = 2;
            if(estado >= 3) {
                estado = 2;
                numLastDiscosC = 0;
                alturaLastDiscosC = 0;
            }

            altura += x;
            numDiscos++;

            numLastDiscosC++;
            alturaLastDiscosC += x;
        } catch(UnsupportedOperationException e) {
            System.err.println("Operación no soportada");
        } finally {imprimeTraza();}
    }

    /**
     * Método que imprime la traza actual del ejercicio.
     */
    private void imprimeTraza() {
        System.out.printf("Estado: %d, altura: %.2f, núm. discos: %d%n%n",
         estado, altura, numDiscos);
    }
    
    /**
     * Método que imprime la altura y el número de discos de la última consecución de discos c.
     */
    private void imprimeUltimaConsecucion() {
        System.out.println("Última consecución de discos c: " + numLastDiscosC +
         " discos, altura: " + alturaLastDiscosC);
    }

    /**
     * Método main.
     */
    public static void main(String[] args) {
        EjercicioMáquinaDiscos ej = new EjercicioMáquinaDiscos();

        // Indicar la traza para la siguiente serie de eventos:
        // 𝑎𝑝𝑖𝑙𝑎𝐴(0.5), 𝑎𝑝𝑖𝑙𝑎𝐴(1), 𝑎𝑝𝑖𝑙𝑎𝐵(0.5), 𝑎𝑝𝑖𝑙𝑎𝐶(1), 𝑎𝑝𝑖𝑙𝑎𝐶(1.5),
        // 𝑎𝑝𝑖𝑙𝑎𝐶(0.5), 𝑎𝑝𝑖𝑙𝑎𝐵(0.5), 𝑎𝑝𝑖𝑙𝑎𝐵(0.5), 𝑎𝑝𝑖𝑙𝑎𝐴(1), 𝑎𝑝𝑖𝑙𝑎𝐵(0.5),
        // 𝑎𝑝𝑖𝑙𝑎𝐶(0.25), 𝑎𝑝𝑖𝑙𝑎𝐶(1.75)
        ej.apilaA(0.5);
        ej.apilaB(1);
        ej.apilaC(0.5);
        ej.apilaC(1);
        ej.apilaC(1.5);
        ej.apilaC(0.5);
        ej.apilaB(0.5);
        ej.apilaB(0.5);
        ej.apilaA(1);
        ej.apilaC(0.5);
        ej.apilaC(0.25);
        ej.apilaC(1.75);

        ej.imprimeUltimaConsecucion();
    }
}