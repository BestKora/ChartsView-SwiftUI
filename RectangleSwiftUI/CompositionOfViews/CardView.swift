//
//  CardView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 19/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var id:  Int {
           userData.charts.firstIndex(where: { $0.id == chart.id })!
       }
    
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    
    var chart: LinesSet
    
    var indent: CGFloat = 0
    var colorXAxis: Color = Color.secondary
    var colorXMark: Color = Color.primary
    
    private var index: Int {
           userData.charts.firstIndex(where: { $0.id == chart.id })!
       }

    private var cardBackgroundColor: Color {
        colorSchema == ColorScheme.light ?
            Color(white: 0.97) : Color(white: 0.18)
    }
    
    private func rangeTimeFor(indexChat: Int) -> Range<Int> {
        let numberPoints = userData.charts[indexChat].xTime.count
        let rangeTime: Range<Int>  = 0..<(numberPoints - 1)
        return rangeTime
    }
    var body: some View {
        GeometryReader { geometry in
        ZStack{
             self.cardBackgroundColor
                     VStack  (alignment: .leading, spacing: 10) {
                         Text("   CHART \(self.index + 1):  \(self.chart.xTime.first!) - \(self.chart.xTime.last!)  \(self.chart.lines.count)  lines")
                           .font(.subheadline)
                           .foregroundColor(Color("ColorTitle"))
                        
                        Text(" ").font(.footnote)
                  
                        GraphsViewForChart(
                            chart: self.userData.charts[self.index],
                            rangeTime: self.rangeTimeFor (indexChat: self.index))
                         .frame(height: geometry.size.height  * 0.78)
                     
                        TickerView(rangeTime: self.rangeTimeFor (indexChat: self.index),chart: self.userData.charts[self.index], colorXAxis: self.colorXAxis, colorXMark: self.colorXMark, indent: self.indent)
                       .frame(height: geometry.size.height  * 0.06)
                     } // VStack
                     } // Geometry
                 } //Zstack
               .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.primary))
               .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        CardView(chart: chartsData[0])
              .frame(height: 740)
              .environmentObject(UserData())
              .navigationBarTitle(Text("Followers"))
        }
        .colorScheme(.dark)
    }
}
