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

        @Test("Parse non-existing file should throw error")
        func nonExistingFile_throwsError() throws {
            #expect(throws: ParsingError.fileNotFound) {
                let _: StoryDTO = try parseJSON(from: "invalid file name", bundle: Bundle(for: type(of: self)))
            }
        }

        @Test("Parse non-decodable data should throw error")
        func nonDecodableData_throwsError() throws {
            #expect(throws: DecodingError.self) {
                let _: StoryDTO = try parseJSON(from: "story_missing_ID.json", bundle: Bundle(for: type(of: self)))
            }
        }

        @Test("Parse valid data should succeed")
        func validData_succeeds() throws {
            #expect(throws: Never.self) {
                let _: StoryDTO = try parseJSON(from: "valid_story.json", bundle: Bundle(for: type(of: self)))
            }
        }

    }

}
