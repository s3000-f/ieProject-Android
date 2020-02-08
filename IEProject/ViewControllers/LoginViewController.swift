//
//  LoginViewController.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/8/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import UIKit
import PopupDialog
class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func submit(_ sender: UIButton) {
        if let u = username.text {
            if u == "" {
                let pop = createDialog(message: "Email Can't be empty")
                self.present(pop, animated: true, completion: nil)
                return
            }
            if let pass = password.text {
                if pass == "" {
                    let pop = createDialog(message: "Password Can't be empty")
                    self.present(pop, animated: true, completion: nil)
                    return
                }
                let load = loading(view: self.view, text: "Please Wait...")
                login(username: u, password: pass) { val in
                    load.hide(animated: true)
                    if val.error ?? true {
                        let pop = createDialog(message: val.errorMsg ?? "Unkonwn Error")
                        self.present(pop, animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: "goToList", sender: self)
                    }
                }
            } else {
                let pop = createDialog(message: "Password Can't be empty!")
                self.present(pop, animated: true, completion: nil)
            }
        } else {
            let pop = createDialog(message: "Email Can't be empty")
            self.present(pop, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
