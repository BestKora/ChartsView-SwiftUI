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
    
    var index: Int {
        userData.charts.firstIndex(where: { $0.id == chart.id })!
    }
    
    var indent: CGFloat = 0
    var colorXAxis: Color = Color.secondary
    var colorXMark: Color = Color.primary
    
    private var indicatorColor: Color {
        colorSchema == ColorScheme.light ?
            Color.blue : Color.yellow
    }
    
    private var cardBackgroundColor: Color {
        colorSchema == ColorScheme.light ?
            Color(white: 0.97) : Color(white: 0.18)
    }
    
    func rangeTimeFor(indexChat: Int) -> Range<Int> {
        let numberPoints = userData.charts[indexChat].xTime.count
        let rangeTime: Range<Int>  = 0..<(numberPoints - 1)
        return rangeTime
    }
    var body: some View {
        ZStack{
             self.cardBackgroundColor
              GeometryReader { geometry in
                     VStack  (alignment: .leading, spacing: 10) {
                         Text("   CHART \(self.index + 1):  \(self.chart.xTime.first!) - \(self.chart.xTime.last!)  \(self.chart.lines.count)  lines")
                           .font(.subheadline)
                           .foregroundColor(Color("ColorTitle"))
                       Text(" ").font(.footnote)
                         ZStack{
                             YTickerView(chart: self.userData.charts[self.index], colorYAxis: Color("ColorTitle"), colorYMark: Color.primary)
                             
                             GraphsForChart(chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index), lineWidth : 2)
                             .padding(self.indent)
                          
                             IndicatorView (color: self.indicatorColor, chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index))
                                     .padding(self.indent)
                         }
                         .frame(height: geometry.size.height  * 0.78)
                     
                         TickerView(rangeTime: self.rangeTimeFor (indexChat: self.index),chart: self.userData.charts[self.index], colorXAxis: self.colorXAxis, colorXMark: self.colorXMark, indent: self.indent)
                       .frame(height: geometry.size.height  * 0.06)
                     } // VStack
                     } // Geometry
                 } //Zstack
               .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.primary))
               .cornerRadius(20)
               .padding()
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
