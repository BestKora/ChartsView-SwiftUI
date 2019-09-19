//
//  ContentView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 14/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        TabView  {
         ListChartsView ()
            .tabItem {
                Image(systemName:"rectangle.grid.1x2")
                Text("List")
            }.tag(0)
            
        HStackChartsView ()
            .tabItem {
                Image(systemName:"rectangle.split.3x1")
                Text("HStack")
            }.tag(1)
         OverlayCardsView ()
            .tabItem {
                Image(systemName: "rectangle.stack")
                Text("Overlay")
            }.tag(2)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
            .colorScheme(.dark)
    }
}
#endif
