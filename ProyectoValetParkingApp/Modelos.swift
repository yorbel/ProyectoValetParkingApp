//
//  UsuarioModel.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 2/19/24.
//

import Foundation

struct DataErrorModel: Decodable {
    
    let msg : String
    
}

struct ValetParkingModel: Decodable {
    
    let id: Int
    let nombre_usuario: String
    let nombre: String
    let apellido: String
    let sesion_id: Int
    
}

struct UsuarioModel: Decodable {
    
    let token: String
    let valet_parking: ValetParkingModel
  
}

struct LugarModel: Decodable {
    
    let id: Int
    let nombre: String
    let direccion: String
    let imagen: String
    let latitud: Double
    let longitud: Double
    
}


struct TicketModel: Decodable {
    
    let id: Int
    let lugar_id: Int
    let sesion_recepcion_id: Int

    let ticket: String

    let recepcion_realizada: String
    let recepcion_realizada_fecha: String
    let valet_parking_recepcion_id: Int

    let cliente_conectado: String
    let cliente_conectado_fecha: String

    let vehiculo_solicitado: String
    let vehiculo_solicitado_fecha: String

    let sesion_busqueda_id : Int
    let buscando_vehiculo: String
    let buscando_vehiculo_fecha: String
    let valet_parking_buscando_id: Int

    let listo_para_retirar: String
    let listo_para_retirar_fecha: String

    let entrega_realizada: String
    let entrega_realizada_fecha: String

    let acepto_terminos_y_condiciones: String
    let marca: String
    let color: String
    let sexo_del_conductor: String

    
}

