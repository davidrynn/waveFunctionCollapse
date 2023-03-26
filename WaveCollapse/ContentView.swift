//
//  ContentView.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import SwiftUI

struct ContentView: View {
    @State var numberOfColumns: String = "0"
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Enter number of data points:")
                TextField("Grid Width", text: $numberOfColumns)
                    .fixedSize()
                NavigationLink("Grid") {
                    navLink
                }
            }
            
        }
    }
    
    @ViewBuilder
    var navLink: some View {
        if let number = Int(numberOfColumns) {
            GridView()
                .environmentObject(Logic(numberOfTiles: number))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
