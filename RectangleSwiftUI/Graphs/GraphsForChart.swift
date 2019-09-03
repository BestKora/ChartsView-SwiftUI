//
//  GraphsForChart.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 17/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Int>
    where C.Element == Range<Int> {
        guard !ranges.isEmpty else { return 0..<0 }
        let low = ranges.lazy.map { $0.lowerBound }.min()!
        let high = ranges.lazy.map { $0.upperBound }.max()!
        return low..<high
}

struct GraphsForChart : View {
    @EnvironmentObject  var userData: UserData
    
    var chart: LinesSet
    var rangeTime: Range<Int>
    var lineWidth: CGFloat = 1
    
    private var chartIndex: Int {userData.chartIndex(chart: chart)}
    var rangeY : Range<Int> {
        let rangeY = rangeOfRanges(userData.charts[chartIndex].lines.filter{!$0.isHidden}.map {$0.points[rangeTime].min()!..<$0.points[rangeTime].max()!})
         return rangeY == 0..<0 ? 0..<1 : rangeY
    }

    var body: some View {
       ZStack{
        ForEach(userData.charts[chartIndex].lines.filter{!$0.isHidden}) { line in
                    GraphViewNew(rangeTime: self.rangeTime, line:  line, rangeY: self.rangeY, lineWidth: self.lineWidth)
                       .transition(.move(edge: .top))
            }
           .drawingGroup()
        }
    }
}

#if DEBUG
struct GraphsForChart_Previews : PreviewProvider {
    static var previews: some View {
        GraphsForChart(chart: chartsData[4], rangeTime: 0..<(chartsData[4].lines[0].points.count - 1), lineWidth : 2)
         .frame( height: 400 )
         .environmentObject(UserData())
    }
}
#endif
