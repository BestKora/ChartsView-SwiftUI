//
//  TickerView.swift
//  MarksTime
//
//  Created by Tatiana Kornilova on 26/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct TickerView : View {
    @EnvironmentObject var userData: UserData
    
    var rangeTime: Range<Int>
    var chart: LinesSet
    var colorXAxis: Color
    var colorXMark: Color
    
    var height: CGFloat
    var indent: CGFloat
    var estimatedMarksNumber = 6
    
    private var widthRange: CGFloat {UIScreen.main.bounds.width}
    private var numberPoints: Int {chart.xTime.count }
    private var rangeTimeWhole: Range<Int>  {0..<userData.charts[chartIndex].xTime.count}
    private var chartIndex: Int {userData.chartIndex(chart: chart)}
    
    var body: some View {
       let (scaleTime, step, indexes) = calcScale()
       return
        ScrollView(.horizontal, showsIndicators: false ){
            HStack (spacing: 0) {
                ForEach(indexes, id: \.self) { indexMark in
                    TimeMarkView(index: indexMark, xTime: self.chart.xTime, colorXAxis: self.colorXAxis, colorXMark: self.colorXMark)
                    } // ForEach
                .frame(width: step, height: 30)
                .offset(x: self.indent - scaleTime * CGFloat(self.rangeTime.lowerBound))
                } // HStack
             .overlay(XAxisView(color: self.colorXAxis))
        } // ScrollView
         .frame(height: self.height)
         .background(Color("ColorTickerX"))
         //  .transition(.moveAndFadeMarks)
    }
    
    private func calcScale() -> (scaleTime :CGFloat,step: CGFloat, indexes: [Int]  ){
            let estimatedStepMark: CGFloat  = widthRange / CGFloat((1..<estimatedMarksNumber).distance)
            let scaleTime :CGFloat  = widthRange / CGFloat(rangeTime.distance - 1)
            let stepIndex: Int = Int(estimatedStepMark / scaleTime)
            let indexes: [Int] = Array(rangeTimeWhole).filter{$0 % stepIndex == 0 }
            let step: CGFloat = CGFloat( stepIndex) * scaleTime
            
            return (scaleTime: scaleTime, step:  step, indexes: indexes)
        }
}

#if DEBUG
struct TickerView_Previews : PreviewProvider {
    static var previews: some View {
        TickerView(rangeTime: 0..<(chartsData[4].lines[0].points.count - 1),chart: chartsData[4], colorXAxis: Color.blue, colorXMark: Color.black, height: 40, indent: 10)
            .environmentObject(UserData())
    }
}
#endif

/*
private var backColor: Color {
       colorSchema == ColorScheme.light ?
           Color(red: 249/255.0, green: 249/255.0, blue: 184/255.0, opacity: 0.5) :
           Color(red: 224/255.0, green: 234/255.0, blue: 245/255.0, opacity: 0.2)
   }
*/

