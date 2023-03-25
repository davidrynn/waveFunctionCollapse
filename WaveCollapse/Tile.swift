//
//  MainGrid.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import SwiftUI

struct Tile: View {
    let data: [GridData]
    var collapsed: Int?
    let columns = [
         GridItem(.flexible()),
         GridItem(.flexible()),
         GridItem(.flexible())
     ]
    var body: some View {
        if let collapsed {
            Image(systemName: data[collapsed].text + ".circle")
                .resizable()
                .frame(width: 50, height: 50)
        }
        LazyVGrid(columns: columns, spacing: 20) {
             ForEach(data) { item in
                 Image(systemName: item.text + ".circle")
             }
         }
         .padding(.horizontal)
//        Grid {
//            ForEach(data) { value in
//                GridRow {
//                    Text(value.text ?? "nil")
//                }
//            }
//        }
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile(data: demoArray, collapsed: 3)
    }
}

struct GridData: Identifiable {
    let id = UUID()
    let number: Int? = nil
    let text: String
    let image: Image? = nil
}

let demoArray = (1...9).map { GridData(text: String($0)) }
