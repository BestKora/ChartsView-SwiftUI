//
//  IndicatorView.swift
//  Indicator
//
//  Created by Tatiana Kornilova on 02/07/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct IndicatorView : View {
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    
    @State private var positionIndicator: CGFloat = 0.3
    @State private var prevTranslation: CGFloat = 0
    
    var color: Color
    var chart: LinesSet
    var rangeTime: Range<Int>
    
    private var chartIndex: Int {userData.chartIndex(chart: chart)}
    private var indexIndicator:Int { return rangeTime.lowerBound + Int(CGFloat(rangeTime.distance - 1) * positionIndicator)}
    
    private var zViewTintColor: Color {
        colorSchema == ColorScheme.light ?
            Color(red: 87/255.0, green: 87/255.0, blue: 87/255.0, opacity: 0.1) :
            Color(red: 209/255.0, green: 209/255.0, blue: 204/255.0, opacity: 0.4)
    }
 
    var rangeY : Range<Int>? {
        let rangeY = rangeOfRanges(userData.charts[chartIndex].lines.filter{!$0.isHidden}.map {$0.points[rangeTime].min()!..<$0.points[rangeTime].max()!})
         return rangeY == 0..<0 ? 0..<1 : rangeY
    }
    
  //  private var numberPoints: Int {chart.xTime.count }
    
    private var notHiddenLines: [Line]  {userData.charts[chartIndex].lines.filter {!$0.isHidden }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading){
                            Text(self.chart.xTime[self.indexIndicator])
                                .foregroundColor(self.color)
                            ForEach (self.notHiddenLines, id: \.title ) { line in
                                Text("\(Int(self.betweenValue(yInt: line.points) ))")
                                    .foregroundColor(Color(uiColor: line.color!))
                            }
                        }
                        .padding(10)
                        .background(  self.zViewTintColor)
                        .cornerRadius(15)
                        Spacer()
                    }
                    .padding(10)
                    .offset(x: self.positionIndicator < 0.75 ? (-geometry.size.width / 2 + 60)  : -265)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x:0 , y: geometry.size.height))
                    }
                    .stroke(self.color, lineWidth: 1)
                    .frame(height: geometry.size.height)
                    
                    ForEach (self.notHiddenLines, id: \.title ) { line in
                        Path { path in
                            let scale = geometry.size.height / CGFloat((self.rangeY!.upperBound - self.rangeY!.lowerBound) )
                            let origin = CGPoint(x: 0, y: geometry.size.height)
                            let yGraph = origin.y - CGFloat(self.betweenValue(yInt: line.points)  - CGFloat(self.rangeY!.lowerBound))  * scale
                            path.addArc(center: CGPoint(x: 0, y: yGraph),
                                        radius: 4,
                                        startAngle: Angle (radians: 0.0),
                                        endAngle:Angle (radians: Double.pi * 2),
                                        clockwise: true)
                        }
                        .stroke(Color(uiColor: line.color!), lineWidth: 2)
                        .frame(height: geometry.size.height)
                    }
                } // ZStack
                Spacer()
            } // VStack
                .frame(height: geometry.size.height)
                .offset(x: self.positionIndicator * geometry.size.width  )
                .gesture(DragGesture()
                    .onChanged { value in
                        let newPosition = self.positionIndicator + (value.translation.width - self.prevTranslation) / geometry.size.width
                        self.positionIndicator = min(max(newPosition,0),1)
                        self.prevTranslation = value.translation.width
                }
                .onEnded { value in
                    let newPosition = self.positionIndicator + (value.translation.width - self.prevTranslation) / geometry.size.width
                    self.positionIndicator = min(max(newPosition,0),1)
                    self.prevTranslation = 0.0
                    }
            )
        }// Geometry
        
    }
    private func betweenValue ( yInt: [Int]) -> CGFloat {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d yyyy")
        
        let doubleInd = Double(rangeTime.lowerBound) + Double(rangeTime.distance - 1 ) * Double(positionIndicator)
        
        let date1 = dateFormatter.date(from: chart.xTime[indexIndicator])
        let date2 = dateFormatter.date(from: chart.xTime[indexIndicator + 1])
        let daysBetween = date2!.days(from: date1!)
        
        let y011 = yInt [indexIndicator]
        let y012 = yInt [indexIndicator + 1]
        let y0Between = Double(y012 - y011)
        let gradient = y0Between / Double(daysBetween)
        let y0New = Double(y011) + gradient * (doubleInd - Double(indexIndicator))
        return CGFloat(y0New)
    }
}

#if DEBUG
struct IndicatorView_Previews : PreviewProvider {
    static var previews: some View {
        IndicatorView(color: Color.secondary, chart: chartsData[0],  rangeTime: 0..<chartsData[0].lines[0].points.count)
            .colorScheme(.light)
        .environmentObject(UserData())
    }
}
#endif
