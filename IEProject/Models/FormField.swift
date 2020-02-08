//
//  FormField.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
class FormField {
    var name:String?
    var title:String?
    var fieldType:FieldType?
    var options:[FieldOptions]?
    var isRequired:Bool?
    init(name:String?, title:String?, type:FieldType?, isRequired:Bool?) {
        self.name = name
        self.title = title
        self.fieldType = type
        self.isRequired = isRequired
    }
}
enum FieldType: String {
    case Text = "Text"
    case DropDown = "DropDown"
    case Location = "Location"
    case Number = "Number"
    case Date = "Date"
}
