//
//  Form.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
class Form {
    var name:String?
    var id:String?
    var fields:[FormField]?
    init(name:String?, id:String?) {
        self.name = name
        self.id = id
    }
}
