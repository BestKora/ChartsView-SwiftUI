//
//  OverlayCardsView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 19/09/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct OverlayCardsView: View {
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
        GeometryReader { geometry in
                VStack{
                   ZStack{
                       ForEach(self.indeces.reversed(), id: \.self){ indexChat in
                    Group {
                       if self.indexOfIndeces(forElement: indexChat) == 0 {
                           CardView(chart: self.userData.charts[indexChat])
                             //  .environmentObject(UserData())
                            .frame(height: geometry.size.height*0.80 )
                               .offset(y: self.yOffset(forElement: indexChat) )
                               .scaleEffect(1.0 - CGFloat(self.indeces.firstIndex(of: indexChat)!/*self.indexOfIndeces(forElement: indexChat)*/) * 0.03 + CGFloat(self.scaleResistance()))
                               
                               .gesture(LongPressGesture(minimumDuration: 0.1)
                                        .sequenced(before:
                                           DragGesture()
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
                                         ) // sequenced
                               )
                               .simultaneousGesture(TapGesture(count: 1).onEnded({ _ in
                                   self.presentedCard =  self.userData.charts[indexChat]
                                          }))
                               
                           .sheet(item: self.$presentedCard, onDismiss: {
                               self.presentedCard = nil
                           }, content: { card in
                               NavigationView {
                                VStack {
                                  ChartView(chart: card)
                                   .frame(height: geometry.size.height*0.9)
                                   .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.primary))
                                    Spacer()
                               }
                               }
                               .navigationViewStyle(StackNavigationViewStyle())
                               .environmentObject(UserData())
                               .colorScheme(self.colorSchema)
                           })
                       
                       } else {
                           CardView(chart: self.userData.charts[indexChat])
                             .frame(height:  geometry.size.height*0.8 )
                             .offset(y: self.yOffset(forElement: indexChat) )
                             .scaleEffect(1.0 - CGFloat(self.indeces.firstIndex(of: indexChat)!) * 0.03 + CGFloat(self.scaleResistance()))
                             .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                       }
                       } // Group
                       }// ForEach
                   } // ZStack
                    Spacer()
                   } // VStack
        } //Geometry
    }// body
    private func scaleResistance() -> Double {
     Double(UIScreen.main.bounds.width) / 6800
    }
}

struct OverlayCardsView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayCardsView()
        .environmentObject(UserData())
                   .colorScheme(.dark)
    }
}
