//
//  RangeViewNewGeo.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 13/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct RangeViewNewGeo: View {
    @EnvironmentObject var userData: UserData
    var chart: LinesSet
    var index: Int {
             userData.chartIndex(chart: chart) /*firstIndex(where: { $0.id == chart.id })!*/
         }
    
    func rangeTimeFor(indexChat: Int) -> Range<Int> {
              let numberPoints = userData.charts[indexChat].xTime.count
           let rangeTime: Range<Int>  = Int(userData.charts[indexChat].range.lowerBound * CGFloat(numberPoints - 1))..<Int(userData.charts[indexChat].range.upperBound * CGFloat(numberPoints - 1))
              return rangeTime
          }
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 10){
        //--------
            ZStack {
        YTickerView(chart: self.userData.charts[self.index],colorYAxis: Color("ColorTitle"), colorYMark: Color.primary)
         GraphsForChart(chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index), lineWidth : 2)
        IndicatorView(color: Color.secondary, chart: self.userData.charts[self.index],  rangeTime: self.rangeTimeFor (indexChat: self.index))
            } //ZStack
            TickerView(rangeTime: self.rangeTimeFor (indexChat: self.index),chart: self.userData.charts[self.index], colorXAxis: Color.red, colorXMark: Color.blue, indent: 10)
            .frame(height: geometry.size.height  * 0.06)
        //--------
            RangeViewNew(bounds: Bounds(), widthRange: geometry.size.width, height: 100, chart: chartsData[0] )
            CheckMarksNewView(chart: self.userData.charts[self.index])
                .frame(height: geometry.size.height  * 0.05)
           //     .offset(y: 10)
            Text("\(/*bounds*/self.userData.charts[0].range.upperBound)")
            Text("\(/*bounds*/self.userData.charts[0].range.lowerBound )")
        }
    }
    }
}

struct RangeViewNewGeo_Previews: PreviewProvider {
    static var previews: some View {
        RangeViewNewGeo(chart: chartsData[0])
         .environmentObject(UserData())
    }
}
