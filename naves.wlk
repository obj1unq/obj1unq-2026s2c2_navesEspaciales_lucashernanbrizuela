class NaveGeneral {
	var property velocidad = 0

	method encontreUnEnemigo() {
	  self.recibirAmenaza()
	  self.propulsar()
	}

	method recibirAmenaza()

	method propulsar() {
	  self.sumarCantidadHasta(20000) 
	}

	method prepararParaViajar() {
	  self.sumarCantidadHasta(15000)
	}

	method sumarCantidadHasta(cantidad) {
	  if( velocidad+cantidad > 300000){
		velocidad = 300000
	  }else{
		velocidad += cantidad
	  }	  
	}

}

/*
Hacer que una nave se encuentre con un enemigo. 
Esto les hace recibir una amenaza, sufriendo los efectos particulares de cada nave, 
y luego se propulsan para intentar escapar.
*/

class NaveDeCarga inherits NaveGeneral {

	//var property velocidad = 0
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}
	
	method enFalta() = self.sobrecargada() and self.excedidaDeVelocidad()
	
	method acercamientoDeControl() {
		if (self.enFalta()) {
			self.recibirAmenaza()
		}
	}

}

class NaveDeCargaDeResiduosRadiactivos inherits NaveDeCarga{
	override method recibirAmenaza() {
		velocidad = 0
	}

	override method prepararParaViajar() {
	  velocidad += 15000
	  carga = 0
	}
}



class NaveDePasajeros inherits NaveGeneral {

	//var property velocidad = 0
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaPermitida() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaPermitida() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits NaveGeneral {
	//var property velocidad = 0
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
	
	override method prepararParaViajar() {
	  velocidad += 15000
	  if(modo == ataque){
		self.emitirMensaje("Volviendo a la base")
	  }else{
		self.emitirMensaje("Saliendo en mision")
		modo = ataque
	  }
	}

}

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}

}
