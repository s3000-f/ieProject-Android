//
//  SimpleModel.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
class SimpleModel {
    private var _code: Int?
    var code:Int?{
        get {return _code}
        set(new){_code = new}
    }
    private var _error:Bool?
    var error:Bool?{
        get {return _error}
        set(new){_error = new}
    }
    private var _errorMsg:String?
    var errorMsg:String?{
        get {return _errorMsg}
        set(new){_errorMsg = new}
    }
}
