//
//  Singleton.swift
//  WristVault2
//
//  Created by Jin Yu on 10/29/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation

/// doc
public class Singleton<T: RowProtocol> {
    let objectMgr = GenericMgrUserDefaults<T>()
    
    public var value: T {
        didSet {
            log.debug("update pref \(value)")
            objectMgr.put(&value)
        }
    }
    
    public init() {
        let ID = "1"
        if let val = objectMgr.get(id: ID) {
            log.debug("loaded pref")
            value = val
        } else {
            log.info("new pref")
            var v = T()
            v.id = ID
            value = v
        }
    }
}
