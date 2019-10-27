//
//  GenericMgrUserDefaults.swift
//  WristVault2
//
//  Created by Jin Yu on 10/25/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation

public class GenericMgrUserDefaults<Row: RowProtocol>: GenericMgr {
    //    private static let Row = "Row"
    let prefix: String
    let userDefaults: UserDefaults
    let codec = JSONCodec()
    
    public init() {
        let p = String(describing: Row.self)
        log.debug("\(p)")
        prefix = p
        userDefaults = UserDefaults(suiteName: prefix)!
    }
    
    public func create() -> Row {
        return Row()
    }
    
    public func put(_ r: inout Row) {
        r.updated = Date()
        let data = try! codec.encoder.encode(r)
        let json = String(data: data, encoding: .utf8)!
        
        userDefaults.set(json, forKey: prefix + r.id)
    }
    
    public func list() -> [Row] {
        let dict = userDefaults.dictionaryRepresentation()
        
        return dict.filter{ (arg: (key: String, value: Any)) -> Bool in
            let (key, _) = arg
            return key.hasPrefix(prefix)
            }.map { (key: String, value: Any) -> Row in
                get(id: key.replacingOccurrences(of: prefix, with: ""))!
        }
    }
    
    public func get(id: String) -> Row? {
        guard let jsonString = userDefaults.string(forKey: prefix + id) else {
            return nil
        }
        
        //        let jsonData = jsonString.data(using: .utf8)!
        //        let r = try! codec.decoder.decode(Row.self, from: jsonData)
        let r = try? codec.fromJson(Row.self, from: jsonString)
        return r
    }
    
    public func delete(_ r: Row){
        userDefaults.removeObject(forKey: prefix + r.id)
    }
}
