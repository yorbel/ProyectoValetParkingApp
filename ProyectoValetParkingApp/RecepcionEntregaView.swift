//
//  RecepcionEntregaView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/31/24.
//

import SwiftUI

struct RecepcionEntregaView: View {
    
    @ObservedObject var ticket
    
    var body: some View {
        ZStack{
            Image("fondo")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                Image("logo")
                    .resizable()
                    .frame(height: 125, alignment: .center)
                
                Text("**TICKET: \(ticket.numero)**")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Image("vehiculo")
                    .resizable()
                    .frame(height: 189, alignment: .center)
                
                Text("Marca: Toyota - Color: Blanco - Sexo: Masculino")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .center, spacing: -20){
                    
                    Button("**RECEPCION REALIZADA**", systemImage: "checkmark.circle") {
                        
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
                    
                    Button("**BUSCANDO VEHICULO**", systemImage: "circle") {
                        
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
                    
                    Button("**LISTO PARA RETIRAR**", systemImage: "circle") {
                        
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
                    
                    Button("**ENTREGA REALIZADA**", systemImage: "circle") {
                        
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
                    .padding()                }
            }
        }
    }
}

#Preview {
    RecepcionEntregaView()
}
