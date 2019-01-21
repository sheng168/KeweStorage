//
//  JSONCodec.swift
//  WristVault2
//
//  Created by Jin Yu on 10/20/18.
//  Copyright © 2018 Jin Yu. All rights reserved.
//

import Foundation

public class JSONCodec {
    public let encoder = JSONEncoder()
    public let decoder = JSONDecoder()
    
    public init() {
//        encoder.outputFormatting = .prettyPrinted
        
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        
        //        encoder.dataEncodingStrategy = .base64
        //        decoder.dataDecodingStrategy = .base64
        
        //        encoder.keyEncodingStrategy = .convertToSnakeCase
        //        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        //        encoder.nonConformingFloatEncodingStrategy = .convertToString(  positiveInfinity: "+", negativeInfinity: "-", nan: "NaN")
        //        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+", negativeInfinity: "-", nan: "NaN")
    }
    
    func toJson<T>(_ value: T) throws -> String where T : Encodable {
        let data = try encoder.encode(value)
        let json = String(data: data, encoding: .utf8)!
        return json
    }
    
    func fromJson<T>(_ type: T.Type, from jsonString: String) throws -> T where T : Decodable {
        let jsonData = jsonString.data(using: .utf8)!
        let value = try decoder.decode(type.self, from: jsonData)
        return value
    }
}

