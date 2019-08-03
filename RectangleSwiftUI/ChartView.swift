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
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    
    var chart: LinesSet
    
    var index: Int {
        userData.charts.firstIndex(where: { $0.id == chart.id })!
    }
    
    var indent: Length = 0
    var colorXAxis: Color = Color.secondary
    var colorXMark: Color = Color.primary
    
    private var indicatorColor: Color {
        colorSchema == ColorScheme.light ?
            Color.blue : Color.yellow
    }
    
    func rangeTimeFor(indexChat: Int) -> Range<Int> {
        let numberPoints = userData.charts[indexChat].xTime.count
        let rangeTime: Range<Int>  = Int(userData.charts[indexChat].lowerBound * CGFloat(numberPoints - 1))..<Int(userData.charts[indexChat].upperBound * CGFloat(numberPoints - 1))
        return rangeTime
    }
    
    var body: some View {
//      NavigationView {
       GeometryReader { geometry in
        VStack  (alignment: .leading, spacing: 10) {
            Text("   CHART \(self.index + 1):  \(self.chart.xTime.first!) - \(self.chart.xTime.last!)  \(self.chart.lines.count)  lines")
            .font(.headline)
            .foregroundColor(Color("ColorTitle"))
            Text(" ").font(.footnote)
            ZStack{
                YTickerView(chart: self.userData.charts[self.index], indent: 0, colorYAxis: Color("ColorTitle"), colorYMark: Color.primary)
                
                GraphsForChart(chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index), lineWidth : 2)
                .padding(self.indent)
             
                IndicatorView (color: self.indicatorColor, chart: self.chart, rangeTime: self.rangeTimeFor (indexChat: self.index))
                        .padding(self.indent)
            }
            .frame(height: geometry.size.height  * 0.63)
            
            TickerView(chart: self.userData.charts[self.index], colorXAxis: self.colorXAxis, colorXMark: self.colorXMark, height: geometry.size.height  * 0.058 ,indent: self.indent)
            
            RangeView(chart: self.userData.charts[self.index], height: geometry.size.height  * 0.1, widthRange: geometry.size.width, indent: self.indent)
                .environmentObject(self.userData)
 
            CheckMarksView(chart: self.userData.charts[self.index], height: geometry.size.height  * 0.05, width: geometry.size.width)
                .offset(y: 10)
            Text(" ").font(.footnote)
        } // VStack
        } // Geometry
 /*
       .navigationBarTitle(Text("Followers"))
        } //NavigationView
*/
    }
}
//}

#if DEBUG
struct ChartView_Previews : PreviewProvider {
    static var previews: some View {
        ChartView(chart: chartsData[0])
             .colorScheme(.light)
             .frame(height: 780)
             .environmentObject(UserData())
       
    }
}
#endif
