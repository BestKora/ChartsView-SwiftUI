//
//  YAxisView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 29/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct YAxisView : View {
    var color: Color
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    path.move(to: CGPoint(x: 10, y: 0))
                    path.addLine(to: CGPoint(x:10 , y: geometry.size.height))
                    }
                    .stroke(self.color, lineWidth: 2)
            }
        }
    }
}

struct YAxisView_Previews : PreviewProvider {
    static var previews: some View {
        YAxisView(color: Color.red)
            .frame(height: 100)
    }
}

