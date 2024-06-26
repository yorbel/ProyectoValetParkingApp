//
//  PrincipalView.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/31/24.
//

import SwiftUI
import CodeScanner
import AVFoundation
import SDWebImageSwiftUI
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
     // CUANDO EL USUARIO ESTA VIENDO LA PANTALLA

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("NOTIFICACION FOREGROUND \(userInfo)")

        completionHandler([[.alert, .badge, .sound]])
    }

    // CUANDO EL USUARIO NO ESTA VIENDO LA PANTALLA

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // let userInfo = response.notification.request.content.userInfo

        // if let customData = userInfo["customData"] as? String {
        //     print("Custom data received: \(customData)")

        //     switch response.actionIdentifier {
        //     case UNNotificationDefaultActionIdentifier:
               
        //         print("Default identifier")

        //     case "show":
               
        //         print("Show more information…")

        //     default:
        //         break
        //     }
        // }

        completionHandler()
    }
}

extension URL {
  subscript(name: String) -> String? {
    guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
    return urlComponents.queryItems?.first(where: { $0.name == name })?.value
  }
}


class ListaTicketModel: ObservableObject {

    @Published var tickets_solicitados : [TicketModel] = []

}


struct PrincipalView: View {
    
    let globales = UserDefaults.standard

    @EnvironmentObject var router: Router

    @State private var ios_mostrar_mensaje : Bool  = false
    @State private var ios_mensaje : String = ""
    
    @State private var ticket : String = ""
    
    @StateObject var lista_tickets_solicitados = ListaTicketModel()

    @State private var pantalla_recepcion_entrega = false
    
    @State private var activo = true

    @State private var mostrar_scanner_qr = false

    @State private var player : AVAudioPlayer?
    @State private var mostrar_alerta = false

    @State private var animar_imagen_alerta : Bool  = true

    @FocusState private var is_focused: Bool
    
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
                
                VStack(alignment:.center){

                    Toggle("Activoo", isOn: $activo)
                        .labelsHidden()
                        .tint(Color(red: 0, green: 0, blue: 159))
                        .onChange(of: activo) { state in

                            if state {

                                accion_inactividad_finalizar()

                            }else{

                                accion_inactividad_iniciar()

                            }
                        }

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
                        .focused($is_focused)

                    Button("**CODIGO QR**", systemImage: "camera") {

                        mostrar_scanner_qr = true
                        
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
                    .sheet(isPresented: $mostrar_scanner_qr) {

                        CodeScannerView(codeTypes: [.qr]) { response in

                            mostrar_scanner_qr = false

                            switch response {
                                case .success(let result):

                                    guard let url_qr = URL(string: result.string ) else {

                                        ios_mensaje = "Error al realizar lectura de la URL."
                                        ios_mostrar_mensaje = true
                                        return

                                    }

                                    guard let ticket_query = url_qr["ticket"] else {

                                        ios_mensaje = "Error al realizar lectura de la URL."
                                        ios_mostrar_mensaje = true
                                        return
                                    }

                                    ticket = ticket_query

                                case .failure(let error):
                                    ios_mensaje = "Error al realizar lectura del QR."
                                    ios_mostrar_mensaje = true
                            }

                        }
                    }
                }
                
                if(lista_tickets_solicitados.tickets_solicitados.count > 0){
                    ScrollView {

                        VStack(alignment: .leading, spacing: 6){

                            ForEach( 0...Int(ceil(Double((lista_tickets_solicitados.tickets_solicitados.count-1)/3))), id: \.self ){ i in
                                HStack(spacing: 6){
                                    ForEach(lista_tickets_solicitados.tickets_solicitados[(3*i)...( ((3*i)+2) > (lista_tickets_solicitados.tickets_solicitados.count-1) ? (lista_tickets_solicitados.tickets_solicitados.count-1) : ((3*i)+2) )], id: \.id){ ticket_solicitado in
                                        Label("**\(ticket_solicitado.ticket)**", systemImage: ticket_solicitado.vehiculo_solicitado == "SI" ? "clock" : "car" )
                                            .foregroundColor(.white)
                                            .padding(9)
                                            .background( ticket == ticket_solicitado.ticket ? Color(red: 0, green: 212 / 255 , blue: 42 / 255) : ( ticket_solicitado.vehiculo_solicitado == "SI" ? Color(red: 196, green: 0, blue: 0) : Color(red: 0, green: 0, blue: 159) ) )
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

                        if(ticket == ""){

                            ios_mensaje = "Debe ingresar número de ticket."
                            ios_mostrar_mensaje = true
                            return

                        }
                        
                        router.path.append("recepcion_entrega_view")

                        
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
                    .navigationDestination(for: String.self){ destination in

                        RecepcionEntregaView(ticket: ticket).environmentObject(router)

                    }

                    Button("**CERRAR SESION**") {

                        accion_cerrar_sesion()
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
        .onTapGesture{
                        
            is_focused = false
                                            
        }
        .alert("Mensaje AVP", isPresented: $ios_mostrar_mensaje){
            Button("OK"){}
        } message: {
            Text(ios_mensaje)
        }.sheet(isPresented: $mostrar_alerta, onDismiss: accion_desactivar_alerta ) {

            VStack{
                AnimatedImage(name: "back.gif", isAnimating: $animar_imagen_alerta)
                .indicator(.progress)
                .resizable()
                .scaledToFit()

                Text("(\(ticket)) VEHICULO SOLICITADO POR EL CONDUCTOR")
                .font(.caption)
                .foregroundColor(.white)

                Spacer()
            }
            .background(Color(red: 0.0, green: 0.0, blue: 0.6235294117647059))

        }
        .task {
            ticket = ""
            accion_buscar_si_activo()
            accion_buscar_tickes_solicitados() 
        }
    }

    func accion_inactividad_iniciar(){

        guard let token = globales.string(forKey: "token") else {

            return
        }

        guard let sesion_id = globales.string(forKey: "sesion_id") else {

            return
        }
        
        guard let url = (URL(string: Globales.url + "/api/valet_parking/inactividad_iniciar/\(sesion_id)")) else {
           
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
                            
                            let inactividad_id = try JSONDecoder().decode(InactividadIDModel.self, from: data)
                            globales.set(inactividad_id.inactividad_id, forKey: "inactividad_id")
                                                                        
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

    func accion_inactividad_finalizar(){

        guard let token = globales.string(forKey: "token") else {

            return
        }

        guard let inactividad_id = globales.string(forKey: "inactividad_id") else {

            return
        }
        
        guard let url = (URL(string: Globales.url + "/api/valet_parking/inactividad_finalizar/\(inactividad_id)")) else {
           
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
                    
                    globales.removeObject(forKey: "inactividad_id")
                    
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

    func accion_buscar_si_activo(){

        guard let inactividad_id = globales.string(forKey: "inactividad_id") else {

            activo = true
            return
            
        }

        activo = false

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

    func accion_borrar_sesion(){

        globales.removeObject(forKey: "token")
        globales.removeObject(forKey: "id")
        globales.removeObject(forKey: "nombre_usuario")
        globales.removeObject(forKey: "nombre")
        globales.removeObject(forKey: "apellido")
        globales.removeObject(forKey: "sesion_id")
        globales.removeObject(forKey: "lugar_id")
   
        router.path = .init()

    }

    func accion_cerrar_sesion(){

        guard let token = globales.string(forKey: "token") else {

            return
        }

        guard let sesion_id = globales.string(forKey: "sesion_id") else {

            return
        }
        
        guard let url = (URL(string: Globales.url + "/api/valet_parking/cerrar_sesion/\(sesion_id)")) else {
           
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
                    
                    accion_borrar_sesion()
                    
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

    func accion_activar_alerta(){

        print("INICIA ALERTA")

        guard let url = Bundle.main.url(forResource: "panic", withExtension: "mp3") else {
            return
        }

        do {

            player = try AVAudioPlayer(contentsOf: url)

            animar_imagen_alerta = true
            mostrar_alerta = true
            player?.numberOfLoops =  -1
            player?.play()

            print("FINALIZA ALERTA")
            
        } catch let error {
            print(error)
        }
    }

    func accion_desactivar_alerta(){

        player?.pause()
        mostrar_alerta = false
        animar_imagen_alerta = false

    }
}

#Preview {
    PrincipalView()
}
