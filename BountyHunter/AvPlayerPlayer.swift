//
//  File.swift
//  BountyHunter
//
//  Created by Esteban Federico León Mendoza on 18/11/23.
//

import Foundation
import Foundation
import AVKit

class AVPlayerPlayer : AVPlayerViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*guard let laURL = Bundle.main.url(forResource: "homero-el-caza-recompensas", withExtension: "mp4")
                
        else{
            print("ERROR")
            return
        }*/
        if let laURL = URL(string: "http://janzelaznog.com/DDAM/iOS/BountyHunter/the-bounty-hunter.mp4"){
            self.player = AVPlayer(url: laURL)
        }
    }
}
