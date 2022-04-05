public class Banco {
    
    /**
     * nombre:   | cer | Aop | Bop | Acl | Bcl |
     * estados:  |  0  |  1  |  2  |  3  |  4  |
     * abrirA    |  1  | ANP | ANP | ANP |  1  |
     * abrirB    |  2  | ANP | ANP |  2  | ANP |
     * cerrarA   |  -  |  3  |  -  |  -  |  -  |
     * cerrarB   |
     * alarmaOn  |
     * alarmaOff |
     */
    private int estado;

    public Banco() {
        estado = 0;
    }
}
