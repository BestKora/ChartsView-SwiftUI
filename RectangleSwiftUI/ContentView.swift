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
    @State var selected: Int = 1
    var body: some View {
        TabView (selection: $selected) {
         ListChartsView ()
            .environmentObject(UserData())
            .tabItem {
                Image(systemName:"rectangle.grid.1x2")
                .font(Font.title.weight(.bold))
                Text("List")
            }.tag(0)
            
        HStackChartsView ()
            .environmentObject(UserData())
            .tabItem {
                Image(systemName:"rectangle.split.3x1")
                .font(Font.title.weight(.bold))
                Text("HStack")
            }.tag(1)
         OverlayCardsView ()
            .environmentObject(UserData())
            .padding()
            .tabItem {
                Image(systemName: "rectangle.stack")
                .font(Font.title.weight(.bold))
                Text("Overlay")
            }.tag(2)
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .edgesIgnoringSafeArea(.top)
            .environmentObject(UserData())
            .colorScheme(.dark)
    }
}
