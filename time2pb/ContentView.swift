//
//  ContentView.swift
//  time2pb
//
//  Created by 岡野真空 on 2022/10/29.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timeDataHelper=TimeDataHelper.shared
    var body: some View {
        VStack {
            Text("time copied: ")+Text(timeDataHelper.timedata!)
        }
        .frame(width: 150, height: 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
