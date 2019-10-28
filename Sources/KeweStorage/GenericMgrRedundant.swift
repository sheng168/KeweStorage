//
//  RowMgrRedundant.swift
//  
//
//  Created by Jin.Yu on 10/28/19.
//

import Foundation

public struct GenericMgrRedundant<T: RowProtocol>: GenericMgr {
    let RowMgrs: [GenericMgrRedundant<T>]

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
