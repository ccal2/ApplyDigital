//
//  ModelContext+insert.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 02/12/24.
//

import SwiftData
import Foundation

extension ModelContext {

    func insertIfNotExisting<T>(_ element: T) where T: PersistentModel, T.ID == String {
        let elementID = element.id

        let elementCount = try? fetchCount(FetchDescriptor<T>(predicate: #Predicate<T> { item in
            item.id == elementID
        }))

        guard elementCount ?? 0 == 0 else {
            return
        }

        insert(element)
    }

    func insertMapping<T, U>(contentsOf elements: [T], mapping: (T) -> U) where U: PersistentModel {
        for element in elements {
            insert(mapping(element))
        }
    }

}
