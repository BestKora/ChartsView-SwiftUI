//
//  RangeViewNew.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 15/07/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

/*enum DragRectangle {
    case left
    case middle
    case rignt
}
 */
    
struct RangeViewNew : View {
    @State var prevTranslation: CGFloat = 0
    @ObservedObject var bounds: Bounds
    @EnvironmentObject var userData: UserData
    
    var widthRange :CGFloat
    var height: CGFloat
    var chart: LinesSet
    var index: Int {
          userData.charts.firstIndex(where: { $0.id == chart.id })!
      }
    
    func rangeTimeFor(indexChat: Int) -> Range<Int> {
           let numberPoints = userData.charts[indexChat].xTime.count
        let rangeTime: Range<Int>  = Int(userData.charts[indexChat].range.lowerBound * CGFloat(numberPoints - 1))..<Int(userData.charts[indexChat].range.upperBound * CGFloat(numberPoints - 1))
           return rangeTime
       }
    let defaultMinimumRangeDistance: CGFloat = 0.05

    var widthRectangle1: CGFloat { /*bounds*/userData.charts[0].range.lowerBound * widthRange}
    var widthImage: CGFloat { (/*bounds*/userData.charts[0].range.upperBound - /*bounds*/userData.charts[0].range.lowerBound ) * widthRange}
    var widthRectangle2: CGFloat { (1 - /*bounds*/userData.charts[0].range.upperBound) *  widthRange}

    var body: some View {
        let gesture1 = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let translationX = value.translation.width
                let upper = /* self.bounds*/self.userData.charts[0].range.upperBound
                var lower = /*self.bounds*/self.userData.charts[0].range.lowerBound
             
                lower =  lower + (translationX  -  self.prevTranslation) / self.widthRange
                    self.prevTranslation = translationX
                    if !(((upper - lower) < self.defaultMinimumRangeDistance) && translationX > 0){
                        /*self.bounds*/self.userData.charts[0].range  =  lower...upper
                        
                    }
        }
       .onEnded { value in
            self.prevTranslation = 0.0
        }
 
        
        let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let translationX = value.translation.width
                var upper =  /*self.bounds*/self.userData.charts[0].range.upperBound
                var lower = /*self.bounds*/self.userData.charts[0].range.lowerBound
           
                    upper = upper + translationX / self.widthRange
                    lower = lower + translationX / self.widthRange
                /*self.bounds*/self.userData.charts[0].range  =  lower...upper
        }
        
        let gesture2 = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let translationX = value.translation.width
                var upper = /* self.bounds*/self.userData.charts[0].range.upperBound
                let lower = /*self.bounds*/self.userData.charts[0].range.lowerBound
                
                    upper = upper + translationX / self.widthRange
                    if !(((upper - lower) < self.defaultMinimumRangeDistance) && translationX < 0){
                        /*self.bounds*/self.userData.charts[0].range  =  lower...upper
                    }
        }
        
        return VStack{
            //--------
             GraphsForChart(chart: self.userData.charts[self.index], rangeTime: self.rangeTimeFor (indexChat: self.index), lineWidth : 2)
            //--------
            HStack (spacing: 0){
            Rectangle()
                    .frame(width: widthRectangle1, height: self.height)
                    .foregroundColor(Color.blue)
                    .gesture(gesture1)
                
            Rectangle()
                .frame(width: widthImage, height: self.height)
                .gesture(gesture)
                
            Rectangle()
                .frame(width: widthRectangle2, height: self.height)
                .foregroundColor(Color.red)
                .gesture(gesture2)
            }
            Text("\(/*bounds*/userData.charts[0].range.upperBound)")
            Text("\(/*bounds*/userData.charts[0].range.lowerBound )")
           
        }
    } //body
}

#if DEBUG
struct RangeViewNew_Previews : PreviewProvider {
    static var previews: some View {
        RangeViewNew(bounds: Bounds(), widthRange: UIScreen.main.bounds.width, height: 100, chart: chartsData[0] )
      //   .environmentObject(Bounds())
        .environmentObject(UserData())
    }
}
#endif

