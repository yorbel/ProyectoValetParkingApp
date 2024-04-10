//
//  UsuarioModel.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 2/19/24.
//

import Foundation

struct DataErrorModel: Decodable {
    
    var msg : String
    
}

struct ValetParkingModel: Decodable {
    
    var id: Int
    var nombre_usuario: String
    var nombre: String
    var apellido: String
    var sesion_id: Int
    
}

struct UsuarioModel: Decodable {
    
    var token: String
    var valet_parking: ValetParkingModel
  
}

struct LugarModel: Decodable {
    
    var id: Int
    var nombre: String
    var direccion: String
    var imagen: String
    var latitud: Double
    var longitud: Double
    
}


struct TicketModel: Decodable {
    
    var id: Int
    var lugar_id: Int
    var sesion_recepcion_id: Int

    var ticket: String

    var recepcion_realizada: String
    var recepcion_realizada_fecha: String?
    var valet_parking_recepcion_id: Int?

    var cliente_conectado: String
    var cliente_conectado_fecha: String?

    var vehiculo_solicitado: String
    var vehiculo_solicitado_fecha: String?

    var sesion_busqueda_id : Int?
    var buscando_vehiculo: String
    var buscando_vehiculo_fecha: String?
    var valet_parking_buscando_id: Int?

    var listo_para_retirar: String
    var listo_para_retirar_fecha: String?

    var entrega_realizada: String
    var entrega_realizada_fecha: String?

    var acepto_terminos_y_condiciones: String
    var marca: String?
    var color: String?
    var sexo_del_conductor: String?

    
}

struct ParkingModel: Decodable {
    
    var parking_id: Int?
    var se_puede_recepcionar: Bool // SI FALSE recepcion_realizada es 'SI'
    var vehiculo_solicitado: String?
    var buscando_vehiculo: String?
    var valet_parking_buscando_id: Int?
    var listo_para_retirar: String?
    var entrega_realizada: String?

}

struct ParkingIDModel: Decodable {
    
    var parking_id: Int


}

