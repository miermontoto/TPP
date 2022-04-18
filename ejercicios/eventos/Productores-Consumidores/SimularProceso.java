package poe;

import java.util.concurrent.ThreadLocalRandom;

/**
 * Las instancias de esta clase permiten simular los tiempos
 * que tardan en completarse procesamientos requeridos en
 * hilos.
 */
public class SimularProceso {
	private long tminMili;	// duración mínima del proceso en milisegundos
	private long tmaxMili;	// duración máxima del proceso en milisegundos
	private int tminNano;	// duración mínima adicional en nanosegundos
	private int tmaxNano;	// duración máxima adicional en nanosegundos
	private long tMili;		// duración del proceso en milisegundos
	private int tNano;		// duración adicional del proceso en nanosegundos 
	
	/**
	 * Crea una instancia que simula un proceso cuya duración
	 * en milisegundos está dentro del intervalo especificado.
	 * @param tminMili el tiempo mínimo en milisegundos
	 * @param tmaxMili el tiempo máximo en milisegundos
	 */
	public SimularProceso(long tminMili, long tmaxMili) {
		if (tminMili >= tmaxMili) {
			throw new IllegalArgumentException();
		}

		this.tminMili = tminMili;
		this.tmaxMili = tmaxMili;
		this.tminNano = 0;
		this.tmaxNano = 0;
	}
	
	/**
	 * Crea una instancia que simula un proceso cuya duración en
	 * milisegundos y nanosegundos está dentro de los intervalos
	 * especificados.
	 * @param tminMili el tiempo mínimo en milisegundos
	 * @param tminNano el excedente del previo en nanosegundos
	 * @param tmaxMili el tiempo máximo en milisegundos
	 * @param tmaxNano el excedente del previo en nanosegundos
	 */
	public SimularProceso(long tminMili, int tminNano,
			long tmaxMili, int tmaxNano) {
		if (tminMili >= tmaxMili ||
				tminNano >= tmaxNano) {
			throw new IllegalArgumentException();
		}
		
		this.tminMili = tminMili;
		this.tmaxMili = tmaxMili;
		this.tminNano = tminNano;
		this.tmaxNano = tmaxNano;
	}

	/**
	 * Duerme un hilo durante el tiempo que necesita para
	 * realizar un proceso simulado.
	 */
	public void procesar() {
		ThreadLocalRandom r = ThreadLocalRandom.current();
		this.tMili = this.tminMili + r.nextLong(this.tminMili, this.tmaxMili);
		this.tNano = this.tmaxNano == 0 ? 0
				                        : this.tminNano +
				                          r.nextInt(this.tminNano, this.tmaxNano);				

		try { // tiempo de proceso
			Thread.sleep(this.tMili, this.tNano);
		} catch (InterruptedException e) { }
	}
	
	/**
	 * Retorna los milisegundos que dura el proceso simulado.
	 * @return los milisegundos de procesamiento
	 */
	public long tiempoProcesoMili() {
		return this.tMili;
	}
	
	/**
	 * Retorna los nanosegundos que dura el proceso simulado.
	 * @return los nanosegundos excedentes del proceso simulado
	 */
	public int tiempoProcesoNano() {
		return this.tNano;
	}
	
}
