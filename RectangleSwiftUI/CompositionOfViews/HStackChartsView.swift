//
//  HStackChartsView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 19/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct HStackChartsView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
       NavigationView {
        GeometryReader { geo in
           ScrollView (.horizontal, showsIndicators: false){
               HStack (spacing: 50) {
                ForEach(0..<self.userData.charts.count){ indexChat in
                       GeometryReader { geometry in
                          ChartView(chart: self.userData.charts[indexChat])
                           .rotation3DEffect(Angle(degrees: Double(
                                    (geometry.frame(in:.global).minX - 16)  / 10 )), axis: (x: 0.0, y: 10.0, z: 0.0))
                        } //geometry
                        .frame (width: geo.size.width*0.9, height: geo.size.height*0.95)
                   } //Each
               } //HStack
               .padding(10)
           }  // Scroll
           .navigationBarTitle(Text("Followers"))
        }
       } //Navigation
    }
}

struct HStackChartsView_Previews: PreviewProvider {
    static var previews: some View {
        HStackChartsView()
        .environmentObject(UserData())
               .colorScheme(.dark)
    }
}
