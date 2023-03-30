//
//  SideRule.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/29/23.
//

import Foundation

//TODO: Make more generic, potentially just an array, so it could have variable amount of sides
// Is there a way of setting the size of an array
struct SideRule<T: Equatable>: Equatable {
    let upSide: [T]
    let rightSide: [T]
    let downSide: [T]
    let leftSide: [T]
    
    func getRule(_ direction: Direction) -> [T] {
        switch direction {
            
        case .down: return downSide
        case .left: return leftSide
        case .right: return rightSide
        case .up: return upSide
        }
    }
}
