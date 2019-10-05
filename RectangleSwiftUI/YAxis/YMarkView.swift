//
//  YMarkView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 28/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct YMarkView : View {
    var yValue: Int
    var colorYAxis: Color
    var colorYMark: Color
    
    var body: some View {
            GeometryReader { geometry in
                VStack (spacing: 0){
                Path { path in
                        path.move(to: CGPoint(x: 0 , y: 0))
                        path.addLine(to: CGPoint(x:geometry.size.width, y: 0))
                     }
                    .stroke(Color.secondary,lineWidth: 1)
               Text(self.yValue.formatnumber().trimmingCharacters(in: .whitespacesAndNewlines))
                   .font(.body)
                   .foregroundColor(self.colorYMark)
                   .offset(x: (-(geometry.size.width / 2) + 30), y: -(geometry.size.height))
                }//VStack
                 .animation(.easeInOut(duration: 0.6))
            } // Geometry
    }
}

struct YMarkView_Previews : PreviewProvider {
    static var previews: some View {
        YMarkView(yValue: 188, colorYAxis: Color.blue, colorYMark: Color.red)
            .frame(height: 100, alignment: .leading)
    }
}


