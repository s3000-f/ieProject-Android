//
//  LoginWebService.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/8/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
import Alamofire
func login(username:String, password: String, completion:@escaping ((SimpleModel)->())){
    let loginModel = SimpleModel()
    let requestUrl = MyUrls.server + MyUrls.login
    print (requestUrl)
    var data = [String:Any]()
    data["email"] = username
    data["password"] = password
    Alamofire.request(requestUrl, method: .post, parameters: data, encoding: JSONEncoding.default).validate().responseJSON { (response) in
        if response.error != nil {
            loginModel.error = true
            loginModel.code = (response.error as? AFError)?.responseCode
            let status = (response.result.value as? [String:Any])?["status"] as? String

            loginModel.errorMsg = (response.error as? AFError)?.errorDescription ?? "Connection Error"

            completion(loginModel)
        }else{
            let responseDic = response.result.value as? [String:Any]
            if let responseDicIn = responseDic {
                let status = responseDicIn["status"] as? String
                if status == "OK" {
                    if !(UserDefaults.standard.bool(forKey: "firstTimeSetting")){
                             UserDefaults.standard.set(true, forKey: "setActionForExcersice")
                             UserDefaults.standard.set(true, forKey: "firstTimeSetting")
                             UserDefaults.standard.synchronize()
                    }
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    let user = responseDicIn["user"] as! [String:Any]
                    UserDefaults.standard.set(user["name"] as! String, forKey: "username")
                    UserDefaults.standard.set(user["access_token"], forKey: "token")
                    loginModel.error = false
                    completion(loginModel)
                } else {
                    loginModel.error = true
                    loginModel.errorMsg = status
                    loginModel.code = -100
                    completion(loginModel)
                }
                
            } else {
                loginModel.error = true
                loginModel.errorMsg = "Parse Error"
                loginModel.code = -100
                completion(loginModel)
            }
            
        }
    }
}
