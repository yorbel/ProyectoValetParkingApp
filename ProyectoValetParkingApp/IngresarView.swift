//
//  ContentView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/29/24.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
}

struct IngresarView: View {
    
    let globales = UserDefaults.standard

    @StateObject var router = Router()
    
    @State private var ios_mostrar_mensaje : Bool  = false
    @State private var ios_mensaje : String = ""
    
    @State private var nombre_usuario : String = ""
    @State private var contrasena : String = ""
    @State private var pantalla_ubicacion = false

    enum Field {

        case nombre_usuario
        case contrasena

    }

    @FocusState private var focused_field: Field?
    
    func ingresar(){
        
        if nombre_usuario == "" {
            ios_mensaje = "Debe ingresar nombre de usuario."
            ios_mostrar_mensaje = true
            return
            
        }
        
        if contrasena == "" {
            ios_mensaje = "Debe ingresar contraseña."
            ios_mostrar_mensaje = true
            return
        }
        
        guard let url = URL(string: Globales.url + "/api/valet_parking/validar_ingreso") else {
            ios_mensaje = "Error en operación de la aplicación"
            ios_mostrar_mensaje = true
            return
        }
        
        let body = ["nombre_usuario": nombre_usuario, "contrasena": contrasena]
        let bodyRequest = try? JSONSerialization.data(withJSONObject: body, options: [])
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyRequest
        
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
                            
                            let usuario = try JSONDecoder().decode(UsuarioModel.self, from: data)
                            
                            
                            globales.set(usuario.token, forKey: "token")
                            globales.set(usuario.valet_parking.id, forKey: "id")
                            globales.set(usuario.valet_parking.nombre_usuario, forKey: "nombre_usuario")
                            globales.set(usuario.valet_parking.nombre, forKey: "nombre")
                            globales.set(usuario.valet_parking.apellido, forKey: "apellido")
                            globales.set(usuario.valet_parking.sesion_id, forKey: "sesion_id")
                            
                            router.path.append(1)
                                                     
                        } catch let error {
                            
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
    
    var body: some View {
        NavigationStack(path: $router.path){
            ZStack{
                Image("fondo")
                .resizable()
                .ignoresSafeArea()
                VStack(alignment: .center, spacing: 10) {
                    Image("logo")
                    .resizable()
                    .frame(height: 125, alignment: .center)
                    
                    TextField("Nombre de Usuario", text: $nombre_usuario)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()
                        .focused($focused_field, equals: .nombre_usuario)
                        .submitLabel(.next)
                    
                    SecureField("Contraseña", text: $contrasena)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                        .overlay( RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0, green: 0, blue: 159), lineWidth: 2)
                        )
                        .padding()
                        .focused($focused_field, equals: .contrasena)
                        .submitLabel(.send)
                    
                    
                    Button("**INGRESAR**", action: ingresar)
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
                    .alert("Mensaje AVP", isPresented: $ios_mostrar_mensaje){
                        Button("OK"){}
                    } message:{
                        Text(ios_mensaje)
                    }
                    .navigationDestination(for: Int.self){ destination in

                        if destination == 1 {
                          
                            UbicacionView().environmentObject(router)

                        }
                        if destination == 2 {

                            PrincipalView().environmentObject(router)

                        }
                        
                       
                    }
                    
                }
            }
            
        }
        .onTapGesture {
                        
            focused_field = nil
                                            
        }
        .onSubmit {

            if focused_field == .nombre_usuario {

                focused_field = .contrasena

            } else if focused_field == .contrasena {

                focused_field = nil
                ingresar()

            }

        }
        .task{

            accion_existe_sesion()

        }
    }

    func accion_existe_sesion(){

        guard let sesion_id = globales.string(forKey: "sesion_id") else {

            return
        }

        guard let token = globales.string(forKey: "token") else {

            return
        }

        guard let lugar_id = globales.string(forKey: "lugar_id") else {

            return
        }

        if( sesion_id != nil  && token != nil  && lugar_id != nil ){

            router.path.append(2)

        }

    }
}

#Preview {
    IngresarView()
}
