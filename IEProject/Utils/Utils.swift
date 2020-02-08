//
//  Utils.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
import MBProgressHUD
import PopupDialog
func loading(view : UIView , text : String) -> MBProgressHUD
{
    let activity =  MBProgressHUD.showAdded(to: view, animated: true)
    activity.label.text = text
    return activity
}

func createDialog(message: String) -> PopupDialog {
    let popup = PopupDialog(title: "Attention", message: message) //, image: image)
    popup.buttonAlignment = .horizontal
    popup.transitionStyle = .fadeIn
    
    // Create buttons
    let buttonOne = DefaultButton(title: "OK", dismissOnTap: true) {}
        popup.addButtons([buttonOne])

    return popup
}
