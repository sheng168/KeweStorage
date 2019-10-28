//
//  RowStruct.swift
//  
//
//  Created by Jin.Yu on 10/28/19.
//

import Foundation
import KeweStorage

public struct RowStruct: RowProtocol {
    public init() {}
    public var id:String = UUID().uuidString
    public var updated = Date()
}
