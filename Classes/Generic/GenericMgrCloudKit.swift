//
//  GenericMgrCloudKit.swift
//  WristVault2
//
//  Created by Jin Yu on 11/1/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation
import CloudKit

// https://medium.com/@guilhermerambo/synchronizing-data-with-cloudkit-94c6246a3fda

public class GenericMgrCloudKit<Row: RowProtocol>/*: GenericMgr*/ {

    
    //    private static let Row = "Row"
    let prefix: String
    let ckDatabase = CKContainer.default().publicCloudDatabase
    let codec = JSONCodec()
    
    init() {
        CKContainer.default().accountStatus { status, error in
            if let error = error {
                log.error(error)
                // some error occurred (probably a failed connection, try again)
            } else {
//                switch status {
//                case .available:
//                // the user is logged in
//                case .noAccount:
//                // the user is NOT logged in
//                case .couldNotDetermine:
//                // for some reason, the status could not be determined (try again)
//                case .restricted:
//                    // iCloud settings are restricted by parental controls or a configuration profile
//                }
            }
        }
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                return
            }
            
            log.debug("Got user record ID \(recordID.recordName).")
            
            // `recordID` is the record ID returned from CKContainer.fetchUserRecordID
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }
                
                log.debug("The user record is: \(record)")
            }
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability) { status, error in
                guard status == .granted, error == nil else {
                    // error handling voodoo
                    return
                }
                
                CKContainer.default().discoverUserIdentity(withUserRecordID: recordID) { identity, error in
                    guard let components = identity?.nameComponents, error == nil else {
                        // more error handling magic
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let fullName = PersonNameComponentsFormatter().string(from: components)
                        print("The user's full name is \(fullName)")
                    }
                }
            }
            
            CKContainer.default().discoverAllIdentities { identities, error in
                guard let identities = identities, error == nil else {
                    // awesome error handling
                    return
                }
                
                print("User has \(identities.count) contact(s) using the app:")
                print("\(identities)")
            }
        }
        
        
        let p = String(describing: Row.self)
        log.debug(p)
        prefix = p
//        userDefaults = UserDefaults(suiteName: prefix)!
    }
    
    @objc func test() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(test),
                                               name: Notification.Name.CKAccountChanged,
                                               object: nil)
    }
    
    public func create() -> Row {
        return Row()
    }
    
    public func put(_ r: inout Row) {
        r.updated = Date()
        let data = try! codec.encoder.encode(r)
        let json = String(data: data, encoding: .utf8)!

        let rec = CKRecord(recordType: prefix, recordID: CKRecord.ID(recordName: r.id))
        rec["json"] = json
        
        CKContainer.default().publicCloudDatabase.save(rec) { (CKRecord, error) in
            guard error == nil else {
                // top-notch error handling
                return
            }
            
            print("Successfully updated user record with new avatar")
        }

//        userDefaults.set(json, forKey: prefix + r.id)
    }
    
    public func list() -> [Row] {
        let currentLocation = CLLocation(latitude: 0, longitude: 0)
        let radius = 500
        let _ = NSPredicate(format: "distanceToLocation:fromLocation:(location, %@) < %f", currentLocation, radius)
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: prefix, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        
        var movieRecords: [CKRecord] = []
        
        operation.recordFetchedBlock = { record in
            // record é um registro do tipo Movie que foi obtido na operação
            movieRecords.append(record)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            // movieRecords agora contém todos os registros que foram obtidos nesta operação
            print(movieRecords)
        }
        CKContainer.default().publicCloudDatabase.add(operation)
        
//        let dict = userDefaults.dictionaryRepresentation()
//
//        return dict.filter{ (arg: (key: String, value: Any)) -> Bool in
//            let (key, _) = arg
//            return key.hasPrefix(prefix)
//            }.map { (key: String, value: Any) -> Row in
//                get(id: key.replacingOccurrences(of: prefix, with: ""))!
//        }
        return []
    }
    
    public func get(id: String, completionHandler: @escaping (Row?, Error?) -> Void) {
        ckDatabase.fetch(withRecordID: CKRecord.ID(recordName: id)) { (CKRecord, Error) in
            if let ck = CKRecord {
                let a = ck["ok"]
                log.debug(a as Any)
                completionHandler(Row(), nil) //TODO
            } else {
                completionHandler(nil, Error)
            }
        }
        
        //        let jsonData = jsonString.data(using: .utf8)!
        //        let r = try! codec.decoder.decode(Row.self, from: jsonData)
//        let r = try? codec.fromJson(Row.self, from: jsonString)
//        return r
    }
    
    public func delet(_ r: Row, completionHandler: @escaping (Row, Error?) -> Void) {
        ckDatabase.delete(withRecordID: CKRecord.ID(recordName: r.id)) { (CKRecord, Error) in
            completionHandler(r, Error)
        }
    }
}

private func updateUserRecord(_ userRecord: CKRecord, with avatarURL: URL) {
    userRecord["avatar"] = CKAsset(fileURL: avatarURL)
    
    CKContainer.default().publicCloudDatabase.save(userRecord) { _, error in
        guard error == nil else {
            // top-notch error handling
            return
        }
        
        print("Successfully updated user record with new avatar")
    }
}
