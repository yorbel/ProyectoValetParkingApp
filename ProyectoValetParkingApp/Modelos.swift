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
