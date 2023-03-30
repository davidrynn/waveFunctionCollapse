//
//  Direction.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/29/23.
//

import Foundation

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
