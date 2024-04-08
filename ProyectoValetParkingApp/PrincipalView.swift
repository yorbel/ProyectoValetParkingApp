//
//  PrincipalView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/31/24.
//

import SwiftUI

struct Ticket{
    
    let id: Int
    let numero: String
    
}

struct PrincipalView: View {
    
    let globales = UserDefaults.standard
    
    @State private var ticket : String = "000001"
    
    @State private var tickets = [

        Ticket(id: 1, numero: "000001"),
        Ticket(id: 2, numero: "000002"),
        Ticket(id: 3, numero: "000003"),
        Ticket(id: 4, numero: "000004"),
        Ticket(id: 5, numero: "000005"),
        Ticket(id: 6, numero: "000006"),
        Ticket(id: 7, numero: "000007"),

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
                
               
                VStack(alignment: .leading){

                    ForEach( 1...ceil(tickets.count/3), id: \.self ){
                        HStack{
                            // ForEach(tickets, id: \.id){ ticket in
                                Label("**\($0)**", systemImage: "car")
                                    .foregroundColor(.white)
                                    .padding(9)
                                    .background(Color(red: 0, green: 0, blue: 159))
                                    .cornerRadius(15)
                                    
                            // }
                        }
                    }
                }.listRowBackground(Color.clear)
               
                
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
