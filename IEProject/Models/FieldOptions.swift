//
//  FieldOptions.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import Foundation
class FieldOptions {
    var label:String?
    var textValue:String?
    var lat:Double?
    var lng:Double?
    init(label:String?, value:String?) {
        self.label = label
        self.textValue = value
    }
    init(label:String?, lat:Double?, lng:Double?) {
        self.label = label
        self.lat = lat
        self.lng = lng
    }
}
