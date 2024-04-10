//
//  RecepcionEntregaView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/31/24.
//

import SwiftUI

struct RecepcionEntregaView: View {

    let globales = UserDefaults.standard

    @State private var ios_mostrar_mensaje : Bool  = false
    @State private var ios_mensaje : String = ""
    
    var ticket: String = ""

    @State private var parking: ParkingModel = ParkingModel(parking_id: nil, se_puede_recepcionar:false, vehiculo_solicitado: nil, buscando_vehiculo: nil, valet_parking_buscando_id:nil, listo_para_retirar:nil, entrega_realizada: nil)
    @State private var confirmar_recepcion_realizada : Bool = false
    @State private var confirmar_buscando_vehiculo : Bool = false
    @State private var confirmar_listo_para_retirar : Bool = false
    @State private var confirmar_entrega_realizada : Bool = false

    var body: some View {
        ZStack{
            Image("fondo")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                Image("logo")
                    .resizable()
                    .frame(height: 125, alignment: .center)
                
                Text("**TICKET: \(ticket)**")
                    .font(.title)
                    .foregroundColor(.white)
                
                Image("vehiculo")
                    .resizable()
                    .frame(height: 189, alignment: .center)
                
                Text("Marca: Toyota - Color: Blanco - Sexo: Masculino")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .center, spacing: -20){
                    
                    Button("**RECEPCION REALIZADA**", systemImage: parking.se_puede_recepcionar ? "circle" : "checkmark.circle") {
                        
                        confirmar_recepcion_realizada = true

                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.0, green: 0.0, blue: 0.6235294117647059))
                    .cornerRadius(15)
                    .overlay( RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                    )
                    .padding()
                    .alert("¿Confirma que realizo la recepción del vehículo?", isPresented: $confirmar_recepcion_realizada) {
                        Button("SI", role: .destructive) { }
                        Button("NO", role: .cancel) { }
                    }
                    
                    Button("**BUSCANDO VEHICULO**", systemImage: parking.buscando_vehiculo == "SI" ? "checkmark.circle":  "circle" ) {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 159, green: 0, blue: 0))
                    .cornerRadius(15)
                    .overlay( RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 159, green: 0, blue: 0), lineWidth: 2)
                    )
                    .padding()
                    .alert("¿Confirma que podra realizar la busqueda del vehículo?", isPresented: $confirmar_buscando_vehiculo) {
                        Button("SI", role: .destructive) { }
                        Button("NO", role: .cancel) { }
                    }
                    
                    Button("**LISTO PARA RETIRAR**", systemImage: parking.listo_para_retirar == "SI" ? "checkmark.circle":  "circle" ) {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 159, green: 0, blue: 0))
                    .cornerRadius(15)
                    .overlay( RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 159, green: 0, blue: 0), lineWidth: 2)
                    )
                    .padding()
                    .alert("¿Confirma que el vehículo esta listo para retirar?", isPresented: $confirmar_listo_para_retirar) {
                        Button("SI", role: .destructive) { }
                        Button("NO", role: .cancel) { }
                    }
                    
                    Button("**ENTREGA REALIZADA**", systemImage: parking.entrega_realizada == "SI" ? "checkmark.circle":  "circle" ) {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 159, green: 0, blue: 0))
                    .cornerRadius(15)
                    .overlay( RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 159, green: 0, blue: 0), lineWidth: 2)
                    )
                    .padding()
                    .alert("¿Confirma que realizo la entrega del vehículo?", isPresented: $confirmar_entrega_realizada) {
                        Button("SI", role: .destructive) { }
                        Button("NO", role: .cancel) { }
                    }                
                    
                }
            }
        }.alert("Mensaje AVP", isPresented: $ios_mostrar_mensaje){
            Button("OK"){}
        } message: {
            Text(ios_mensaje)
        }.onAppear {
           accion_ticket_se_puede_recepcionar()
        }
    }

    func accion_ticket_se_puede_recepcionar(){

        guard let token = globales.string(forKey: "token") else {

            return
        }

        
        guard let url = (URL(string: Globales.url + "/api/parking/ticket_se_puede_recepcionar/\(ticket)")) else {
           
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
}

#Preview {
    RecepcionEntregaView()
}
