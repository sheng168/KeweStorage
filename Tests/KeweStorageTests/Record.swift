//
//  Record.swift
//  WristVault2
//
//  Created by Jin Yu on 10/25/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation
import KeweStorage
import KeweStorageKeychain

extension RecordStruct: RowProtocol {
}

let recordMgr = GenericMgrKeychain<RecordStruct>()

public protocol Record: Codable {
    var id:String {get}
    
    var name: String {get set}
//    var password: String {get set}
    
    var created: Date {get set}
    var updated: Date {get set}
}



public struct PrivatePublicKey: Codable, Equatable, CustomStringConvertible {
    var privateKey: String = "pri"
    var publicKey: String = "pub"
    public var description: String {
        return "\(privateKey.count): \(publicKey.count)"
    }
}

public struct NamePassword: Codable, Equatable {
    var name: String
    var password: String
}

public struct AuthEnum: Codable, Equatable {
    public var namePassword: NamePassword?
    public var privateKey: PrivatePublicKey?
    
    public enum Auth {
        case namePassword(NamePassword)
        case privateKey(PrivatePublicKey)
    }
    
    func toEnum() -> Auth? {
        if namePassword != nil {
            return .namePassword(namePassword!)
        }
        if privateKey != nil {
            return .privateKey(privateKey!)
        }
        return nil
    }
}

public struct RecordStruct: Record {
    public init() {}
    public var id: String = UUID().uuidString
    
    //    public var url = "/"
    public var name = "name"
    
//    @available(*, deprecated: 1.0, message: "will soon become unavailable.")
//    public var password: String = UUID().uuidString
    
    public var auth: AuthEnum = AuthEnum(namePassword: nil, privateKey: nil)
    
    public var type: AuthEnum.Auth {
        get {
            return auth.toEnum() ?? .namePassword(NamePassword(name: "", password: ""))
        }
    }

    public var notes: String? = ""
    public var active: Bool? = true
    
    public var created = Date()
    public var updated = Date()
}

extension RecordStruct {
    public init(name: String = "", password: String = "") {
        self.name = name
        self.auth = AuthEnum(namePassword: NamePassword(name: name, password: password), privateKey: nil)
    }
}
