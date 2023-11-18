//
//  VideoPlayer.swift
//  BountyHunter
//
//  Created by Esteban Federico León Mendoza on 18/11/23.
//

import UIKit
import AVFoundation

class VideoPlayer: UIViewController {

    var audioPlayer:AVAudioPlayer?
       var timer:Timer?
       
       let btnPlay=UIButton(type: .system)
       let btnStop=UIButton(type: .system)
    
       
       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           let l1=UILabel()
           l1.text="AudioPlayer"
           l1.font=UIFont.systemFont(ofSize: 24)
           l1.autoresizingMask = .flexibleWidth
           l1.translatesAutoresizingMaskIntoConstraints=true
           l1.frame=CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50)
           l1.textAlignment = .center
           self.view.addSubview(l1)
                   
           btnPlay.setTitle("Log Out", for: .normal)
           btnPlay.autoresizingMask = .flexibleWidth
           btnPlay.translatesAutoresizingMaskIntoConstraints=true
           btnPlay.frame=CGRect(x: 150, y: 700, width: 100, height: 40)
                   self.view.addSubview(btnPlay)
           btnPlay.addTarget(self, action:#selector(btnPlayTouch), for: .touchUpInside)
           
           
           let l2=UILabel()
           l2.text="Video "
           l2.autoresizingMask = .flexibleWidth
           l2.translatesAutoresizingMaskIntoConstraints=true
                   l2.frame=CGRect(x: 20, y: 200, width: 100, height: 40)
           view.addSubview(l2)

           
           /*self.view.addSubview(ytView)
           ytView.translatesAutoresizingMaskIntoConstraints = false
           ytView.topAnchor.constraint(equalTo: l2.bottomAnchor, constant: 200).isActive = true
           ytView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
           ytView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
           ytView.heightAnchor.constraint(equalToConstant:320).isActive = true*/
           
           let avpp = AVPlayerPlayer()
           
           self.view.addSubview(avpp.view)
           //1.agregamos la vista del controller hijo a la jerarquia de objetos del padre
           avpp.view.translatesAutoresizingMaskIntoConstraints = false
           avpp.view.topAnchor.constraint(equalTo: l2.bottomAnchor, constant: 100).isActive = true
           avpp.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
           avpp.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
           avpp.view.heightAnchor.constraint(equalToConstant:320).isActive = true
           //2.agregamos el controller hijo, a la logica de control del padre
           self.addChild(avpp)
       
       }
           
       @objc func btnPlayTouch() {
           //TODO: Conectar con el objeto boton "play" para iniciar la reproducción
           audioPlayer?.play()
       }
       
       @objc func btnStopTouch() {
           //TODO: Conectar con el objeto boton "stop" para detener la reproducción
           audioPlayer?.stop()
       }
       
   
       
   
}
