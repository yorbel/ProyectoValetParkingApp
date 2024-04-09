//
//  PrincipalView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/31/24.
//

import SwiftUI



struct PrincipalView: View {
    
    let globales = UserDefaults.standard
    
    @State private var ticket : String = "000001"
    

    @State private var tickets_solicitados : [TicketModel] = [

        TicketModel(id: 1, ticket: "000001", ticket_solicitado: "NO"),
        TicketModel(id: 2, ticket: "000002", ticket_solicitado: "NO"),
        TicketModel(id: 3, ticket: "000003", ticket_solicitado: "NO"),
        TicketModel(id: 4, ticket: "000004", ticket_solicitado: "NO"),
        TicketModel(id: 5, ticket: "000005", ticket_solicitado: "NO"),
        TicketModel(id: 6, ticket: "000006", ticket_solicitado: "NO"),
        TicketModel(id: 7, ticket: "000007", ticket_solicitado: "NO"),
        TicketModel(id: 8, ticket: "000008", ticket_solicitado: "NO"),
        TicketModel(id: 9, ticket: "000009", ticket_solicitado: "NO"),
        TicketModel(id: 10, ticket: "000010", ticket_solicitado: "NO"),
        TicketModel(id: 11, ticket: "000011", ticket_solicitado: "NO"),
        TicketModel(id: 12, ticket: "000012", ticket_solicitado: "NO"),
        TicketModel(id: 13, ticket: "000012", ticket_solicitado: "NO"),
        TicketModel(id: 14, ticket: "000014", ticket_solicitado: "NO"),
        TicketModel(id: 15, ticket: "000015", ticket_solicitado: "NO"),
        TicketModel(id: 16, ticket: "000016", ticket_solicitado: "NO"),
        TicketModel(id: 17, ticket: "000017", ticket_solicitado: "NO"),
        TicketModel(id: 18, ticket: "000018", ticket_solicitado: "NO"),
        TicketModel(id: 19, ticket: "000019", ticket_solicitado: "NO"),

    ]
    
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
                
                ScrollView {

                    VStack(alignment: .leading){

                        ForEach( 0...Int(ceil(Double(tickets_solicitados.count/3))), id: \.self ){ i in
                            HStack{
                                ForEach(tickets_solicitados[(3*i)...((3*(i+1) > tickets_solicitados.count ? (tickets_solicitados.count-1) : ((3*(i+1))-1) ))], id: \.id){ ticket_solicitado in
                                    Label("**\(ticket_solicitado.ticket)**", systemImage: "car")
                                        .foregroundColor(.white)
                                        .padding(9)
                                        .background(Color(red: 0, green: 0, blue: 159))
                                        .cornerRadius(15)
                                        
                                }
                            }
                        }

                    }
                    .frame(maxHeight: 200)
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
                        RecepcionEntregaView(ticket: "000001")
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
        }
    }
}

#Preview {
    PrincipalView()
}
