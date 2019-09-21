//
//  CheckButton.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 18/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CheckButton: View {
    @Binding var line: Line
    
    var body: some View {
      Button (action: { self.line.isHidden.toggle()}) {
          CheckBoxView(line: $line)
        } // Button
    } // body
}

struct CheckButton_Previews: PreviewProvider {
    static var previews: some View {
       var linen = chartsData[0].lines[0]
        linen.isHidden = false
        return CheckButton(line:.constant(linen))
    }
}
