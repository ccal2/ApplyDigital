//
//  FileNameConstants.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 05/12/24.
//

enum FileNameConstants {

    static let invalidName = "invalid file name"

    enum StoriesSearchResult {
        static let empty = "empty_stories_search_result.json"
        static let valid = "valid_stories_search_result.json"
        static let additionalValid = "additional_valid_stories_search_result.json"
    }

    enum Story {
        static let valid = "valid_story.json"
        static let missingID = "story_missing_ID.json"
    }

}
