//
//  CheckBoxView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 20/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CheckBoxView: View {
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    @Binding var line: Line
    
    private var uncheckColor: Color {
           colorSchema == ColorScheme.light ?
               Color.white : Color.black
       }
    var body: some View {
       HStack(alignment: .bottom) {
                 Image(systemName: !line.isHidden ? "checkmark" : "minus")
                  .resizable()
                  .frame(width: 20, height: 20, alignment: .leading)
                  .foregroundColor(!line.isHidden ? Color.white : uncheckColor)
                                 
                  Text(line.title!)
                  .font(.body)
                  .foregroundColor(!line.isHidden ? Color.white : Color(uiColor: line.color!))
              } // HStack
              .frame(height: 10, alignment: .leading)
              .padding()
              .overlay(
                    RoundedRectangle(cornerRadius: 10)
                       .stroke(lineWidth: 6)
                       .foregroundColor(Color(uiColor: line.color!))
               )
              .background(!line.isHidden ? Color(uiColor: line.color!) : uncheckColor)
              .cornerRadius(10)
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        var linen = chartsData[0].lines[0]
        linen.isHidden = true
        return NavigationView {
          CheckBoxView(line: .constant(linen))
        }
        .colorScheme(.dark)
    }
}
