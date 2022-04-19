/** 
 * Tabla de estados:
 *           0    1    2    3    4    5
 * estados |nada|latr|lonr|latp|lonp|fijo|
 * latitud |latr|latr|latp|latp|latp|!ANP|
 * longitud|lonr|lonp|lonr|lonp|lonp|!ANP|
 * fijar   |!ANP|!ANP|!ANP|fijo|fijo| -- |
 * getinfo |!ANP|!ANP|!ANP|!ANP|!ANP| -- |
 * reset   |!ANP|!ANP|!ANP|!ANP|!ANP|nada|
 * 
 * Tabla de acciones:
 *           0    1    2    3    4    5
 * estados |nada|latr|lonr|latp|lonp|fijo|
 * latitud |lt=x|lt+x|lt=x|lt+x|lt=x|!ANP|
 * longitud|lg=x|lg=x|lg+x|lg=x|lg+x|!ANP|
 * fijar   |!ANP|!ANP|!ANP| -- | -- | -- |
 * getinfo |!ANP|!ANP|!ANP|!ANP|!ANP| -- |
 * reset   |!ANP|!ANP|!ANP|!ANP|!ANP| -- |
 */
public class Geolocalización {
    private double latitud;
    private double longitud;
    private int estado;

    public Geolocalización() {
        estado = 0;
    }

    public void fijar() {
        System.out.print("fijar(): ");
        try {
            if(estado < 3) throw new UnsupportedOperationException("fijar");
            else estado = 5;
            System.out.println("OK");
        } catch (UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public void getInfo() {
        System.out.print("getInfo(): ");
        try {
            if (estado == 5) System.out.printf("%s, %s%n", latitud, longitud);
            else throw new UnsupportedOperationException("getInfo");
        } catch (UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public void reset() {
        System.out.print("reset(): ");
        try {
            if (estado == 5) estado = 0;
            else throw new UnsupportedOperationException("reset");
            System.out.println("OK");
        } catch (UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public void latitud(double newValue) throws UnsupportedOperationException {
        System.out.print("latitud(): ");
        try {
            if(estado == 5) throw new UnsupportedOperationException("latitud");
            
            // Acción del método.
            if(estado % 2 != 0) latitud += newValue;
            else latitud = newValue;
            System.out.println("latitud = " + latitud);

            // Actualización del estado.
            if(estado == 0) estado = 1;
            else if(estado != 1) estado = 3;
        } catch (UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public void longitud(double newValue) throws UnsupportedOperationException {
        try {
            if(estado == 5) throw new UnsupportedOperationException("longitud");
            
            // Acción del método.
            if(estado % 2 == 0 && estado != 0) longitud += newValue;
            else longitud = newValue;
            System.out.println("longitud = " + longitud);

            // Actualización del estado.
            if(estado == 0) estado = 2;
            else if(estado != 2) estado = 4;
        } catch (UnsupportedOperationException e) {
            System.err.println("Acción no permitida.");
        }
    }

    public static void main(String[] args) {
        Geolocalización g = new Geolocalización();
        // Indicar la traza para esta serie de eventos:
        // Latitud(-3), Fijar(), Longitud(4), Longitud(2),
        // Fijar() y Reset()
        g.latitud(-3);
        g.fijar();
        g.longitud(4);
        g.longitud(2);
        g.fijar();
        g.reset();
    }
}
