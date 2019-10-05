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
    var widthRange: CGFloat /*{UIScreen.main.bounds.width}*/
    
    var estimatedMarksNumber = 6
    
  //  private var widthRange: CGFloat {UIScreen.main.bounds.width}
    private var numberPoints: Int {chart.xTime.count }
    private var rangeTimeWhole: Range<Int>  {0..<chart.xTime.count}
    
    var body: some View {
       let (scaleTime, step, indexes) = calcScale()
       return
        GeometryReader { geometry in
            
           return ScrollView(.horizontal, showsIndicators: false ){
            HStack (spacing: 0) {
            ForEach(indexes, id: \.self) { indexMark in
                    TimeMarkView(index: indexMark, xTime: self.chart.xTime, colorXAxis: self.colorXAxis, colorXMark: self.colorXMark)
                    } // ForEach
                .frame(width: step, height: 30)
                .offset(x: self.indent - scaleTime * CGFloat(self.rangeTime.lowerBound))
                } // HStack
             .overlay(XAxisView(color: self.colorXAxis))
        } // ScrollView
         .frame(height: geometry.size.height)
         .background(Color("ColorTickerX"))
        } // Geometry
    } //body
    
    private func calcScale() -> (scaleTime :CGFloat,step: CGFloat, indexes: [Int]  ){
            let estimatedStepMark: CGFloat  = widthRange / CGFloat((1..<estimatedMarksNumber).distance)
            let scaleTime :CGFloat  = widthRange / CGFloat(rangeTime.distance - 1)
        let stepIndex: Int = Int(estimatedStepMark / scaleTime + 0.1)
            let indexes: [Int] = Array(rangeTimeWhole).filter{$0 % stepIndex == 0 }
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
                   indent: 0,
                   widthRange: UIScreen.main.bounds.width)
            .frame(height: 40)
    }
}

/*
private var backColor: Color {
       colorSchema == ColorScheme.light ?
           Color(red: 249/255.0, green: 249/255.0, blue: 184/255.0, opacity: 0.5) :
           Color(red: 224/255.0, green: 234/255.0, blue: 245/255.0, opacity: 0.2)
   }
*/

