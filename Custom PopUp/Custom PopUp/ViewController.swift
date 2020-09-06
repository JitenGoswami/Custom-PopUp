//
//  ViewController.swift
//  Custom PopUp
//
//  Created by Jitengiri Goswami on 06/09/20.
//  Copyright © 2020 Jitengiri Goswami. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ShowPopUpWithoutButton(_ sender: Any) {
        //This will add a alert on top of screen with image, text and will disapper in 2 sec
        topPopUp(strText: "Hello World!!", imgName: "alert.png", duration: 2)
    }
    
    @IBAction func ShowPopUpWithOneButton(_ sender: Any) {
        popUpWithButtons(imgName: "alert.png", btnYesText: "Yes", btnNoText: "No", txtMessage: "This is Hello World?", numOfButtons: 2) { (success) in
            if success{
                // perform anything on success like api call, logout, navigate screen.
                print(success)
            }else{
                // perform anything on failure
                print(success)
            }
        }
    }
    
    @IBAction func ShowPopUpWithTwoButtons(_ sender: Any) {
        popUpWithButtons(imgName: "alert.png", btnYesText: "Ok", btnNoText: "", txtMessage: "Yes, this is Hello World!", numOfButtons: 1) { (success) in
            print(success)
        }
    }
}

