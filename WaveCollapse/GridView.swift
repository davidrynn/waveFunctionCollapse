//
//  GridView.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var logic: Logic
    @State var tapable: Bool = true
    var columns: [GridItem] {
        var array: [GridItem] = []
        for _ in 0..<logic.numberOfColumns {
            array.append(GridItem(.fixed(25.0)))
        }
        return array
    }
    var body: some View {
        VStack {
            Text("largest options: \(logic.mostOptions)")
                .padding()
            Grid(alignment: .center, horizontalSpacing: 1.0, verticalSpacing: 1.0) {
                ForEach(0..<logic.numberOfColumns, id: \.self){ i in
                    GridRow {
                        ForEach(0..<logic.numberOfColumns, id: \.self){ j in
                            let adj = (i * logic.numberOfColumns) + j
                            let grid = logic.grids[adj]

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
                                .onTapGesture {
                                    if tapable {
                                        logic.didTap(index: adj)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            VStack {
                HStack {
                    Button {
                        logic.reload()
                    } label: {
                        Text("Iterate")
                    }
                    .padding()
                    Button {
                        logic.reset()
                    } label: {
                        Text("Reset")
                    }
                    .padding()
                    if logic.canUndo {
                        Button {
                            logic.undo()
                        } label: {
                            Text("Undo")
                        }
                        .padding()
                    }
                }
                Button {
                    Task {
                        await logic.solve()
                    }
                } label: {
                    Text("Solve")
                }

            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView().environmentObject(Logic(numberOfColumns: 3))
    }
}
