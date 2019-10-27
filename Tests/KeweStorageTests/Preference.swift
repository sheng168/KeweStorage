//
//  Preference.swift
//  WristVault2 WatchKit Extension
//
//  Created by Jin Yu on 10/29/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation
import KeweStorage

public struct Preference: RowProtocol {
    public init() {}
    public var id:String = "1"
    public var updated = Date()
    
//    var activeKey = ""
    var alpha: Float = 0.1

    var keyId: String = ""
}

let pref = Singleton<Preference>()
