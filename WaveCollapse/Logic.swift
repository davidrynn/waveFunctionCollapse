//
//  Logic.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import Foundation
import SwiftUI

enum Direction: CaseIterable {
    
    case left, right, up, down
    
    func relativeIndex(_ i: Int, columns: Int) -> Int? {
        let roundedRowNumber = (i / columns)
        let beginningOfRow = roundedRowNumber * columns
        let endOfRow = beginningOfRow + columns - 1
        switch self {
        case .down:
            let j = columns + i
            return j < columns*columns ? j : nil
        case .left:
            let j = i - 1
            return j >= beginningOfRow ? j : nil
        case .right:
            let j = i + 1
            return j <= endOfRow ? j : nil
        case .up:
            let j = i - columns
            return j > 0 ? j : nil
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
    
    func getRule(_ direction: Direction) -> [TileType] {
        switch direction {
            
        case .down: return downSide
        case .left: return leftSide
        case .right: return rightSide
        case .up: return upSide
        }
    }
}

final class Logic: ObservableObject {
    var numberOfColumns: Int
    
    private var previous: [GridData] = []
    var canUndo: Bool = false
    
    @Published var grids: [GridData] = []
    
    var images: [Image]
    var numberOfTiles: Int {
        return numberOfColumns * numberOfColumns
    }
    
    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
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
        previous = grids
        canUndo = true
        guard numberOfTiles > 0 else { return [] }
        var data = grids
        if data.count > 24 {
            data[3].options = [TileType.left]
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
    
    private func update(gridDatas: [GridData]) -> [GridData] {
        guard !gridDatas.isEmpty else { return [] }
            var data = gridDatas
            for i in data.indices {
                updateAdjacentTile(data: &data, i: i)
            }
        return data
    }
    
    private func updateAdjacentTile(data: inout [GridData], i: Int) {
        for direction in Direction.allCases {
            if let j = direction.relativeIndex(i, columns: numberOfColumns){
                let dirOptions = data[i].options.map { option in
                    return option.rule.getRule(direction)
                }
                let flat = Set(dirOptions.joined())
                let jSet = Set(data[j].options)
                // if options are the same, no need to update
                if flat == jSet { return }
                
                let newOptions = Array(flat.intersection(jSet))
                data[j].options = newOptions
            }
        }
    }
    
    //takes index and data and get's the correct options
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
// MARK: Public Functions
extension Logic {
    func reload() {
        self.grids = load()
    }
    
    func reset() {
        self.firstLoad()
    }
    
    func undo() {
        canUndo = false
        self.grids = previous
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

