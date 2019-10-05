//
//  Chart.swift
//  Chat
//
//  Created by Tatiana Kornilova on 16/03/2019.
//  Copyright © 2019 BestKora. All rights reserved.
//

import SwiftUI

typealias Chat = [ChartElement]

struct ChartElement: Codable {
    let columns: [[Column]]
    let types, names, colors: Names
}

struct Names: Codable {
    let y0, y1: String
    let y2, y3, x: String?
}

enum Column: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Column.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Column"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// internal Model

struct LinesSet:Equatable,
                Identifiable  {
    var id: Int = 0
    var namex = ""
    var xTime = [String] ()
    var colorX: UIColor?
    var lines = [Line] ()
    var lowerBound: CGFloat = 0.3
    var upperBound: CGFloat = 0.8
    @UnitRange (initialValue:0.3...0.8, 0.05) var range: ClosedRange <CGFloat>
}

struct Line: Equatable, Identifiable  {
    var id: Int = 0
    var title: String?
    var points = [Int]()
    var color: UIColor?
    var isHidden: Bool = false
    var type: String?
    var countY = 0
}
