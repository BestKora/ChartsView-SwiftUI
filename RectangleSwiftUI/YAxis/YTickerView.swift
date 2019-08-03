//
//  YTickerViewNew.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 05/07/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFadeMarks: AnyTransition {
        let insertion = AnyTransition.move(edge: .top)
            .combined(with: .opacity)
        
        let removal = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct YTickerView : View {
    @EnvironmentObject var userData: UserData
    
    var chart: LinesSet
    var indent: Length
    var colorYAxis: Color
    var colorYMark: Color
    
    var estimatedMarksNumber = 6
    
    private var numberPoints: Int {chart.lines[0].points.count }
    private var rangeTime: Range<Int> {Int(userData.charts[chartIndex].lowerBound * CGFloat(numberPoints - 1))..<Int(userData.charts[chartIndex].upperBound * CGFloat(numberPoints - 1)) }
    private var chartIndex: Int {userData.chartIndex(chart: chart)}
    
    var rangeY : Range<Int>? {
        let rangeY = rangeOfRanges(userData.charts[chartIndex].lines.filter{!$0.isHidden}.map {$0.points[rangeTime].min()!..<$0.points[rangeTime].max()!})
        return rangeY == 0..<0 ? 0..<1 : rangeY
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                ForEach(self.calcScale(height: geometry.size.height).marks.reversed(), id:\.self){ mark in
                    YMarkView(yValue: mark, colorYAxis: self.colorYAxis, colorYMark: self.colorYMark)
                } // ForEach
                .frame(width: geometry.size.width,
                       height:  self.calcScale(height: geometry.size.height).stepYHeight,
                       alignment: .leading)
                    .offset(y:( self.calcScale(height: geometry.size.height).scaleY * CGFloat(self.rangeY!.upperBound -  self.calcScale(height: geometry.size.height).marks.last!)))
                    .animation(.easeInOut(duration: 0.6))
            } //VStack
            .transition(.moveAndFadeMarks)
            
        } //Geometry
         .padding(self.indent)
         .overlay(YAxisView(color: self.colorYAxis))
    }
    
    private func calcScale(height: CGFloat) -> (scaleY :CGFloat,stepYHeight: CGFloat, marks: [Int]  ){
            
            let scaleY :CGFloat  = height / CGFloat(rangeY!.distance)
            let stepYHeight: CGFloat = height / CGFloat((0..<estimatedMarksNumber).distance - 1)
            let stepYValue: CGFloat = stepYHeight / scaleY
            var marks = [Int]()
            for i in 0..<estimatedMarksNumber{
                marks.append(rangeY!.lowerBound + Int(stepYValue) * i)
            }
            
            return (scaleY: scaleY, stepYHeight:  CGFloat(Int(stepYValue)) * scaleY, marks: marks)
        }
}


#if DEBUG
struct YTickerView_Previews : PreviewProvider {
    static var previews: some View {
        YTickerView(chart: chartsData[0], indent: 0, colorYAxis: Color.red, colorYMark: Color.blue)
            .frame(height: 500)
            .environmentObject(UserData())
        
    }
}
#endif
