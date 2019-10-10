//
//  ChartView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 27/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct ChartView : View {
    @EnvironmentObject var userData: UserData
    
    var chart: LinesSet
    var colorXAxis: Color = Color.secondary
    var colorXMark: Color = Color.primary
    var indent: CGFloat = 0
    
    var index: Int {userData.charts.firstIndex(where: { $0.id == chart.id })!}
    
    func rangeTimeFor(indexChat: Int) -> Range<Int> {
        let numberPoints = userData.charts[indexChat].xTime.count
        let rangeTime: Range<Int>  = Int(userData.charts[indexChat].lowerBound * CGFloat(numberPoints - 1))..<Int(userData.charts[indexChat].upperBound * CGFloat(numberPoints - 1))
        return rangeTime
    }
    
    var body: some View {
       GeometryReader { geometry in
        VStack  (alignment: .leading, spacing: 10) {
            Text("   CHART \(self.index + 1):  \(self.chart.xTime.first!) - \(self.chart.xTime.last!)  \(self.chart.lines.count)  lines")
            .font(.headline)
            .foregroundColor(Color("ColorTitle"))
            Text(" ").font(.footnote)
            
            GraphsViewForChart(
                chart: self.userData.charts[self.index],
                rangeTime: self.rangeTimeFor (indexChat: self.index))
            .padding(self.indent)
            .frame(height: geometry.size.height  * 0.63)
            
            TickerView(rangeTime: self.rangeTimeFor (indexChat: self.index),chart: self.userData.charts[self.index], colorXAxis: self.colorXAxis, colorXMark: self.colorXMark, indent: self.indent)
            .frame(height: geometry.size.height  * 0.058)
            
            RangeView(chart: self.userData.charts[self.index], indent: self.indent)
            .environmentObject(self.userData)
            .frame(height: geometry.size.height  * 0.1)
            
            CheckMarksView(chart: self.userData.charts[self.index])
            .frame(height: geometry.size.height  * 0.05)
            
            Text(" ").font(.footnote)
         } // VStack
        } // Geometry
    }
}

struct ChartView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
        ChartView(chart: chartsData[0])
              .environmentObject(UserData())
              .navigationBarTitle(Text("Followers"))
        }
        .colorScheme(.dark)
    }
}
