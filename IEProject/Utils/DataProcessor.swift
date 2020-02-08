//
//  DataProcessor.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
func process(Data data:[String:Any]) -> [FormField] {
    var fields = [FormField]()
    let fData = data["fields"] as! [[String:Any]]
    for f in fData {
        let name = f["name"] as? String
        let title = f["title"] as? String
        let required = f["required"] as? Bool
        let type = FieldType(rawValue: f["type"] as! String)
        let field = FormField(name: name, title: title, type: type, isRequired: required)
        if field.fieldType == .Text {
            if let ops = f["options"] as? [[String:Any]] {
                var options = [FieldOptions]()
                for op in ops {
                    let label = op["label"] as? String
                    let value = op["value"] as? String
                    let option = FieldOptions(label: label, value: value)
                    options.append(option)
                }
                field.fieldType = .DropDown
                field.options = options
            }
        } else if field.fieldType == .Location {
            if let ops = f["options"] as? [[String:Any]] {
                var options = [FieldOptions]()
                for op in ops {
                    let label = op["label"] as? String
                    let value = op["value"] as? [String:Any]
                    let lat = value?["lat"] as? Double
                    let lng = value?["long"] as? Double
                    let option = FieldOptions(label: label, lat: lat, lng: lng)
                    options.append(option)
                }
                field.fieldType = .DropDown
                field.options = options
            }
        }
        fields.append(field)
    }
    return fields
}
