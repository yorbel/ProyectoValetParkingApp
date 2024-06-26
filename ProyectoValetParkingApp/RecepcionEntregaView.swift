//
//  RecepcionEntregaView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/31/24.
//

import SwiftUI
import Foundation
import SocketIO

struct RecepcionEntregaView: View {

    let globales = UserDefaults.standard

    @EnvironmentObject var router: Router

    @State private var ios_mostrar_mensaje : Bool  = false
    @State private var ios_mensaje : String = ""
    
    var ticket: String = ""

    @State private var parking: ParkingModel = ParkingModel(parking_id: nil, se_puede_recepcionar:true, vehiculo_solicitado: nil, buscando_vehiculo: nil, valet_parking_buscando_id:nil, listo_para_retirar:nil, entrega_realizada: nil)
    @State private var confirmar_recepcion_realizada : Bool = false
    @State private var confirmar_buscando_vehiculo : Bool = false
    @State private var confirmar_listo_para_retirar : Bool = false
    @State private var confirmar_entrega_realizada : Bool = false

    @State private var manager: SocketManager!

    @State private var socket: SocketIOClient!
       
    var body: some View {
        ZStack{
            Image("fondo")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                Image("logo")
                    .resizable()
                    .frame(height: 125, alignment: .center)
                HStack{
                    Text("**TICKET: \(ticket)**")
                        .font(.title)
                        .foregroundColor(.white)

                  
                    if parking.listo_para_retirar == "SI" {

                        Button("", systemImage: "car") {

                            socket.emit("vehiculo_retirar_urgente_valet_parking", ["ticket": ticket] )
                            ios_mensaje = "Alerta de retiro enviada."
                            ios_mostrar_mensaje = true
                        
                        }
                        .frame(width: 40)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.0, green: 0.0, blue: 0.6235294117647059))
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()

                    }

                   

                }
                
                Image("vehiculo")
                    .resizable()
                    .frame(height: 189, alignment: .center)
                
                Text("Marca: Toyota - Color: Blanco - Sexo: Masculino")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ScrollView {

                    VStack(alignment: .center, spacing: -20){
                        
                        Button("**RECEPCION REALIZADA**", systemImage: parking.se_puede_recepcionar ? "circle" : "checkmark.circle") {
                            
                            confirmar_recepcion_realizada = true

                        }
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(parking.se_puede_recepcionar ? Color(red: 196, green: 0.0, blue: 0) : Color(red: 0.0, green: 0.0, blue: 0.6235294117647059))
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()
                        .alert("¿Confirma que realizo la recepción del vehículo?", isPresented: $confirmar_recepcion_realizada) {
                            Button("SI", role: .destructive) {

                                if(!parking.se_puede_recepcionar){

                                    ios_mensaje = "Recepción del vehículo ya fue realizada."
                                    ios_mostrar_mensaje = true
                                    return   
                                }
                                
                                accion_recepcion_realizada()
                            }
                            Button("NO", role: .cancel) { }
                        }
                        
                        Button("**BUSCANDO VEHICULO**", systemImage: parking.buscando_vehiculo == "SI" ? "checkmark.circle":  "circle" ) {
                            
                            confirmar_buscando_vehiculo = true

                        }
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background( parking.buscando_vehiculo == "SI" ? Color(red: 0.0, green: 0.0, blue: 0.6235294117647059) : Color(red: 159, green: 0, blue: 0))
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()
                        .alert("¿Confirma que podra realizar la busqueda del vehículo?", isPresented: $confirmar_buscando_vehiculo) {
                            Button("SI", role: .destructive) {
                                
                                if( parking.buscando_vehiculo == "SI" ){

                                    ios_mensaje = "La busqueda del vehículo ya esta siendo realizada."
                                    ios_mostrar_mensaje = true
                                    return   
                                }

                                accion_buscando_vehiculo()

                            }
                            Button("NO", role: .cancel) { }
                        }
                        
                        Button("**LISTO PARA RETIRAR**", systemImage: parking.listo_para_retirar == "SI" ? "checkmark.circle":  "circle" ) {
                            
                
                            confirmar_listo_para_retirar = true

                        }
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background( parking.listo_para_retirar == "SI" ? Color(red: 0.0, green: 0.0, blue: 0.6235294117647059) : Color(red: 159, green: 0, blue: 0))
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()
                        .alert("¿Confirma que el vehículo esta listo para retirar?", isPresented: $confirmar_listo_para_retirar) {
                            Button("SI", role: .destructive) { 

                                if( parking.buscando_vehiculo == "NO" ){

                                    ios_mensaje = "Primero debe marcar BUSCANDO VEHÍCULO."
                                    ios_mostrar_mensaje = true
                                    return   
                                }

                                if( parking.listo_para_retirar == "SI" ){

                                    ios_mensaje = "El vehículo ya se encuentra listo para retirar."
                                    ios_mostrar_mensaje = true
                                    return   
                                }

                                accion_listo_para_retirar()

                            }
                            Button("NO", role: .cancel) { }
                        }
                        
                        Button("**ENTREGA REALIZADA**", systemImage: parking.entrega_realizada == "SI" ? "checkmark.circle":  "circle" ) {
                            
                            confirmar_entrega_realizada = true 

                        }
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background( parking.entrega_realizada == "SI" ? Color(red: 0.0, green: 0.0, blue: 0.6235294117647059) :  Color(red: 159, green: 0, blue: 0))
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()
                        .alert("¿Confirma que realizo la entrega del vehículo?", isPresented: $confirmar_entrega_realizada) {
                            Button("SI", role: .destructive) { 

                                if( parking.listo_para_retirar == "NO" ){

                                    ios_mensaje = "Primero debe marcar LISTO PARA RETIRAR."
                                    ios_mostrar_mensaje = true
                                    return   
                                }

                                if( parking.entrega_realizada == "SI" ){

                                    ios_mensaje = "La entrega del vehículo ya fue realizada."
                                    ios_mostrar_mensaje = true
                                    return   
                                }

                                accion_entrega_realizada()

                            }
                            Button("NO", role: .cancel) { }
                        }                
                        
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {

            ToolbarItem(placement: .navigationBarLeading) {

                Button {
               
                    router.path.removeLast()

                } label: {
            
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Atrás")
                    }
                }
            }
        }
        .alert("Mensaje AVP", isPresented: $ios_mostrar_mensaje){
            Button("OK"){}
        } message: {
            Text(ios_mensaje)
        }.onAppear {
            accion_conectar_al_socket()
            accion_ticket_se_puede_recepcionar()
        }
        .onDisappear {
            accion_desconectar_al_socket()
        }
    }

    func accion_ticket_se_puede_recepcionar(){

        guard let token = globales.string(forKey: "token") else {

            return
        }

        guard let lugar_id = globales.string(forKey: "lugar_id") else {

            return
        }

        
        guard let url = (URL(string: Globales.url + "/api/parking/ticket_se_puede_recepcionar/\(ticket)/\(lugar_id)")) else {
           
            return

        }
      
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            
            if let error = error {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            } else if let data = data {
                
               
                
                guard let response = response as? HTTPURLResponse else {
                    
                    ios_mensaje = "Error en operación de la aplicación"
                    ios_mostrar_mensaje = true
                    return
                    
                }
                
                if response.statusCode == 200 {
                    
                     DispatchQueue.main.async {
                        do {
                            
                            parking = try JSONDecoder().decode(ParkingModel.self, from: data)
                                                                        
                        } catch let error {

                            print(error)
                            
                            ios_mensaje = "Error en operación de la aplicación"
                            ios_mostrar_mensaje = true
                            return
                            
                        }
                    }
                    
                } else {
                    
                     DispatchQueue.main.async {
                        do {
                            
                            if response.statusCode == 400 {
                                
                                let dataError = try JSONDecoder().decode([DataErrorModel].self, from: data)
                                
                                ios_mensaje = dataError[0].msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }else{
                                
                                let dataError = try JSONDecoder().decode(DataErrorModel.self, from: data)
                                
                                ios_mensaje = dataError.msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }
                            
                        } catch let error {
                            
                            ios_mensaje = "Error en operación de la aplicación"
                            ios_mostrar_mensaje = true
                            return
                            
                        }
                    }
                }
                
            } else {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            }
        }
        
        task.resume()
        
    }


    func accion_recepcion_realizada(){

        guard let lugar_id = globales.string(forKey: "lugar_id") else {

            return
        }
    
        guard let token = globales.string(forKey: "token") else {

            return
        }

        
        guard let url = (URL(string: Globales.url + "/api/parking/ticket_crear_recepcion/\(ticket)/\(lugar_id)")) else {
           
            return

        }
      
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            
            if let error = error {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            } else if let data = data {
                
               
                
                guard let response = response as? HTTPURLResponse else {
                    
                    ios_mensaje = "Error en operación de la aplicación"
                    ios_mostrar_mensaje = true
                    return
                    
                }
                
                if response.statusCode == 200 {
                    
                     DispatchQueue.main.async {
                        do {
                            
                            let parking_id = try JSONDecoder().decode(ParkingIDModel.self, from: data)
                            parking.parking_id = parking_id.parking_id
                            parking.se_puede_recepcionar = false
                            router.path.removeLast()
                                                                        
                        } catch let error {

                            print(error)
                            
                            ios_mensaje = "Error en operación de la aplicación"
                            ios_mostrar_mensaje = true
                            return
                            
                        }
                    }
                    
                } else {
                    
                     DispatchQueue.main.async {
                        do {
                            
                            if response.statusCode == 400 {
                                
                                let dataError = try JSONDecoder().decode([DataErrorModel].self, from: data)
                                
                                ios_mensaje = dataError[0].msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }else{
                                
                                let dataError = try JSONDecoder().decode(DataErrorModel.self, from: data)
                                
                                ios_mensaje = dataError.msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }
                            
                        } catch let error {
                            
                            ios_mensaje = "Error en operación de la aplicación"
                            ios_mostrar_mensaje = true
                            return
                            
                        }
                    }
                }
                
            } else {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            }
        }
        
        task.resume()
        
    }

    func accion_buscando_vehiculo(){
    
        guard let token = globales.string(forKey: "token") else {

            return
        }

        
        guard let url = (URL(string: Globales.url + "/api/parking/ticket_buscando_vehiculo/\(parking.parking_id!)")) else {
           
            return

        }


        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            
            if let error = error {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            } else if let data = data {

                guard let response = response as? HTTPURLResponse else {
                    
                    ios_mensaje = "Error en operación de la aplicación"
                    ios_mostrar_mensaje = true
                    return
                    
                }
                
                if response.statusCode == 204 {
                 
                    parking.buscando_vehiculo = "SI"
                    socket.emit("buscando_vehiculo_valet_parking", ["ticket": ticket] )                                                         
                    
                } else {
                    
                     DispatchQueue.main.async {
                        do {
                            
                            if response.statusCode == 400 {
                                
                                let dataError = try JSONDecoder().decode([DataErrorModel].self, from: data)
                                
                                ios_mensaje = dataError[0].msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }else{
                                
                                let dataError = try JSONDecoder().decode(DataErrorModel.self, from: data)
                                
                                ios_mensaje = dataError.msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }
                            
                        } catch let error {
                            
                            ios_mensaje = "Error en operación de la aplicación"
                            ios_mostrar_mensaje = true
                            return
                            
                        }
                    }
                }
                
            } else {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            }
        }
        
        task.resume()
        
    }

    func accion_listo_para_retirar(){
    
        guard let token = globales.string(forKey: "token") else {

            return
        }

        
        guard let url = (URL(string: Globales.url + "/api/parking/ticket_listo_para_retirar/\(parking.parking_id!)")) else {
           
            return

        }


        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            
            if let error = error {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            } else if let data = data {
                
               
                
                guard let response = response as? HTTPURLResponse else {
                    
                    ios_mensaje = "Error en operación de la aplicación"
                    ios_mostrar_mensaje = true
                    return
                    
                }
                
                if response.statusCode == 204 {
                 
                    parking.listo_para_retirar = "SI"
                    socket.emit("listo_para_retirar_valet_parking", ["ticket": ticket] )                                                         
                    
                } else {
                    
                     DispatchQueue.main.async {
                        do {
                            
                            if response.statusCode == 400 {
                                
                                let dataError = try JSONDecoder().decode([DataErrorModel].self, from: data)
                                
                                ios_mensaje = dataError[0].msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }else{
                                
                                let dataError = try JSONDecoder().decode(DataErrorModel.self, from: data)
                                
                                ios_mensaje = dataError.msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }
                            
                        } catch let error {
                            
                            ios_mensaje = "Error en operación de la aplicación"
                            ios_mostrar_mensaje = true
                            return
                            
                        }
                    }
                }
                
            } else {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            }
        }
        
        task.resume()
        
    }

    func accion_entrega_realizada(){
    
        guard let token = globales.string(forKey: "token") else {

            return
        }

        
        guard let url = (URL(string: Globales.url + "/api/parking/ticket_entrega_realizada/\(parking.parking_id!)")) else {
           
            return

        }


        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            
            if let error = error {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            } else if let data = data {
                
               
                
                guard let response = response as? HTTPURLResponse else {
                    
                    ios_mensaje = "Error en operación de la aplicación"
                    ios_mostrar_mensaje = true
                    return
                    
                }
                
                if response.statusCode == 204 {
                 
                    parking.entrega_realizada = "SI"
                    socket.emit("vehiculo_entregado_valet_parking", ["ticket": ticket] )

                    let seconds = 2.0

                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

                        router.path.removeLast()
                        
                    }
                    
                } else {
                    
                     DispatchQueue.main.async {
                        do {
                            
                            if response.statusCode == 400 {
                                
                                let dataError = try JSONDecoder().decode([DataErrorModel].self, from: data)
                                
                                ios_mensaje = dataError[0].msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }else{
                                
                                let dataError = try JSONDecoder().decode(DataErrorModel.self, from: data)
                                
                                ios_mensaje = dataError.msg
                                ios_mostrar_mensaje = true
                                return
                                
                            }
                            
                        } catch let error {
                            
                            ios_mensaje = "Error en operación de la aplicación"
                            ios_mostrar_mensaje = true
                            return
                            
                        }
                    }
                }
                
            } else {
                
                ios_mensaje = "Error en comunicación con el sistema."
                ios_mostrar_mensaje = true
                return
                
            }
        }
        
        task.resume()
        
    }

    func accion_conectar_al_socket(){

        guard let lugar_id = globales.string(forKey: "lugar_id") else {

            return
        }

        manager = SocketManager(socketURL:  URL(string: Globales.url)!, config: [.log(true), .compress, .connectParams(["ticket": ticket, "lugar_id": lugar_id])] )

        socket =  manager.defaultSocket

        socket.on("connect") {data, ack in

            print("SOCKET CONECTADO")

        }
        socket.on("disconnect") {data, ack in

            print("SOCKET DESCONECTADO")

        }

        socket.connect()

    }

    func accion_desconectar_al_socket(){

        socket.disconnect();

    }

}

#Preview {
    RecepcionEntregaView()
}
