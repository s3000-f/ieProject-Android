//
//  FirstViewController.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/8/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.bool(forKey: "isLoggedIn")){
            DispatchQueue.main.async(){
               self.performSegue(withIdentifier: "goList", sender: self)
            }
            print("here")

        } else {
            print("here2")
            DispatchQueue.main.async(){
               self.performSegue(withIdentifier: "goLogin", sender: self)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
