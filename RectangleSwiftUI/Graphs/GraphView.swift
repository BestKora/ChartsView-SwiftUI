//
//  ContentView.swift
//  Graph
//
//  Created by Tatiana Kornilova on 10/06/2019.
//  Copyright © 2019 BestKora. All rights reserved.
//

import SwiftUI

struct GraphView : View {
    var rangeTime: Range<Int>
    var line: Line
    var rangeY: Range<Int>?
    var lineWidth: CGFloat = 1
   
    private var colorGraph: Color  { Color(uiColor: line.color!) }
    private var minY: Int {rangeY == nil ? line.points[rangeTime].min()! : rangeY!.lowerBound}
    private var maxY: Int {rangeY == nil ? line.points[rangeTime].max()!: rangeY!.upperBound}
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = geometry.size.width
                let scale = geometry.size.height / (CGFloat(self.maxY - self.minY) )
                let origin = CGPoint(x: 0, y: geometry.size.height )
                let step = (width - origin.x) / CGFloat(self.rangeTime.distance - 1)
                
               path.addLines(Array(self.rangeTime.lowerBound..<self.rangeTime.upperBound)
                            .map{ CGPoint(x: origin.x + CGFloat($0 - self.rangeTime.lowerBound) * step,
                                         y: origin.y - CGFloat(self.line.points[$0]  - self.minY)  * scale)
                                }
                             )
            } // Path
                .stroke(self.colorGraph, lineWidth: self.lineWidth)
                .animation(.linear(duration: 0.6))
        } // Geometry
    }  // body
}


struct GraphView_Previews : PreviewProvider {
    static var previews: some View {
        GraphView ( rangeTime: 0..<(chartsData[4].xTime.count - 1),
                   line: chartsData[4].lines[0],lineWidth: 2 )
        .frame( height: 400 )
    }
}


