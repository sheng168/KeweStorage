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

public struct RowMgrRedundant<T: RowProtocol>: GenericMgr {
    let RowMgrs: [RowMgrRedundant<T>]

    public func create() -> T {
        let list = RowMgrs.map { (RowMgr) -> T in
            RowMgr.create()
        }

        return list.randomElement()!
    }

    public func put(_ r: inout T) {
        RowMgrs.forEach { (RowMgr) in
            RowMgr.put(&r)
        }
    }

    public func list() -> [T] {
        let list = RowMgrs.map { (RowMgr) -> [T] in
            RowMgr.list()
        }

        return list.randomElement()!
    }

    public func get(id: String) -> T? {
        let list = RowMgrs.map { (RowMgr) -> T? in
            RowMgr.get(id: id)
        }

        return list.randomElement()!
    }

    public func delete(_ r: T){
        RowMgrs.forEach { (RowMgr) in
            RowMgr.delete(r)
        }
    }
}

//let RowMgr =
//    RowMgrRedundant<Row>(RowMgrs: [
//        //        RowMgrRealm(),
//        //        RowMgrUserDefaults(),
//        //        RowMgrKeychain(),
//        ])
