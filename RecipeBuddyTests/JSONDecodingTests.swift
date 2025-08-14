//
//  JSONDecodingTests.swift
//  RecipeBuddyTests
//
//  Created by Orenda M1 on 14/08/25.
//

import XCTest
@testable import RecipeBuddy

final class JSONDecodingTests: XCTestCase {
    func testDecodeMinimalRecipe() throws {
        let json = """
        [
          {
            "id":"r1","title":"T","tags":["quick"],"minutes":5,
            "image":"https://example.com/1.png",
            "ingredients":[{"name":"Salt","quantity":"1 tsp"}],
            "steps":["Do it"]
          }
        ]
        """.data(using: .utf8)!

        let recipes = try JSONDecoder().decode([Recipe].self, from: json)
        XCTAssertEqual(recipes.count, 1)
        let r = try XCTUnwrap(recipes.first)
        XCTAssertEqual(r.id, "r1")
        XCTAssertEqual(r.minutes, 5)
        XCTAssertEqual(r.image?.absoluteString, "https://example.com/1.png")
        XCTAssertEqual(r.ingredients.first?.name, "Salt")
    }

    func testDecodeInvalidJSONFails() {
        let bad = Data("not json".utf8)
        XCTAssertThrowsError(try JSONDecoder().decode([Recipe].self, from: bad))
    }
}
