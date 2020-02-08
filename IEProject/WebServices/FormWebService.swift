//
//  FormWebService.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
import Alamofire
func getFormList(completion:@escaping ((FormsModel)->())) {
    guard let token = UserDefaults.standard.string(forKey: "token")
        else {
            return
    }
    let loginModel = FormsModel()
    let requestUrl = MyUrls.server + MyUrls.forms
    print (requestUrl)
    let headers: HTTPHeaders = [
      "x-access-token": token,
    ]
    Alamofire.request(requestUrl, method: .get,headers: headers).validate().responseJSON { (response) in
        if response.error != nil {
            loginModel.error = true
            loginModel.code = (response.error as? AFError)?.responseCode
            loginModel.errorMsg = "Connection Error"
            completion(loginModel)
        } else {
            let responseDic = response.result.value as? [String:Any]
            if let responseDicIn = responseDic {
                loginModel.error = false
                if let results = responseDicIn["forms"] as? [[String: Any]] {
                    var forms = [Form]()
                    for result in results {
                        let id = result["_id"] as? String
                        let title = result["title"] as? String
                        let form = Form(name: title, id: id)
                        forms.append(form)
                    }
                    loginModel.forms = forms
                    completion(loginModel)
                } else {
                    loginModel.error = true
                    loginModel.errorMsg = "Parse Error"
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

func getForm(id:String, completion:@escaping ((FieldsModel)->())) {
    guard let token = UserDefaults.standard.string(forKey: "token")
        else {
            return
    }
    let loginModel = FieldsModel()
    let requestUrl = MyUrls.server + MyUrls.forms + "/\(id)"
    print (requestUrl)
    let headers: HTTPHeaders = [
      "x-access-token": token,
    ]
    Alamofire.request(requestUrl, method: .get, headers: headers).validate().responseJSON { (response) in
        if response.error != nil {
            loginModel.error = true
            loginModel.code = (response.error as? AFError)?.responseCode
            loginModel.errorMsg = "Connection Error"
            completion(loginModel)
        } else {
            let responseDic = response.result.value as? [String:Any]
            if let responseDicIn = responseDic {
                loginModel.error = false
                let fields = process(Data: responseDicIn)
                loginModel.fields = fields
                completion(loginModel)
            } else {
                loginModel.error = true
                loginModel.errorMsg = "Parse Error"
                loginModel.code = -100
                completion(loginModel)
            }
        }
    }
}

func submitForm(form:Form, datas:[String?], completion:@escaping ((SimpleModel)->())){
    guard let token = UserDefaults.standard.string(forKey: "token")
        else {
            return
    }
    let username = UserDefaults.standard.string(forKey: "username")
    let loginModel = SimpleModel()
    let requestUrl = MyUrls.server + MyUrls.forms + "/\(form.id!)"
    print (requestUrl)
    var data = [String:Any]()
    var fields = [[String:Any]]()
    for i in 0..<(form.fields?.count ?? 0) {
        var dat = [String:Any]()
        let field = form.fields![i]
        if datas[i] != nil && datas[i] != ""  {
            dat["Value"] = datas[i]
            dat["Type"] = "\(field.fieldType!)"
            dat["Name"] = field.name
            dat["Title"] = field.title
            fields.append(dat)
        }
    }
    data["username"] = username ?? "IOS"
    data["fields"] = fields
    let headers: HTTPHeaders = [
      "x-access-token": token,
    ]
    Alamofire.request(requestUrl, method: .post, parameters: data,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
        if response.error != nil {
            loginModel.error = true
            loginModel.code = (response.error as? AFError)?.responseCode
            loginModel.errorMsg = "Connection Error"
            completion(loginModel)
        }else{
            loginModel.error = false
            completion(loginModel)
        }
    }
}
