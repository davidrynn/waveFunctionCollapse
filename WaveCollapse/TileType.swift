//
//  TileType.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/29/23.
//

import Foundation

enum TileType: Int, CaseIterable {
    case blank = 0
    case up = 1
    case right = 2
    case down = 3
    case left = 4
    
    var rule: SideRule<TileType> {
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
