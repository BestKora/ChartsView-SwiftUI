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
               Text(verbatim:self.yValue.formatnumber().trimmingCharacters(in: .whitespacesAndNewlines))
                   .font(.body)
                   .foregroundColor(self.colorYMark)
                   .offset(x: (-(geometry.size.width / 2) + 30), y: -(geometry.size.height))
                }//VStack
            } // Geometry
    }
}

#if DEBUG
struct YMarkView_Previews : PreviewProvider {
    static var previews: some View {
        YMarkView(yValue: 188, colorYAxis: Color.blue, colorYMark: Color.red)
            .frame(height: 60, alignment: .leading)
    }
}
#endif

extension Int {
    func formatnumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = " "
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 1
        if 1000 < self  && self < 999000 {
            let newValue = (Double(self) / Double(1000))
            return (formater.string(from: NSNumber(value: newValue))! + " K")
        }
        if 1000000 < self  && self < 999000000 {
            let newValue = Double(self) / Double(1000000)
            return (formater.string(from: NSNumber(value: newValue ))! + " M")
        }
        return formater.string(from: NSNumber(value: self))!
    }
}
