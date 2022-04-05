package cliente;

import java.io.IOException;

import lib.ChannelException;
import lib.Menu;

public class EjemploMenu {

	private static Menu m = new Menu("\nMenú de prueba", "Opción? ");

	private static void prueba1() {
		System.out.print("Valor entero: ");
		System.out.printf("Ejecutando prueba1(): %d\n", m.input().nextInt());
	}
	
	private static void prueba2() {
		System.out.println("Ejecutando prueba2()");
	}
	
	private static void prueba3() {
		System.out.println("Ejecutando prueba3()");
	}

	/**
	 * Método de prueba que imprima si un número aleatorio entre 1 y 100 es primo.
	 */
	private static void prueba4() {
		int num = (int) (Math.random() * 100) + 1;
		boolean primo = true;
		for (int i = 2; i < num; i++) {
			if (num % i == 0) {
				primo = false;
				break;
			}
		}
		System.out.printf("%d %s.\n", num, primo ? "es primo" : "no es primo");
	}

	/**
	 * Método de prueba aleatorio que imprime el nombre de un color aleatorio.
	 */
	private static void prueba5() {
		// Crear un string "colores" con muchos nombres de colores.
		String[] colores = { "azul", "rojo", "verde", "amarillo", "rosa", "marrón", "naranja" };
		int indice = (int) (Math.random() * colores.length);
		System.out.printf("El color elegido es %s.\n", colores[indice]);
	}
	
	public static void main(String[] args) {

		m.add("Prueba1", () -> prueba1());
		m.add("Prueba2", () -> prueba2());
		m.add("Prueba3", () -> prueba3());
		m.add("Prueba4", () -> prueba4());
		m.add("Prueba5", () -> prueba5());
		
		try {
			m.run();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ChannelException e) {
			e.printStackTrace();
		}
		
		Menu mo = new Menu("\nMenú de objetos", "Opción? ");
		
		mo.add("Carácter alfabético", 'a');
		mo.add("Valor numérico", 20);
		mo.add("String", "Una cadena");
		
		
		try {
			do {
				System.out.println(mo.getObject().toString());
			} while (mo.runSelection());
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ChannelException e) {
			e.printStackTrace();
		}
		
	}

}
