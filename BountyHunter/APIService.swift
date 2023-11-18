//
//  APIService.swift
//  BountyHunter
//
//  Created by Ángel González on 11/11/23.
//

import Foundation
import UIKit

let BASE_URL: String = "http://janzelaznog.com/DDAM/iOS/BountyHunter"

struct Media {
   let key: String
   let filename: String
   let data: Data
   let mimeType: String
   init?(withImage image: UIImage, forKey key: String) {
       self.key = key
       self.mimeType = "image/jpeg"
       self.filename = "imagefile.jpg"
       guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
       self.data = data
   }
}
struct APIService {
    func getTodos(completionHandler: @escaping (Fugitives?) -> Void) {
        if let url = URL(string:"\(BASE_URL)/fugitives.json") {
            let request = URLRequest(url: url)
            let defaultSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
            let task = defaultSession.dataTask(with: request) { data, response, error in
                if error != nil {
                    print ("ocurrió un error \(String(describing: error))")
                    completionHandler(nil)
                    return
                }
                do {
                    let array = try JSONDecoder().decode(Fugitives.self, from: data!)
                    completionHandler(array)
                }
                catch {
                    print ("ocurrió un error \(String(describing: error))")
                    completionHandler(nil)
                }
            }
            task.resume()
        }
        else {
            completionHandler(nil)
        }
    }
    
    func getPhoto (fID:Int, completionHandler: @escaping (Data?) -> Void) {
        if let url = URL(string:"\(BASE_URL)/pics/\(fID).jpg") {
            print (url)
            var req = URLRequest(url:url)
            req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            let task = URLSession.shared.dataTask(with:req) { data, response, error in
                if error != nil {
                    completionHandler(nil)
                }
                else if let r = response as? HTTPURLResponse,
                    r.statusCode == 404 {
                    completionHandler(nil)
                }
                else {
                    completionHandler (data)
                }
            }
            task.resume()
        }
    }
    // Para trabajar con archivos:
    // 1. RECURSOS: El paquete del app. Accedemos a esos archivos por medio de la clase Bundle. SOLO LECTURA
    // let unArchivo = Bundle.main.url(forResource: "Triestcas2023_Datos del evento  Categoría", withExtension:"pdf")
    // UBICACIONES DE LECTURA Y ESCRITURA se pueden hacer operaciones con archivo, por medio de la clase FileManager y el objeto singleton: default
    // 2. Carpeta de Documentos
    // Se respalda en iCloud si el usuario activa "respaldar datos de aplicaciones". Es pública, o sea que se puede permitir el acceso a los archivos por medio de la computadora, si se pone la llave:
    // Application supports iTunes File Sharing, en YES
    
    // 3. Librería
    // los archivos son privados y solo podrían ser accedidos por la app
    func savePhoto(_ data: Data, ofFugitive: Int) {
        // 1. para guardar informacion generada por mi App, obtenemos la ubicacion de la carpeta donde vamos a escribir, ya sea Documents o Library
        let url = getDocumentsDirectory().appendingPathComponent("\(ofFugitive).jpg")
       // let url2 = getLibraryDirectory().appendingPathComponent("\(ofFugitive).jpg")
        do {
            // para comprobar si un archivo existe
            // if !(FileManager.default.fileExists(atPath:url.path)) {
                // 2. Escribimos los bytes que representan el archivo, con el método write de un objeto Data
                try data.write(to: url)
                print(url.path)
            /*}
            else {
                //FileManager.default.removeItem(at: url)
                try FileManager.default.copyItem(at: url, to: url2)
            }*/
        }
        catch {
            print(error.localizedDescription)
        }
    }
        
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getLibraryDirectory() -> URL {
        let paths = FileManager.default.urls(for: .libraryDirectory, in:.userDomainMask)
        let libraryDirectory = paths[0]
        return libraryDirectory
    }
    
    func uploadPhoto (photo:UIImage, id_fugitive:Int, completionHandler: @escaping ([String: Any]) -> Void ) {
           if let url = URL(string:"\(BASE_URL)/upload_photo.php") {
               let parameters = ["id_fugitive" : "\(id_fugitive)"]
               guard let mediaImage = Media(withImage: photo, forKey: "foto_JPG") else { return }
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               let boundary = generateBoundary()
               request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
               let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
               request.httpBody = dataBody
               let defaultSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
               let dataTask = defaultSession.dataTask(with: request) { (data:Data?, urlResponse:URLResponse?, error:Error?) in
                   var dictionary = [String: Any]()
                   if (error != nil){
                       dictionary = ["code" : 666, "message" : error?.localizedDescription as Any]
                   }
                   else {
                       let httpResponse = urlResponse as? HTTPURLResponse
                       let statusCode = httpResponse?.statusCode ?? 0
                       let resp = String(data: data!, encoding: .utf8) ?? ""
                       if resp.contains("La foto ha sido guardada") {
                           dictionary = ["code" : statusCode, "message" : "success"]
                       }
                       else {
                           dictionary = ["code" : statusCode, "message" : resp as Any]
                       }
                   }
                   completionHandler(dictionary)
               }
               dataTask.resume()
           }
       }

       func createDataBody(withParameters params:[String:Any]?, media: [Media]?, boundary: String) -> Data {
          let lineBreak = "\r\n"
          var body = Data()
          if let parameters = params {
             for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
                body.append("\(value as! String + lineBreak)".data(using: .utf8)!)
             }
          }
          if let media = media {
             for photo in media {
                body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)".data(using: .utf8)!)
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)".data(using: .utf8)!)
                body.append(photo.data)
                body.append(lineBreak.data(using: .utf8)!)
             }
          }
          body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
          return body
       }
       
       func generateBoundary() -> String {
          return "Boundary-\(NSUUID().uuidString)"
       }
    
}

/*
URL:
https://unam.mx/tic/diplomados/calificaciones.xls


file://unam/dev/nuevositio/tic/diplomados/calificaciones.xls


path:
unam.mx/tic/diplomados/calificaciones.xls
*/
