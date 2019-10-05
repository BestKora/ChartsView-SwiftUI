//
//  OverlayCardsView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 19/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CardViewScalable : View {
    @EnvironmentObject var userData: UserData
    
    var indexChat: Int
 //   var height: CGFloat
    @Binding var viewState : CGSize
    @Binding var indeces:[Int]
    
    var body: some View {
 
            CardView(chart: self.userData.charts[self.indexChat])
         //       .frame(height: self.height)
                .offset(y: self.yOffset(forElement: self.indexChat) )
                .scaleEffect(1.0 - CGFloat(self.indeces.firstIndex(of: self.indexChat)!) * 0.03 + CGFloat(self.scaleResistance()))
  
    }
    
    private func scaleResistance() -> Double {
     Double(UIScreen.main.bounds.width) / 6800
    }
   
    private  func yOffset (forElement: Int) -> CGFloat {
        CGFloat(43 * (self.indeces.count -  self.indexOfIndeces(forElement: forElement) - 1)) + (self.indexOfIndeces(forElement: forElement) == 0 ? self.viewState.height : 0) - 40
    }
    
    func indexOfIndeces(forElement: Int) -> Int {
        return indeces.firstIndex(of: forElement)!
    }
}

struct OverlayCardsView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorSchema: ColorScheme
       @State var indeces = [0,1,2,3,4]
       @State var viewState = CGSize.zero
       @State private var presentedCard: LinesSet?
     
       func indexOfIndeces(forElement: Int) -> Int {
           return indeces.firstIndex(of: forElement)!
       }
       
    var body: some View {
        GeometryReader { geometry in
                VStack{
                 ZStack{
                  ForEach(self.indeces.reversed(), id: \.self){ indexChat in
                    Group {
                       if self.indexOfIndeces(forElement: indexChat) == 0 {
                        CardViewScalable(indexChat: indexChat,/* height: geometry.size.height * 0.80,*/ viewState: self.$viewState, indeces: self.$indeces)
                             .frame(height: geometry.size.height * 0.80)
                            .environmentObject(UserData())
                            .gesture(LongPressGesture(minimumDuration: 0.1)
                                 .sequenced(before:
                                    DragGesture()
                                        .onChanged { value in self.viewState = value.translation}
                                        .onEnded { value in
                                            if self.viewState.height > geometry.size.height / 2 {
                                               self.indeces.rearrange(from: self.indexOfIndeces(forElement: indexChat), to: (self.indeces.count - 1))
                                            }
                                            self.viewState = CGSize.zero
                                        }
                                ) // sequenced
                               ) // gesture
                               .simultaneousGesture(TapGesture(count: 1)
                                     .onEnded({ _ in
                                         self.presentedCard =  self.userData.charts[indexChat]
                                     })
                               )
                               .sheet(item: self.$presentedCard, onDismiss: {self.presentedCard = nil},
                                 content: { card in
                               NavigationView {
                                VStack {
                                  ChartView(chart: card)
                                   .frame(height: geometry.size.height * 0.9)
                                   .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.primary))
                                    Spacer()
                               }
                               }
                               .navigationViewStyle(StackNavigationViewStyle())
                               .environmentObject(UserData())
                               .colorScheme(self.colorSchema)
                           })
                       } else {
                        CardViewScalable(indexChat: indexChat, /*height: geometry.size.height*0.80,*/ viewState: self.$viewState, indeces: self.$indeces)
                             .frame(height: geometry.size.height * 0.80)
                        .environmentObject(UserData())
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                       }
                    } // Group
                }// ForEach
            } // ZStack
                    Spacer()
         } // VStack
        } //Geometry
    }// body
}

struct OverlayCardsView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayCardsView()
        .padding()
        .environmentObject(UserData())
        .colorScheme(.dark)
    }
}
