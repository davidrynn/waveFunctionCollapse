//
//  Logic.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import AVFoundation
import Foundation
import SwiftUI

final class Logic: ObservableObject {
    var numberOfColumns: Int
    var mostOptions = 0
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
        guard numberOfTiles > 0 else { return }
        grids = (0..<numberOfTiles).compactMap({ GridData(id: $0) })
        let random: Int = (0...4).randomElement() ?? 0
        grids[0].options = [TileType(rawValue: random) ?? .left]
        grids = load()
    }
    
    private func load() -> [GridData] {
        previous = grids
        canUndo = true
        guard numberOfTiles > 0 else { return [] }
        var data = grids
        //start off
        updateGrids(data: &data)
        if let least = indexOfCollaspible(data) {
            if let pick = data[least].options.randomElement() {
                data[least].options = [pick]
                updateAdjacentTiles(data: &data, i: least)
                updateGrids(data: &data)
            }
        }
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
    
    private func updateGrids(data: inout [GridData]) {
        guard !data.isEmpty else { return }
            for i in data.indices {
                updateAdjacentTiles(data: &data, i: i)
            }
    }
    
    private func updateAdjacentTiles(data: inout [GridData], i: Int) {
        for direction in Direction.allCases {
            // gets index of either the tile above, below, left or right
            if let j = direction.relativeIndex(i, columns: numberOfColumns){
                // gets option for directional side of current tile
                let dirOptions = data[i].options.map { option in
                    return option.rule.getRule(direction)
                }
                let flat = Set(dirOptions.joined())
                // options of tile comparing to (j tile)
                let jSet = Set(data[j].options)
                // if options are the same or adj is collapsed, no need to update
                if flat == jSet || jSet.count == 1 { continue }
                //otherwise set comparison tiles options to the limited set
                let newOptions = Array(flat.intersection(jSet))
                // count should never be 0
                if newOptions.count > 0 {
                    data[j].options = newOptions
                    if mostOptions <= newOptions.count { mostOptions = newOptions.count }
                }
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
        mostOptions = 0
        self.grids = load()
    }
    
    func reset() {
        mostOptions = 0
        self.firstLoad()
    }
    
    func undo() {
        canUndo = false
        self.grids = previous
    }
    
    @MainActor
    func solve() async {
        while mostOptions > 1 {
            try? await Task.sleep(nanoseconds: 80_000_000)
            self.reload()
        }
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

