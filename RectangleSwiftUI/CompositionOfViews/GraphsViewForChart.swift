//
//  GraphsViewForChart.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 24/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct GraphsViewForChart: View {
    @Environment(\.colorScheme) var colorSchema: ColorScheme
       
       var chart: LinesSet
       var rangeTime: Range<Int>
       var colorXAxis: Color = Color.secondary
       var colorXMark: Color = Color.primary
    
       private var indicatorColor: Color {
           colorSchema == ColorScheme.light ?
               Color.blue : Color.yellow
       }
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                YTickerView(chart:  self.chart,rangeTime: self.rangeTime, colorYAxis: Color("ColorTitle"), colorYMark: Color.primary)
                
                GraphsForChart(chart:  self.chart, rangeTime: self.rangeTime, lineWidth : 2)
                
                IndicatorView (color: self.indicatorColor, chart: self.chart, rangeTime: self.rangeTime)
            } // ZStack
        } //Geometry
    } // body
}

struct GraphsViewForChart_Previews: PreviewProvider {
    static var previews: some View {
         NavigationView {
            GraphsViewForChart(chart: chartsData[0], rangeTime: 0..<(chartsData[0].lines[0].points.count - 1))
            .navigationBarTitle(Text("Набор Графиков"))
         }
         .colorScheme(.dark)
    }
}
