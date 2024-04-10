//
//  PrincipalView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/31/24.
//

import SwiftUI


class ListaTicketModel: ObservableObject {

    @Published var tickets_solicitados : [TicketModel] = []

}


struct PrincipalView: View {
    
    let globales = UserDefaults.standard

    @State private var ios_mostrar_mensaje : Bool  = false
    @State private var ios_mensaje : String = ""
    
    @State private var ticket : String = ""
    
    @ObservedObject var lista_tickets_solicitados = ListaTicketModel()

    @State private var pantalla_recepcion_entrega = false
    
    @State private var activo = true
    
    var body: some View {
        ZStack{
            Image("fondo")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                Image("logo")
                .resizable()
                .frame(height: 125, alignment: .center)
                
                Text("**\(globales.string(forKey: "nombre") ?? "") \(globales.string(forKey: "apellido") ?? "")**")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                    Toggle("Activoo", isOn: $activo)
                        .labelsHidden()
                        .tint(Color(red: 0, green: 0, blue: 159))
                    Text(activo ? "Activo" : "Inactivo")
                        .font(.body)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .center, spacing: -20){
                    TextField("INGRESAR TICKET", text: $ticket)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()
                    Button("**CODIGO QR**", systemImage: "camera") {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.0, green: 0.0, blue: 0.6235294117647059)/*@END_MENU_TOKEN@*/)
                    .cornerRadius(15)
                    .overlay( RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                    )
                    .padding()
                }
                
                if(lista_tickets_solicitados.tickets_solicitados.count > 0){
                    ScrollView {

                        VStack(alignment: .leading){

                            ForEach( 0...Int(ceil(Double(lista_tickets_solicitados.tickets_solicitados.count/3))), id: \.self ){ i in
                                HStack{
                                    ForEach(lista_tickets_solicitados.tickets_solicitados[(3*i)...( ((3*i)+2) > (lista_tickets_solicitados.tickets_solicitados.count-1) ? (lista_tickets_solicitados.tickets_solicitados.count-1) : ((3*i)+2) )], id: \.id){ ticket_solicitado in
                                        Label("**\(ticket_solicitado.ticket)**", systemImage: ticket_solicitado.vehiculo_solicitado == "SI" ? "clock" : "car" )
                                            .foregroundColor(.white)
                                            .padding(9)
                                            .background( ticket == ticket_solicitado.ticket ? Color(red: 0, green: 212, blue: 42) : Color(red: 0, green: 0, blue: 159) )
                                            .cornerRadius(15)
                                            .onTapGesture{
                        
                                                ticket = ticket_solicitado.ticket
                                            
                                            }
                                            
                                    }
                                }
                            }

                        }
                        .frame(maxHeight: 200)
                    }
                }
               
                
                VStack(alignment: .center, spacing: -20){
                    Button("**PROCESAR TICKET**") {
                        
                        pantalla_recepcion_entrega = true
                        
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
                    .navigationDestination(isPresented: $pantalla_recepcion_entrega ){
                        RecepcionEntregaView(ticket: ticket)
                    }

                    Button("**CERRAR SESION**") {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 196, green: 0, blue: 0))
                    .cornerRadius(15)
                    .overlay( RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 196, green: 0, blue: 0), lineWidth: 2)
                    )
                    .padding()
                }
                
            }
        }.alert("Mensaje AVP", isPresented: $ios_mostrar_mensaje){
            Button("OK"){}
        } message: {
            Text(ios_mensaje)
        }.onAppear {
            accion_buscar_tickes_solicitados() 
        }
    }

    func accion_buscar_tickes_solicitados(){

        guard let token = globales.string(forKey: "token") else {

            return
        }

        guard let lugar_id = globales.string(forKey: "lugar_id") else {

            return
        }
        
        guard let url = (URL(string: Globales.url + "/api/parking/tickets_sin_entrega_realizada/\(lugar_id)")) else {
           
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
                            
                            lista_tickets_solicitados.tickets_solicitados = try JSONDecoder().decode([TicketModel].self, from: data)
                            
                            print("NUEVOS TICKETS")
                            print(lista_tickets_solicitados.tickets_solicitados)
                                                                        
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
    PrincipalView()
}
