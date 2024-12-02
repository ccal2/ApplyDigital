//
//  Utils.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 02/12/24.
//

import Foundation

enum ParsingError: Error {
    case fileNotFound
    case invalidDate
}

func parseJSON<T: Codable>(from fileName: String) throws -> T {
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        throw ParsingError.fileNotFound
    }

    let jsonData = try Data(contentsOf: fileURL)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return try decoder.decode(T.self, from: jsonData)
}
