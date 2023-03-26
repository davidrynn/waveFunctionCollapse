//
//  Logic.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import Foundation
import SwiftUI

enum Direction {
    case left, right, up, down
    
    func index(_ i: Int, columns: Int) -> Int {
        switch self {
        case .down: return i - columns
        case .left: return i - 1
        case .right: return i + 1
        case .up: return columns + i
        }
    }
}

enum TileType: Int, CaseIterable {
    case blank = 0
    case up = 1
    case right = 2
    case down = 3
    case left = 4
    
    var rule: SideRule {
        switch self {
            
        case .blank:
            return SideRule(upSide: [.blank, .up],
                            rightSide: [.blank, .right],
                            downSide: [.blank, .down],
                            leftSide: [.blank, .left])
        case .up:
            return SideRule(upSide: [.right, .down, .left],
                            rightSide:    [.up, .down, .left],
                            downSide: [.blank, .down],
                            leftSide: [.up, .right, .down]
            )
        case .right:
            return SideRule(upSide: [.right, .down, .left],
                            rightSide: [.up, .down, .left],
                            downSide: [.up, .right, .left],
                            leftSide: [.blank, .left]
            )
        case .down:
            return SideRule(upSide: [.blank, .up],
                            rightSide: [.up, .down, .left],
                            downSide: [.up, .right, .left],
                            leftSide: [.up, .right, .down]
            )
        case .left:
            return SideRule(upSide: [.right, .down, .left],
                            rightSide: [.blank, .right],
                            downSide: [.up, .right, .left],
                            leftSide: [.up, .right, .down]
            )
        }
    }
}
    
    // TileMiddle: tile up from, TileUpFrom.options = TileMiddle.upSide
    
struct SideRule: Equatable {
    let upSide: [TileType]
    let rightSide: [TileType]
    let downSide: [TileType]
    let leftSide: [TileType]
}

final class Logic: ObservableObject {
    var numberOfColumns: Int {
        return Int(sqrt(Double(grids.count)).rounded(.towardZero))
    }
    
    
    @Published var grids: [GridData] = []
    
    var images: [Image]
    var numberOfTiles: Int
    
    init(numberOfTiles: Int) {
        self.numberOfTiles = numberOfTiles
        self.images = [
            Image("blank"),
            Image("up"),
            Image("right"),
            Image("down"),
            Image("left")
        ]
        self.firstLoad()
    }
    
    private func firstLoad() {
        grids = (0..<numberOfTiles).compactMap({ GridData(id: $0) })
        grids = load()
    }
    
    private func load() -> [GridData] {
        guard numberOfTiles > 0 else { return [] }
        var data = grids
        if data.count > 24 {
            data[3].options = [TileType.left]
            data[20].options = [TileType.right]
        }
        //
        
        if let least = indexOfCollaspible(data) {
            if let pick = data[least].options.randomElement() {
                data[least].options = [pick]
            }
        }
        data = update(gridDatas: data)
        return data
    }
    private func indexOfCollaspible(_ data: [GridData]) -> Int? {
        var shortestIds = data.filter { $0.options.count == 2}.map { $0.id }
        if shortestIds.isEmpty {
            shortestIds = data.filter { $0.options.count == 3}.map { $0.id }
        }
        
        let randomId = shortestIds.randomElement()
        return randomId
    }
    
    func reload() {
        self.grids = load()
    }
    
    func update(gridDatas: [GridData]) -> [GridData] {
        guard !gridDatas.isEmpty else { return [] }
            var data = gridDatas
            for i in data.indices {
                let grid = data[i]
                //check up
                let up = i - numberOfColumns
                if up > 0 {
                    let upOptions = grid.options.map { option in
                        return option.rule.upSide
                    }
                    var flat = Array(upOptions.joined())
                    data[up].options = Array(Set(flat).intersection(Set(data[up].options)))
                    
                }
                //down
                let down = i + numberOfColumns
                if down < data.count {
                    let downOptions = grid.options.map { option in
                        return option.rule.downSide
                    }
                    var flat = Array(downOptions.joined())
                    data[down].options = Array(Set(flat).intersection(Set(data[down].options)))
                }
                // right
                let right = i + 1
                let roundedRowNumber = (i / numberOfColumns)
                let beginningOfRow = roundedRowNumber * numberOfColumns
                let endOfRow = beginningOfRow + numberOfColumns - 1
                if right <= endOfRow {
                    let rightOptions = grid.options.map { option in
                        return option.rule.rightSide
                    }
                    var flat = Array(rightOptions.joined())
                    data[right].options = Array(Set(flat).intersection(Set(data[right].options)))
                }
                // left
                let left = i - 1
                if left >= beginningOfRow {
                    let flat = getOptions(grid.options, direction: .left)
                    data[left].options = Array(Set(flat).intersection(Set(data[left].options)))
                }
                if i == 3 || i == 9 {
                    
                }
            }
        return data
    }
    
    //takes index and data and get's the right options
    
    private func getOptions(_ options: [TileType], direction: Direction) -> [TileType] {
        
        let directionOptions = options.map { option in
            switch direction {
            case .left:
                return option.rule.leftSide
            case .right:
                return option.rule.rightSide
            case .up:
                return option.rule.upSide
            case .down:
                return option.rule.downSide
            }
        }
        return Array(directionOptions.joined())
    }
    
    
}

struct GridData {
    var id: Int
    var collapsed: Bool {
        options.count == 1
    }
    var options = [TileType.blank, TileType.up, TileType.right, TileType.down, TileType.left]
}
var demoData = (0...4).compactMap({ GridData(id: $0) })

