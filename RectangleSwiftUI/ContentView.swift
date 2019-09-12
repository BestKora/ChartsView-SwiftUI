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

struct Card: View, Identifiable {
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
            Color(white: 0.97) : Color(white: 0.12)
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
                      
                      GraphsForChart(chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index), lineWidth : 2)
                      .padding(self.indent)
                   
                      IndicatorView (color: self.indicatorColor, chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index))
                              .padding(self.indent)
                  }
                  .frame(height: geometry.size.height  * 0.78)
              
                  TickerView(rangeTime: self.rangeTimeFor (indexChat: self.index),chart: self.userData.charts[self.index], colorXAxis: self.colorXAxis, colorXMark: self.colorXMark, /*height: geometry.size.height  * 0.06,*/indent: self.indent)
                .frame(height: geometry.size.height  * 0.06)
              } // VStack
              } // Geometry
          } //Zstack
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.primary))
        .cornerRadius(20)
        .padding()
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
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    @State var indeces = [0,1,2,3,4]
    @State var viewState = CGSize.zero
    @State private var presentedCard: LinesSet?
  
    func indexOfIndeces(forElement: Int) -> Int {
        return indeces.firstIndex(of: forElement)!
    }
    func yOffset (forElement: Int) -> CGFloat {
        CGFloat(43 * (self.indeces.count -  self.indexOfIndeces(forElement: forElement) - 1)) + (self.indexOfIndeces(forElement: forElement) == 0 ? self.viewState.height : 0) - 40
    }
    
    private var cardBackgroundColor: Color {
        colorSchema == ColorScheme.light ?
            Color(white: 0.97) : Color(white: 0.12)
    }
    
    var body: some View {
  
            VStack{
                ZStack{
                    ForEach(self.indeces.reversed(), id: \.self){ indexChat in
                 Group {
                    if self.indexOfIndeces(forElement: indexChat) == 0 {
                 //   if self.indeces.firstIndex(of: indexChat) == 0 {
                        Card(chart: self.userData.charts[indexChat])
                          //  .environmentObject(UserData())
                            .frame(height: 700 )
                            .offset(y: self.yOffset(forElement: indexChat) )
                            .scaleEffect(1.0 - CGFloat(self.indeces.firstIndex(of: indexChat)!/*self.indexOfIndeces(forElement: indexChat)*/) * 0.03 + CGFloat(self.scaleResistance()))
                            
                            .gesture(LongPressGesture(minimumDuration: 0.1)
                                     .sequenced(before: DragGesture()
                                     .onChanged { value in
                                         self.viewState = value.translation
                                     }
                                    .onEnded { value in
                                        if self.viewState.height > 300 {
                                             self.indeces.rearrange(from: self.indexOfIndeces(forElement: indexChat), to: (self.indeces.count - 1))
                                             self.viewState = CGSize.zero
                                        } else {
                                            self.viewState = CGSize.zero
                                        }
                                   }
                            )
                            )
                            .simultaneousGesture(TapGesture(count: 1).onEnded({ _ in
                                self.presentedCard =  self.userData.charts[indexChat]
                                       }))
                            
                        .sheet(item: self.$presentedCard, onDismiss: {
                            self.presentedCard = nil
                        }, content: { card in
                            NavigationView {
                               ChartView(chart: card)
                                .frame(height: 760)
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.primary))
                            }
                            .navigationViewStyle(StackNavigationViewStyle())
                            .environmentObject(UserData())
                            .colorScheme(self.colorSchema)
                        })
                    
                    } else {
                        Card(chart: self.userData.charts[indexChat])
                        //  .environmentObject(UserData())
                          .frame(height: 700 )
                            .offset(y: self.yOffset(forElement: indexChat) )
                       .scaleEffect(1.0 - CGFloat(self.indeces.firstIndex(of: indexChat)!/*self.indexOfIndeces(forElement: indexChat)*/) * 0.03 + CGFloat(self.scaleResistance()))
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                    }
                    } // Group
                    }// ForEach
                } // ZStack

                 Spacer()
                } // VStack
     
      
    } // body
    private func scaleResistance() -> Double {
        Double(UIScreen.main.bounds.width) / 6800
       }
}
struct ContentView : View {
    @EnvironmentObject var userData: UserData
    var body: some View {
       // ListCardsView ()
        HStackCardsView ()
       //  OverlayStackView ()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        
        ContentView()
         //   .padding()
            .environmentObject(UserData())
            .colorScheme(.dark)
    }
}
#endif



//  @Environment(\.colorScheme) var colorSchema: ColorScheme
//  Card(indexChart: 0)
//   ChartView(chart: userData.charts[0])
