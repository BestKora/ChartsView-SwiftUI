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
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    @EnvironmentObject var userData: UserData
    
    var indexChart: Int
    
    private var cardBackgroundColor: Color {
        colorSchema == ColorScheme.light ?
            Color(white: 0.97) : Color.black
    }
    
    var body: some View {
        ZStack {
            self.cardBackgroundColor
            ChartView(chart: self.userData.charts[self.indexChart])
               .padding(.top)
        }
         .border(Color.secondary, width: 3, cornerRadius: 25)// VStack
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
    @State var indeces = [0,1,2,3,4]
  
    func indexOfIndeces(forElement: Int) -> Int {
        return indeces.firstIndex(of: forElement)!
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    ForEach(indeces.reversed()){ indexChat in
                        Card(indexChart: indexChat)
                            .frame(height: 600)
                            .offset(y: CGFloat(33 * (self.indeces.count -  self.indexOfIndeces(forElement: indexChat) - 1)))
                            .animation(.easeInOut(duration: 0.6))
                            .tapAction {
                                self.indeces.rearrange(from: self.indexOfIndeces(forElement: indexChat), to: 4)
                        }
                    }// ForEach
                } // ZStack
                Spacer()
                } // VStack
                .navigationBarTitle(Text("Followers"), displayMode: .inline)
        }
    }
}
struct ContentView : View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        // ListCardsView ()
         HStackCardsView ()
        // OverlayStackView ()
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
