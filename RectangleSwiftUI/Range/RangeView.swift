//
//  RangeView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 18/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct RangeView : View {
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorSchema: ColorScheme
    @State var prevTranslation: CGFloat = 0
    
    var chart: LinesSet
    var height: CGFloat
    var widthRange :CGFloat
    var indent: CGFloat
    
    private var widthRectangle1: CGFloat { widthRange * userData.charts[self.chartIndex].lowerBound}
    private var widthImage: CGFloat { widthRange * (userData.charts[self.chartIndex].upperBound - userData.charts[self.chartIndex].lowerBound)}
    private var widthRectangle2: CGFloat { widthRange * (1 - userData.charts[self.chartIndex].upperBound)}
    
    var body: some View {
        HStack (spacing: 0) {
            Rectangle()
                .frame(width:self.widthRectangle1, height: self.height, alignment: .leading)
                .foregroundColor(Color("ColorRangeViewTint"))
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged (onDragChangedRectangle1)
                    .onEnded { value in
                        self.prevTranslation = 0.0
                    }
            )
            Image(uiImage: UIImage(named: self.selectionImage)!)
                .frame(width: self.widthImage, height: self.height, alignment: .leading)
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged (onDragChangedImage)
                    .onEnded { value in
                        self.prevTranslation = 0.0
                    }
            )
            Rectangle()
                .frame(width: self.widthRectangle2, height: self.height, alignment: .leading)
                .foregroundColor(Color("ColorRangeViewTint"))
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged (onDragChangedRectangle2)
                    .onEnded { value in
                        self.prevTranslation = 0.0
                    }
            )
        } // HStack
            .frame(width: self.widthRange, height: self.height,  alignment: .topLeading)
            .overlay(GraphsForChart(chart: self.chart,rangeTime: 0..<(self.numberPoints - 1))
                .padding(self.indent)
            )
    } //body
    
    private let defaultMinimumRangeDistance: CGFloat = 0.05
       
    private var chartIndex: Int {userData.chartIndex(chart: chart)}
    private var rightBorder: CGFloat  {(userData.charts[self.chartIndex].upperBound - userData.charts[self.chartIndex].lowerBound)  * widthRange}
    private var numberLines: Int { chart.lines.count}
    private var numberPoints: Int {chart.xTime.count }
    private var selectionImage: String {colorSchema == ColorScheme.light ? "selection_frame_light" : "selection_frame_dark" }
    
    func onDragChangedRectangle1(gesture: DragGesture.Value) {
        let translationX = gesture.translation.width
        let locationX = gesture.location.x
        if locationX > 0 {
            self.userData.charts[self.chartIndex].lowerBound = self.constrainedMin(byAdding: (translationX - self.prevTranslation) / self.widthRange)
            self.prevTranslation = translationX
        }
    }
    
    func onDragChangedImage(gesture: DragGesture.Value) {
        let translationX = gesture.translation.width
        let locationX = gesture.location.x
        guard translationX != 0 else {return}
        
        if  locationX > 16 && locationX  < (self.rightBorder - 16 ){
            if  !(self.userData.charts[self.chartIndex].lowerBound == 0 && translationX < 0) &&
                !(self.userData.charts[self.chartIndex].upperBound == 1 && translationX > 0) {
                
                self.userData.charts[self.chartIndex].lowerBound = self.constrainedMin(byAdding: (translationX - self.prevTranslation) / self.widthRange)
                self.userData.charts[self.chartIndex].upperBound = self.constrainedMax(byAdding: (translationX - self.prevTranslation) / self.widthRange)
            }
        }  else if locationX <  16 {
            self.userData.charts[self.chartIndex].lowerBound = self.constrainedMin(byAdding: (translationX ) / self.widthRange)
        } else if locationX > (self.rightBorder - 16) {
            self.userData.charts[self.chartIndex].upperBound = self.constrainedMax(byAdding: (translationX - self.prevTranslation) / self.widthRange)
            
            self.prevTranslation = translationX
        }
    }
    
    func onDragChangedRectangle2(gesture: DragGesture.Value) {
       let translationX = gesture.translation.width
       let locationX = gesture.location.x
       if locationX > 0 {
         self.userData.charts[self.chartIndex].upperBound = self.constrainedMax(byAdding: (translationX - self.prevTranslation) / self.widthRange)
      }
    }
    
    private func constrainedMin(byAdding delta: CGFloat) -> CGFloat {
            return min(max(userData.charts[self.chartIndex].lowerBound + delta, 0), userData.charts[self.chartIndex].upperBound - defaultMinimumRangeDistance)
        }
        
    private func constrainedMax(byAdding delta: CGFloat) -> CGFloat {
            return max(min(userData.charts[self.chartIndex].upperBound + delta, 1), userData.charts[self.chartIndex].lowerBound + defaultMinimumRangeDistance)
        }
}

#if DEBUG
struct RangeView_Previews : PreviewProvider {
    static var previews: some View {
        RangeView(chart: chartsData[0], height: 100, widthRange:  UIScreen.main.bounds.width, indent: 10)
           .environmentObject(UserData())
    }
}
#endif
