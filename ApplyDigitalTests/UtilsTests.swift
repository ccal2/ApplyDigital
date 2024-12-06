//
//  UtilsTests.swift
//  ApplyDigitalTests
//
//  Created by Carolina Lopes on 04/12/24.
//

import Foundation
import Testing
@testable import ApplyDigital

@Suite class UtilsTests {

    @Suite class ParseJSON {

        lazy var bundle = Bundle(for: type(of: self))

        @Test("Parse non-existing file should throw error")
        func nonExistingFile_throwsError() throws {
            #expect(throws: ParsingError.fileNotFound) {
                let _: StoryDTO = try parseJSON(from: FileNameConstants.invalidName,
                                                bundle: bundle)
            }
        }

        @Test("Parse non-decodable data should throw error")
        func nonDecodableData_throwsError() throws {
            #expect(throws: DecodingError.self) {
                let _: StoryDTO = try parseJSON(from: FileNameConstants.Story.missingID,
                                                bundle: bundle)
            }
        }

        @Test("Parse valid data should succeed")
        func validData_succeeds() throws {
            #expect(throws: Never.self) {
                let _: StoryDTO = try parseJSON(from: FileNameConstants.Story.valid,
                                                bundle: bundle)
            }
        }

    }

}
