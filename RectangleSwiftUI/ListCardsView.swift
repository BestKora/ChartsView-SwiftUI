//
//  ListCardsView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 16/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct ListCardsView: View {
    // List
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
        GeometryReader{ geometry in
           List (0..<self.userData.charts.count, id:\.self){ indexChat in
               ChartView(chart: self.userData.charts[indexChat])
                    .environmentObject(UserData())
                    .frame(height: geometry.size.height)
            }// List
            .navigationBarTitle(Text("Folowers"))
        } //Geometry
        }
    }
}

struct ListCardsView_Previews: PreviewProvider {
    static var previews: some View {
        
        ListCardsView()
        .environmentObject(UserData())
        .colorScheme(.dark)
        
    }
}
