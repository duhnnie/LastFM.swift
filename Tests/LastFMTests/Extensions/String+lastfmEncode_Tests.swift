//
//  File.swift
//  
//
//  Created by Daniel on 2/11/26.
//

import XCTest
@testable import LastFM

class StringLastfmEncodeTests: XCTestCase {
    
    typealias StringEncodingTestCase = (input: String, output: String)
    
    internal static let escapeNonASCIITrueTests: [StringEncodingTestCase] = [
        ("+44", "%252B44"),
        ("ak+q", "ak%252Bq"),
        ("AC/DC", "AC%2FDC"),
        ("Florence + the Machine", "Florence+%252B+the+Machine"),
        ("What?", "What%3F"),
        ("Café Tacvba", "Caf%C3%A9+Tacvba"),
        ("Destiny's Child", "Destiny%27s+Child"),
        ("Beyoncé", "Beyonc%C3%A9"),
        ("Mötley Crüe", "M%C3%B6tley+Cr%C3%BCe"),
        ("+44", "%252B44"),
        ("P!nk", "P!nk"),
        ("Sunn O)))", "Sunn+O)))"),
        ("SMITH & WESSON", "SMITH+&+WESSON"),
        ("Guns N' Roses", "Guns+N%27+Roses"),
        ("Sigur Rós", "Sigur+R%C3%B3s"),
        ("Ke$ha", "Ke$ha"),
        ("100% Pure", "100%25+Pure"),
        ("@", "@"),
        ("D.J. Jazzy Jeff", "D.J.+Jazzy+Jeff"),
        ("Mr. Big", "Mr.+Big"),
        ("S.O.S. Band", "S.O.S.+Band"),
        ("..", "%252E."),
        ("...", "..."),
        (".hidden", ".hidden")
    ]
    
    internal static let escapeNonASCIIFalseTests: [StringEncodingTestCase] = [
        ("+44", "%252B44"),
        ("ak+q", "ak%252Bq"),
        ("AC/DC", "AC%2FDC"),
        ("Florence + the Machine", "Florence+%252B+the+Machine"),
        ("What?", "What%3F"),
        ("Café Tacvba", "Café+Tacvba"),
        ("Destiny's Child", "Destiny%27s+Child"),
        ("Beyoncé", "Beyoncé"),
        ("Mötley Crüe", "Mötley+Crüe"),
        ("+44", "%252B44"),
        ("P!nk", "P!nk"),
        ("Sunn O)))", "Sunn+O)))"),
        ("SMITH & WESSON", "SMITH+&+WESSON"),
        ("Guns N' Roses", "Guns+N%27+Roses"),
        ("Sigur Rós", "Sigur+Rós"),
        ("Ke$ha", "Ke$ha"),
        ("100% Pure", "100%25+Pure"),
        ("@", "@"),
        ("D.J. Jazzy Jeff", "D.J.+Jazzy+Jeff"),
        ("Mr. Big", "Mr.+Big"),
        ("S.O.S. Band", "S.O.S.+Band"),
        ("..", "%252E."),
        ("...", "..."),
        (".hidden", ".hidden")
    ]
    
    func test_escapeNonASCII_true() throws {
        for (input, output) in Self.escapeNonASCIITrueTests {
            XCTAssertEqual(input.lastfmEncode(escapeNonASCII: true), output)
        }
    }
    
    func test_escapeNonASCII_false() throws {
        for (input, output) in Self.escapeNonASCIIFalseTests {
            XCTAssertEqual(input.lastfmEncode(escapeNonASCII: false), output)
        }
    }
    
    func test_empty() throws {
        XCTAssertEqual("      ".lastfmEncode(), "")
    }
    
}
