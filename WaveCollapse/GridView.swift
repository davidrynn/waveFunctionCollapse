//
//  GridView.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var logic: Logic
    var columns: [GridItem] {
        var array: [GridItem] = []
        for _ in 0..<logic.numberOfColumns {
            array.append(GridItem(.flexible()))
        }
        return array
    }
    var body: some View {
        VStack {
            Grid {
                ForEach(0..<logic.numberOfColumns, id: \.self){ i in
                    GridRow {
                        ForEach(0..<logic.numberOfColumns, id: \.self){ j in
                            let adj = (i * logic.numberOfColumns) + j
                            let grid = logic.grids[adj]
                            if adj == 3 {
                                
                            }
                            if let index = grid.options.first, grid.collapsed {
                                logic.images[index.rawValue]
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            } else {
                                ZStack {
                                    logic.images[0]
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text(String(grid.options.count))
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            Button {
                logic.reload()
            } label: {
                Text("Reset")
            }

        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView().environmentObject(Logic(numberOfTiles: 3))
    }
}
