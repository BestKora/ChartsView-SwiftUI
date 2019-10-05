//
//  CheckMarksViewNewView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 28/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CheckMarksView : View {
    @EnvironmentObject var userData: UserData
    var chart: LinesSet
    
    private var chartIndex: Int {userData.charts.firstIndex(where: { $0.id == chart.id })! }
    private func lineIndex(line: Line) -> Int {
        userData.charts[chartIndex].lines.firstIndex(where: { $0.id == line.id})!
    }
    var body: some View {
        GeometryReader { geometry in
            HStack (alignment: .top) {
                ForEach( self.chart.lines){ line in
                    SimulatedButton(line:  self.$userData.charts[self.chartIndex].lines[self.lineIndex(line: line)])
                 // CheckButton(line:
                 // self.$userData.charts[self.chartIndex].lines[self.lineIndex(line: line)])
                } // ForEach
            } // HStack
                .frame(width: geometry.size.width, height: geometry.size.height,  alignment: .topLeading)
        } // Geometry
    } // body
}

struct CheckMarksView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckMarksView(chart: chartsData[0])
                .frame( height: 40)
                .environmentObject(UserData())
        } // Navigation
        .colorScheme(.dark)
    }
}
