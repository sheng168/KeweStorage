//
//  GenericMgrKeychain.swift
//  WristVault2
//
//  Created by Jin Yu on 10/25/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation
import KeychainAccess
import KeweStorage

public class GenericMgrKeychain<Row: RowProtocol>: GenericMgr {
    //    private static let Row = "Row"
    let prefix: String
    let keychain: Keychain
    let codec = JSONCodec()
    
    public init() {
//        let o: Optional<Int>
        let p = String(describing: Row.self)
//        log.debug("\(p)")
        prefix = p
        keychain = Keychain(service: p).synchronizable(true)
    }
    
    public func create() -> Row {
        return Row()
    }
    
    public func put(_ r: inout Row) {
        r.updated = Date()
        let data = try! codec.encoder.encode(r)
        let json = String(data: data, encoding: .utf8)!
        
        keychain[r.id] = json
    }
    
    public func list() -> [Row] {
        let dict = keychain.allKeys()
        
        return dict.map {
                get(id: $0)
            }.filter {
                $0 != nil
            }.map {
                $0!
            }
    }
    
    public func get(id: String) -> Row? {
        guard let jsonString = keychain[id] else {
            return nil
        }
        
        //        let jsonData = jsonString.data(using: .utf8)!
        //        let r = try! codec.decoder.decode(Row.self, from: jsonData)
        let r = try? codec.fromJson(Row.self, from: jsonString)
        return r
    }
    
    public func delete(_ r: Row){
        keychain[r.id] = nil
    }
}
