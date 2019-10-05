//
//  TimeMarkView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 25/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct TimeMarkView : View {
    var index: Int
    var xTime: [String]
    var colorXAxis: Color
    var colorXMark: Color
    
    var body: some View {
          GeometryReader { geometry in
           VStack (spacing: 0){
            Path { path in
                    path.move(to: CGPoint(x: 0 , y: 0))
                    path.addLine(to: CGPoint(x:0 , y:  10))
                } // Path
                .stroke(self.colorXAxis)
            Text(verbatim:String(self.xTime[self.index].dropLast(6)))
                .font(.footnote)
                .foregroundColor(self.colorXMark)
                .offset(x: (-(geometry.size.width / 2)))
           } // VStack
          } // Geometry
    }
}

struct TimeMarkView_Previews : PreviewProvider {
    static var previews: some View {
        TimeMarkView(index: 0,xTime: chartsData[0].xTime, colorXAxis: Color.red, colorXMark: Color.black)
            .frame(width: 100, height: 30)
            .padding(20)
    }
}
