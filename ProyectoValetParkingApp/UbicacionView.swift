//
//  UbicacionView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/29/24.
//

import SwiftUI
import CoreLocation
import FirebaseCore
import FirebaseMessaging
import UserNotifications

// extension AppDelegate: MessagingDelegate {

//     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

//         Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
//         // Messaging.messaging().apnsToken = deviceToken
//     }
    
//     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//         if let fcm = Messaging.messaging().fcmToken {
//             print("fcm", fcm)
//         }
//     }


// }

struct LugarView: View {
    
    var lugar: LugarModel
    
    var body: some View {

        HStack(spacing: 3){

            VStack(alignment: .leading){
                AsyncImage( url: URL( string: "https://api.apolovalet.com/lugares/lugar.png"), content: { image in
                image
                .resizable()
                .frame(width: 64, height: 64)
                }, 
                placeholder: {
                    ProgressView()
                })
            }
            VStack(alignment: .leading){
                Text(lugar.nombre)
                .font(.headline)
                .foregroundColor(.white)
                Text(lugar.direccion)
                .font(.subheadline)
                .foregroundColor(.white)
            }
            Spacer()
            
        }
        .frame(maxWidth: .infinity)

    }

}

struct UbicacionView: View {
    
    let globales = UserDefaults.standard

    @EnvironmentObject var router: Router
    
    @State private var ios_mostrar_mensaje : Bool  = false
    @State private var ios_mensaje : String = ""
    
    @StateObject var locationDataManager = LocationDataManager()
   
    @State private var pantalla_principal = false
    
    @State private var lugares : [LugarModel] = []
    @State private var lugar_id : Int?
    
    var body: some View {
        ZStack{
            Image("fondo")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 10) {
                Image("logo")
                    .resizable()
                    .frame(height: 125, alignment: .center)
                
                Text("Indica ubicación actual")
                    .font(.headline)
                    .foregroundColor(.white)
                    .onTapGesture{
                       
                        accion_conseguir_ubicacion_actual()
                    
                    }
                    .onReceive(locationDataManager.$establecio) { establecio in

                        print("ESTABLECIDO")

                        if establecio  {
                            
                            print(locationDataManager.latitud)

                            print(locationDataManager.longitud)


                        }
                        
                        guard let latitud = locationDataManager.latitud else {
            
                            return
                            
                        }
                        
                        guard let longitud = locationDataManager.longitud else {
                            
                            return
                            
                        }

                        print("XXXXXXXXX")

                        print(latitud)
                        print(longitud)
                        
                        accion_buscar_lugares_cercanos(latitud: latitud, longitud: longitud)

                        print("XXXXXXXXX")


                    }
                
                List{

                    ForEach(lugares, id: \.id){ lugar in
                        LugarView(lugar: lugar)
                            .listRowBackground(Color.clear)
                            .border( lugar_id == lugar.id ? .white  : .clear )
                            .onTapGesture{
                       
                                lugar_id = lugar.id
                            
                            }
                    }
                    
                }.listStyle(.plain)
                
                Button("**CONTINUAR**") {

                    print("LUGAR ID")
                    print(lugar_id)

                    if( lugar_id != nil ){

                        globales.set(lugar_id, forKey: "lugar_id")

                        // Messaging.messaging().subscribe(toTopic: "lugar\(lugar_id)")

                        Messaging.messaging().subscribe(toTopic: "lugar\(lugar_id)"){ error in

                            if error == nil {

                                print("SI SUSCRITO A LUGAR\(lugar_id)")
                            }
                            else{

                                print("NO SUSCRITO A LUGAR\(lugar_id)")

                            }
                        }

                        router.path.append(2)

                    } else {

                        ios_mensaje = "Debe indicar ubicación actual"
                        ios_mostrar_mensaje = true
                        return

                    }
                    
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
                .alert("Mensaje AVP", isPresented: $ios_mostrar_mensaje){
                    Button("OK"){}
                } message: {
                    Text(ios_mensaje)
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        
        
        
    }
    
    func accion_buscar_lugares_cercanos(latitud: Double, longitud: Double){
        
        guard let url = (URL(string: Globales.url + "/api/lugares/lugares_cercanos/\(latitud)/\(longitud)")) else {
           
            return
        }
        
      
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(globales.string(forKey: "token"), forHTTPHeaderField: "x-access-token")
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
                            
                            lugares = try JSONDecoder().decode([LugarModel].self, from: data)
                            

                                                     
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
    
    func accion_conseguir_ubicacion_actual(){
          
        guard let latitud = locationDataManager.latitud else {
            
            return
            
        }
        
        guard let longitud = locationDataManager.longitud else {
            
            return
            
        }

        print("COORDENADAS")

        print(latitud)
        print(longitud)
        
        accion_buscar_lugares_cercanos(latitud: latitud, longitud: longitud)
        
    }
}

#Preview {
    UbicacionView()
}
