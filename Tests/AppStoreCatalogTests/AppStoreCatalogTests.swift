import Foundation
import Testing
@testable import AppStoreCatalog

@Suite
struct AppStoreCatalogDataParsingTests
{
    @Test func typicalDataWorks() async throws {
        let catalog = try AppStoreCatalog(data: exampleJson)
        
        #expect(catalog.productGroups.count == 2)
        #expect(catalog.productGroups.first!.products.count == 2)
        #expect(catalog.productGroups.last!.products.count == 1)
    }

    // Exclude one of the items from the first group
    @Test func excludingFromFirstGroupWorks() async throws {
        let catalog = try AppStoreCatalog(data: exampleJson, excluding: "301618970")
        
        #expect(catalog.productGroups.count == 2)
        #expect(catalog.productGroups.first!.products.count == 1)
        #expect(catalog.productGroups.last!.products.count == 1)
    }

    // Exclude the only item in the second group
    @Test func excludingFromSecondGroupWorks() async throws {
        let catalog = try AppStoreCatalog(data: exampleJson, excluding: "417317449")
        
        #expect(catalog.productGroups.count == 1)
        #expect(catalog.productGroups.first!.products.count == 2)
    }

    @Test func emptyProductGroupThrows() async throws {
        #expect(throws: AppStoreCatalog.DataError.emptyProductGroups) {
            let _ = try AppStoreCatalog(data: emptyProductGroupJson)
        }
    }

    @Test func emptyProductGroupThroughExclusionThrows() async throws {
        #expect(throws: AppStoreCatalog.DataError.emptyProductGroups) {
            let _ = try AppStoreCatalog(data: singleProductGroupJson, excluding: "825459863")
        }
    }
    
    @Test func badJsonThrows() async throws {
        #expect(throws: Swift.DecodingError.self) {
            let _ = try AppStoreCatalog(data: badJson)
        }
    }

}

let exampleJson = """
{ "productGroups" : [
    {   "title" : "Awesome Games",
        "products" : [
            {
                "name" : "FlippyBit",
                "details" : "Party like it's 1979! Flippy Bit takes the great action of early 2014, and makes it look like it's on an old Atari.",
                "identifier" : "825459863",
                "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
            },
            {
                "name" : "Scribattle",
                "details" : "Put your finger-flicking abilities to the test in this all-but-forgotten 2009 App Store hit game!",
                "identifier" : "301618970",
                "imageURL" : "https://rebisoft.com/appicons/scribattle100.png"
            },
        ]
    },
    {   "title" : "Other Apps",
        "products" : [
            {
                "name" : "Goldy",
                "details" : "Goldy is a web browser for iPhone, iPad, and iPod touch that offers one simple feature: Privacy.",
                "identifier" : "417317449",
                "imageURL" : "https://rebisoft.com/_Media/screen_shot_2011-08-19_at_med.png"
            },
        ]
    },
]}
""".data(using: .utf8)!

let singleProductGroupJson = """
{ "productGroups" : [
    {   "title" : "Awesome Games",
        "products" : [
            {
                "name" : "FlippyBit",
                "details" : "Party like it's 1979! Flippy Bit takes the great action of early 2014, and makes it look like it's on an old Atari.",
                "identifier" : "825459863",
                "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
            },
        ]
    },
]}
""".data(using: .utf8)!

let emptyProductGroupJson = """
{ "productGroups" : [
    {   "title" : "Awesome Games",
        "products" : [
        ]
    },
]}
""".data(using: .utf8)!

let badJson = """
{ "productGroups" : [
    {   "title" : "Awesome Games,
        "products" : [
            {
                "name" : "FlippyBit",
                "details" : "Party like it's 1979! Flippy Bit takes the great action of early 2014, and makes it look like it's on an old Atari.",
                "identifier" : "825459863",
                "imageURL" : "https://rebisoft.com/appicons/flippybit512.png"
            },
        ]
    },
]}
""".data(using: .utf8)!
