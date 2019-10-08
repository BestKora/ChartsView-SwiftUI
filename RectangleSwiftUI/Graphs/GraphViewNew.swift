//
//  GraphViewNew.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 20/08/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct Graph: Shape {
    var rangeTime: Range<Int>
    var line: Line
    var lowerY: CGFloat
    var upperY: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
            get {
                AnimatablePair(lowerY, upperY)
            }
            set {
                lowerY = newValue.first
                upperY = newValue.second
            }
        }
           
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width: CGFloat = rect.size.width
        let scale = rect.size.height / (upperY - lowerY)
        let origin = CGPoint(x: 0, y: rect.size.height )
        let step = (width - origin.x) / CGFloat(rangeTime.distance - 1)
        path.addLines(Array(rangeTime.lowerBound..<rangeTime.upperBound)
                .map{ CGPoint(x: origin.x + CGFloat($0 - rangeTime.lowerBound) * step,
                              y: origin.y - ((CGFloat(line.points[$0])  - lowerY))*scale)
                            }
                    )
        return path
    }
}

struct GraphViewNew: View {
    var rangeTime: Range<Int>
    var line: Line
    var rangeY: Range<Int>?
    var lineWidth: CGFloat = 1
    
    private var colorGraph: Color  { Color(uiColor: line.color!) }
    private var minY: Int {rangeY == nil ? line.points[rangeTime].min()! : rangeY!.lowerBound}
    private var maxY: Int {rangeY == nil ? line.points[rangeTime].max()!: rangeY!.upperBound}
    
    var body: some View {
        Graph(rangeTime: rangeTime, line: line, lowerY:  CGFloat(minY), upperY: CGFloat(maxY))
            .stroke(self.colorGraph, lineWidth: self.lineWidth)
            .animation(.linear(duration: 0.6))
    }  // body
}

struct GraphViewNew_Previews: PreviewProvider {
    static var previews: some View {
        GraphViewNew(rangeTime: 0..<(chartsData[4].lines[0].points.count - 1),
                     line: chartsData[4].lines[0],
                     lineWidth: 2)
                    .frame( height: 400 )
    }
}
