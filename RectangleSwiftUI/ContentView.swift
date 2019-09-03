//
//  ContentView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 14/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

struct Card: View {
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
            Color(white: 0.97) : Color.black
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
                      YTickerView(chart: self.userData.charts[self.index], indent: 0, colorYAxis: Color("ColorTitle"), colorYMark: Color.primary)
                      
                      GraphsForChart(chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index), lineWidth : 1)
                      .padding(self.indent)
                   
                      IndicatorView (color: self.indicatorColor, chart: self.chart, rangeTime: self.rangeTimeFor (indexChat: self.index))
                              .padding(self.indent)
                  }
                  .frame(height: geometry.size.height  * 0.78)
                  
                  TickerView(rangeTime: self.rangeTimeFor (indexChat: self.index),chart: self.userData.charts[self.index], colorXAxis: self.colorXAxis, colorXMark: self.colorXMark, height: geometry.size.height  * 0.06 ,indent: self.indent)
              } // VStack
              } // Geometry
          } //Zstack
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.secondary))
    }
}

// Need separate file
struct ListCardsView : View {
    // List
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List (0..<userData.charts.count, id:\.self){ indexChat in
                NavigationLink(destination:
                   ChartView(chart: self.userData.charts[indexChat])
                        .environmentObject(UserData())
                        .frame(height: 680))  {
                            ChartView(chart: self.userData.charts[indexChat])
                           // Card(chart: self.userData.charts[indexChat])
                            .environmentObject(UserData())
                                .frame(height: 680)
                }
            }// List
                .navigationBarTitle(Text("Followers"))
        } // Navigation
    }
}

// Need separate file
struct HStackCardsView : View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            ScrollView (.horizontal, showsIndicators: false){
                HStack (spacing: 50) {
                    ForEach(0..<userData.charts.count){ indexChat in
                        GeometryReader { geometry in
                           ChartView(chart: self.userData.charts[indexChat])
                            .rotation3DEffect(Angle(degrees: Double(
                                     (geometry.frame(in:.global).minX - 16)  / 10 )), axis: (x: 0.0, y: 10.0, z: 0.0))
                         } //geometry
                            .frame (width: 340, height: 680)
                    } //Each
                } //HStack
                .padding(40)
            }  // Scroll
            .offset(y: 20)
            .navigationBarTitle(Text("Followers"))
        }
    }
}

// Need separate file
struct OverlayStackView : View {
    @EnvironmentObject var userData: UserData
    @State var indeces = [0,1,2,3,4]
  
    func indexOfIndeces(forElement: Int) -> Int {
        return indeces.firstIndex(of: forElement)!
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    ForEach(indeces.reversed(), id: \.self){ indexChat in
                        Card(chart: self.userData.charts[indexChat])
                          //  .environmentObject(UserData())
                            .frame(height: 600)
                            .offset(y: CGFloat(33 * (self.indeces.count -  self.indexOfIndeces(forElement: indexChat) - 1)))
                            .animation(.easeInOut(duration: 0.6))
                            .onTapGesture(count: 1)  {
                                self.indeces.rearrange(from: self.indexOfIndeces(forElement: indexChat), to: 4)
                        }
                    }// ForEach
                } // ZStack
                Spacer()
                } // VStack
                .navigationBarTitle(Text("Followers"))
        }
    }
}
struct ContentView : View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        ListCardsView ()
      //   HStackCardsView ()
      //   OverlayStackView ()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
            .environmentObject(UserData())
    }
}
#endif



//  @Environment(\.colorScheme) var colorSchema: ColorScheme
//  Card(indexChart: 0)
//   ChartView(chart: userData.charts[0])
