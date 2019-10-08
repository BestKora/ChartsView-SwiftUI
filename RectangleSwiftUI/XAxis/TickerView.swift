//
//  TickerView.swift
//  MarksTime
//
//  Created by Tatiana Kornilova on 26/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct TickerView : View {
    var rangeTime: Range<Int>
    var chart: LinesSet
    var colorXAxis: Color
    var colorXMark: Color
    var indent: CGFloat
    
    var estimatedMarksNumber = 6
    
    var body: some View {
        GeometryReader { geometry in
           ScrollView(.horizontal, showsIndicators: false ){
            HStack (spacing: 0) {
                ForEach(self.calcScale(widthRange: geometry.size.width).indexes, id: \.self) { indexMark in
                    TimeMarkView(index: indexMark, xTime: self.chart.xTime, colorXAxis: self.colorXAxis, colorXMark: self.colorXMark)
                    } // ForEach
                    .frame(width: self.calcScale(widthRange: geometry.size.width).step, height: 30)
                    .offset(x: self.indent - self.calcScale(widthRange: geometry.size.width).scaleTime * CGFloat(self.rangeTime.lowerBound))
                } // HStack
             .overlay(XAxisView(color: self.colorXAxis))
        } // ScrollView
         .frame(height: geometry.size.height)
         .background(Color("ColorTickerX"))
        } // Geometry
    } //body
    
    private func calcScale(widthRange: CGFloat) -> (scaleTime :CGFloat,step: CGFloat, indexes: [Int]  ){
            let estimatedStepMark: CGFloat  = widthRange / CGFloat((1..<estimatedMarksNumber).distance)
            let scaleTime :CGFloat  = widthRange / CGFloat(rangeTime.distance - 1)
            let stepIndex: Int = Int(estimatedStepMark / scaleTime + 0.1)
            let indexes: [Int] = Array(0..<chart.xTime.count).filter{$0 % stepIndex == 0 }
            let step: CGFloat = CGFloat( stepIndex) * scaleTime
            
            return (scaleTime: scaleTime, step:  step, indexes: indexes)
        }
}

struct TickerView_Previews : PreviewProvider {
    static var previews: some View {
        TickerView( rangeTime: 0..<(chartsData[0].xTime.count - 1),
                   chart: chartsData[0],
                   colorXAxis: Color.blue,
                   colorXMark: Color.black,
                   indent: 0)
            .frame(height: 40)
    }
}



