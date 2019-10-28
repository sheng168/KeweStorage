//
//  GenericMgr.swift
//  WristVault2
//
//  Created by Jin Yu on 10/19/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation

public protocol RowProtocol: Codable {
    init()
    var id:String {get set}

//    var created: Date {get set}
    var updated: Date {get set}
}

public struct RowStruct: RowProtocol {
    public init() {}
    public var id:String = UUID().uuidString
    public var updated = Date()
}

public protocol GenericMgr {
    associatedtype Row: RowProtocol
    
    func create() -> Row
    func put(_ r: inout Row)
    func list() -> [Row]
    func get(id: String) -> Row?
    func delete(_ r: Row)
}

