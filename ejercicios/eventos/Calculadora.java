import static java.lang.System.*;

import java.util.Map;

/**
 * Calculadora.
 * Tabla de estados:
 *             0     1     2     3
 * estado:  | ini | num | inM | nuM
 * numero   | num | ANP | nuM | ANP
 * operador | ANP | ini | inM | ANP
 * resultado| ini | num | inM | nuM
 * reset    | ini | ini | inM | nuM
 * borrar   | ANP | ini | ANP | inM
 * borrarMem| ANP | ANP | ini | num
 * memorizar| inM | nuM | inM | nuM
 * recuperar| ANP | ANP | ini | num
 */
public class Calculadora {

    private int estado;
    private char operador;
    private double valor;
    private double valorAnterior;
    private double memoria;

    public Calculadora() {
        reset();
    }

    public void reset() {
        estado = 0;
        operador = ' ';
    }

    public void numero(double x) {
        out.print("numero(" + x + "): ");
        if(estado == 0) {
            estado = 1;
            valorAnterior = valor;
            switch(operador) {
                case '+':
                    valor += x;
                    break;
                case '-':
                    valor -= x;
                    break;
                case '*':
                    valor *= x;
                    break;
                case '/':
                    valor /= x;
                    break;
                default:
                    valor = x;
                    break;
            }
            out.printf("%.2f %c %.2f = %.2f%n", valorAnterior, operador, x, valor);
        } else err.println("ANP");
    }

    public void operador(char op) {
        out.print("operador(" + op + "): ");
        String validOperators = "+-*/";
        if(estado == 1) {
            if(validOperators.indexOf(op) >= 0) {
                operador = op;
                estado = 0;
                out.println(operador);
            } else err.println("Operador no válido");
        } else err.println("ANP");
    }

    public void resultado() {
        out.printf("Resultado: %f%n", valor);
    }

    public void borrar() {
        out.print("borrar(): ");
        if(estado == 1) {
            estado = 0;
            valor = valorAnterior;
            out.println(valor);
        } else err.println("ANP");
    }

    public void borrarMem() {
        out.print("borrarMem(): ");
        if(estado == 3) {
            estado = 1;
            out.println(memoria);
        } else err.println("ANP");
    }

    public void memorizar() {
        out.println("memorizar(): ");
        if(estado == 0 || estado == 1) estado = estado == 0 ? 3 : 2;
        memoria = valor;
        out.println(memoria);
    }

    public void recuperar() {
        out.println("recuperar(): ");
        if(estado == 2 || estado == 3) {
            if(estado == 2) operador = ' ';
            numero(memoria);
            estado = 2;
            out.println(valor);
        } else err.println("ANP");
    }

    public static void main(String[] args) {
        Calculadora calc = new Calculadora();

        // Traza de los siguientes eventos:
        // numero(2.4), operador('*'), numero(2),
        // borrar(), operador('-'), numero(3),
        // operador('+'), numero(10), resultado().
        calc.numero(2.4);
        calc.operador('*');
        calc.numero(2);
        calc.borrar();
        calc.operador('-');
        calc.numero(3);
        calc.operador('+');
        calc.numero(10);
        calc.resultado();
    }
    
}