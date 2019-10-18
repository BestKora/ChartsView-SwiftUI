//
//  CheckBoxView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 18/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CheckBoxView: View {
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    @Binding var line: Line
    
    private var unckeckColor: Color {
        colorSchema == ColorScheme.light ? .white : .black
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            Image(systemName: !line.isHidden ? "checkmark" : "minus")
                .resizable()
                .frame(width: 20, height: 20, alignment: .leading)
                .foregroundColor(!line.isHidden ? .white : unckeckColor)
            
            Text(line.title!)
                .font(.body)
                .foregroundColor(!line.isHidden ? .white : Color(uiColor: line.color!))
            }
        .frame(height: 10, alignment: .leading)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 6)
                .foregroundColor(Color(uiColor: line.color!))
        )
            .background(!line.isHidden ? Color(uiColor: line.color!) : unckeckColor)
            .cornerRadius(10)
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
       var linen = chartsData[0].lines[0]
        linen.isHidden = false
        return NavigationView {
            CheckBoxView(line: .constant(linen))
        }
        .colorScheme(.dark)
    }
}
