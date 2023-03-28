//
//  ContentView.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import SwiftUI

struct ContentView: View {
    @State var numberOfColumns: String = "5"
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Enter number of columns: ")
                TextField("Grid Width", text: $numberOfColumns)
                    .fixedSize()
                    .keyboardType(.numberPad)
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
                .environmentObject(Logic(numberOfColumns: number))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
