//
//  ViewController.swift
//  BountyHunter
//
//  Created by Ángel González on 11/11/23.
//

import UIKit

// UIImagePickerControllerDelegate & UINavigationControllerDelegate se requieren para la implementacion del imagePicker
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var fugitive : Fugitive?
    let iv = UIImageView()
    let lblName = UILabel()
    let lblDesc = UILabel()
    let lblBounty = UILabel()
    let apiS = APIService()
    let imagepicker = UIImagePickerController()
    
    func createView() {
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "life")
        self.view.addSubview(iv)
        iv.topAnchor.constraint(equalTo: self.view.topAnchor, constant:150).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 200).isActive = true
        iv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:25).isActive = true
        iv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-25).isActive = true
        let boton1 = Utils.createButton("actualizar foto", color: .lightGray.withAlphaComponent(0.5))
        self.view.addSubview(boton1)
        // configuramos sus constraints
        boton1.translatesAutoresizingMaskIntoConstraints = false
        boton1.widthAnchor.constraint(equalToConstant:150).isActive = true
        boton1.heightAnchor.constraint(equalToConstant:45).isActive = true
        boton1.centerXAnchor.constraint(equalTo:iv.centerXAnchor).isActive = true
        boton1.centerYAnchor.constraint(equalTo:iv.centerYAnchor).isActive = true
        // le asignamos un action para cuando el usuario lo toque
        boton1.addTarget(self, action:#selector(botonTouch), for:.touchUpInside)
        lblName.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo:iv.bottomAnchor, constant:50).isActive = true
        lblName.heightAnchor.constraint(equalToConstant:30).isActive = true
        lblName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:25).isActive = true
        lblName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-25).isActive = true
        
        lblDesc.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblDesc)
        lblDesc.topAnchor.constraint(equalTo:lblName.bottomAnchor, constant:15).isActive = true
        lblDesc.heightAnchor.constraint(equalToConstant:60).isActive = true
        lblDesc.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:25).isActive = true
        lblDesc.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-25).isActive = true
        
        lblBounty.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblBounty)
        lblBounty.topAnchor.constraint(equalTo:lblDesc.bottomAnchor, constant:15).isActive = true
        lblBounty.heightAnchor.constraint(equalToConstant:30).isActive = true
        lblBounty.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:25).isActive = true
        lblBounty.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-25).isActive = true
        let boton2 = Utils.createButton("localizar", color:.orange)
        self.view.addSubview(boton2)
        // configuramos sus constraints
        boton2.translatesAutoresizingMaskIntoConstraints = false
        boton2.widthAnchor.constraint(equalToConstant:150).isActive = true
        boton2.heightAnchor.constraint(equalToConstant:45).isActive = true
        boton2.leadingAnchor.constraint(equalTo:self.view.leadingAnchor).isActive = true
        boton2.topAnchor.constraint(equalTo:lblBounty.bottomAnchor, constant: 15).isActive = true
        // le asignamos un action para cuando el usuario lo toque
        boton2.addTarget(self, action:#selector(botonLocalizarTouch), for:.touchUpInside)
        let boton3 = Utils.createButton("capturar", color:.purple)
        self.view.addSubview(boton3)
        // configuramos sus constraints
        boton3.translatesAutoresizingMaskIntoConstraints = false
        boton3.widthAnchor.constraint(equalToConstant:150).isActive = true
        boton3.heightAnchor.constraint(equalToConstant:45).isActive = true
        boton3.trailingAnchor.constraint(equalTo:self.view.trailingAnchor).isActive = true
        boton3.topAnchor.constraint(equalTo:lblBounty.bottomAnchor, constant: 15).isActive = true
        // le asignamos un action para cuando el usuario lo toque
        boton3.addTarget(self, action:#selector(botonTouch), for:.touchUpInside)
    }
    
    func fillInfo() {
        if fugitive != nil {
            lblName.text = fugitive!.name
            lblDesc.text = fugitive!.desc
            lblBounty.text = "RECOMPENSA: \(fugitive!.bounty)"
            // descargar la foto de <URL>/pics/<FUGITIVE_ID>.jpg
            apiS.getPhoto(fID: fugitive!.fugitiveid) { data in
                if let d = data {
                    self.apiS.savePhoto(d, ofFugitive:self.fugitive!.fugitiveid)
                    DispatchQueue.main.async {
                        let photo = UIImage(data:d)
                        self.iv.image = photo
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker.delegate = self
        // Do any additional setup after loading the view.
        createView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillInfo()
    }
    
    @objc func botonTouch() {
        // si se permite la edición....
        imagepicker.allowsEditing = true
        // imagepicker.sourceType = .photoLibrary
        imagepicker.sourceType = .camera
        self.present(imagepicker, animated: true)
    }
    
    @objc func botonLocalizarTouch() {
        // 1. si usamos storyboard, y conectamos los controllers con un segue
        self.performSegue(withIdentifier: "localizar", sender:nil)
        
        // 2. si usamos storyboard pero no usamos segues, sino que tenemos un identificador para el viewController:
        // hacemos una referencia al Storyboard
        //let sb = UIStoryboard(name: "Main", bundle:nil)
        //let newVC = sb.instantiateViewController(withIdentifier: "localizarVC")
        //self.navigationController?.pushViewController(newVC, animated: true)
        
        // 3. si no usamos storyboard:
        /*  let newVC = ElOtroViewController()
            self.present (newVC)  */
    }
    
    // cuando el usuario elige una foto, la colocamos en lugar de la actual
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // ... si se permitió la edición hay que buscar la foto como editada
        if let imagen = info[.editedImage] as? UIImage {
        // si no se permitió la edición, la imagen está en la llave
        // if let imagen = info[.originalImage] as? UIImage {
            self.iv.image = imagen
            // para guardar la foto a la galería -- LAS FOTOS TOMADAS EN UN APP NO SE GUARDAN AUTOMATICAMENTE
            UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
            apiS.uploadPhoto(photo: imagen, id_fugitive: self.fugitive!.fugitiveid) { dictionary in
                print (dictionary)
            }
        }
        imagepicker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagepicker.dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MapViewController
        destinationVC.fugitive = self.fugitive
    }
}

