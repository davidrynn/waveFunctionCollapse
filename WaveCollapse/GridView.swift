//
//  GridView.swift
//  WaveCollapse
//
//  Created by David Rynn on 3/25/23.
//

import SwiftUI

struct GridView: View {
    let columns = [
         GridItem(.flexible()),
         GridItem(.flexible()),
         GridItem(.flexible())
     ]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(1...9, id: \.self){ _ in
                 Tile(data: demoArray)
             }
         }
         .padding(.horizontal)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
