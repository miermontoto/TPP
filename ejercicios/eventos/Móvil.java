/**
 * Tabla de estados:
 *           0     1     2     3     4
 * ESTADOS | ini | mx1 | my1 | mx2 | my2
 * moverX  | mx1 | mx2 | mx1 | ANP | mx1
 * moverY  | my1 | my1 | my2 | my1 | ANP
 * mover2X | ANP | ANP | mx2 | ANP | mx2
 * mover2Y | ANP | my2 | ANP | my2 | ANP
 * 
 * Tabla de acciones:
 */
public class Móvil {
    private int movx;
    private int movy;
    private int estado;

    public Móvil() {
        movx = 0;
        movy = 0;
        estado = 0;
    }

    public void moverX(boolean positive) {
        System.out.print("moverX(" + positive + "): ");
        try {
            if(estado == 3) throw new UnsupportedOperationException("moverX" + positive);
            if(estado == 1) estado = 3;
            else estado = 1;
            if(positive) movx++;
            else movx--;
            
            if(movx < 0) {
                movx = 0;
                throw new UnsupportedOperationException("moverX" + positive + ": movx < 0");
            }
            System.out.println("movx = " + movx);
        } catch(UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public void moverY(boolean positive) {
        System.out.print("moverY(" + positive + "): ");
        try {
            if(estado == 4) throw new UnsupportedOperationException("moverY" + positive);
            if(estado == 2) estado = 4;
            else estado = 2;
            if(positive) movy++;
            else movy--;
            
            if(movy < 0) {
                movy = 0;
                throw new UnsupportedOperationException("moverY" + positive + ": movy < 0");
            }
            System.out.println("movy = " + movy);
        } catch(UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public void mover2X(boolean positive) {
        System.out.print("mover2X(" + positive + "): ");
        try {
            if(estado == 0 || estado == 1 || estado == 3) throw new UnsupportedOperationException("mover2X" + positive);
            estado = 3;
            if(positive) movx += 2;
            else movx -= 2;
            
            if(movx < 0) {
                movx -= 2;
                throw new UnsupportedOperationException("mover2X" + positive + ": movx < 0");
            }
            System.out.println("movx = " + movx);
        } catch(UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public void mover2Y(boolean positive) {
        System.out.print("mover2Y(" + positive + "): ");
        try {
            if(estado == 0 || estado == 2 || estado == 4) throw new UnsupportedOperationException("mover2Y" + positive);
            estado = 4;
            if(positive) movy += 2;
            else movy -= 2;
            
            if(movy < 0) {
                movy -= 2;
                throw new UnsupportedOperationException("mover2Y" + positive + ": movy < 0");
            }
            System.out.println("movy = " + movy);
        } catch(UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public static void main(String[] args) {
        Móvil m = new Móvil();
    }
    
}
