//
//  InternetMonitor.swift
//  BountyHunter
//
//  Created by Ángel González on 11/11/23.
//

import Foundation
import Network

class InternetMonitor {
    var internetStatus = false
    var internetType = ""
    
    static let shared = InternetMonitor()
    // declaramos el constructor como init para que no se pueda instanciar la clase desde fuera de ella misma SINGLETON
    private init(){
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.internetStatus = true
                if path.usesInterfaceType(.wifi) {
                    self.internetType = "WiFi"
                }
                else {
                    self.internetType = "no WiFi"
                }
            }
            else {
                self.internetStatus = false
            }
        }
    }
}
