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
    
    public var singlton: T {
        didSet {
            log.debug("update pref \(singlton)")
            objectMgr.put(&singlton)
        }
    }
    
    public init() {
        let ID = "1"
        if let val = objectMgr.get(id: ID) {
            log.debug("loaded pref")
            singlton = val
        } else {
            log.info("new pref")
            var v = T()
            v.id = ID
            singlton = v
        }
    }
}
