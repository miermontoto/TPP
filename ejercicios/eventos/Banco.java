public class Banco {
    
    /**
     * Grafo de estados:
     * nombre    | cer | Aop | Bop | Acl | Bcl | fro |
     * abrirA    | Aop | ANP | ANP | ANP | Aop | ANP |
     * abrirB    | Bop | ANP | ANP | Bop | ANP | ANP |
     * cerrarA   |  -  | Acl |  -  |  -  |  -  |  -  |
     * cerrarB   |  -  |  -  | Bop |  -  |  -  |  -  |
     * alarmaOn  | fro | fro | fro | fro | fro | ANP |
     * alarmaOff | ANP | ANP | ANP | ANP | ANP | cer |
     * toggleAl  | fro | fro | fro | fro | fro | cer |
     */
    private int estado;

    public Banco() {
        estado = 0;
    }
}
