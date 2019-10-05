//
//  RangeView1.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 01/10/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct RangeView1: View {
       @Environment(\.colorScheme) var colorSchema: ColorScheme
       @State var prevTranslation: CGFloat = 0
       
       @Binding var chart: LinesSet
       var height: CGFloat
       var widthRange :CGFloat
       var indent: CGFloat
       
       
       private var widthRectangle1: CGFloat { widthRange * chart.lowerBound}
       private var widthImage: CGFloat { widthRange * (chart.upperBound - chart.lowerBound)}
       private var widthRectangle2: CGFloat { widthRange * (1 - chart.upperBound)}
       
       var body: some View {
        HStack (spacing: 0) {
          Rectangle()
              .frame(width:self.widthRectangle1)
              .foregroundColor(Color("ColorRangeViewTint"))
              .gesture(DragGesture(minimumDistance: 0)
                  .onChanged (onDragChangedRectangle1)
                  .onEnded { value in
                      self.prevTranslation = 0.0
                  }
          )
          
          Image(uiImage: UIImage(named: self.selectionImage)!)
              .frame(width: self.widthImage)
              .gesture(DragGesture(minimumDistance: 0)
                  .onChanged (onDragChangedImage)
                  .onEnded { value in
                      self.prevTranslation = 0.0
                  }
          )
          Rectangle()
              .frame(width: self.widthRectangle2)
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
    }// body
    private var rightBorder: CGFloat  {(chart.upperBound - chart.lowerBound)  * widthRange}
    private let defaultMinimumRangeDistance: CGFloat = 0.05
    private var numberPoints: Int {chart.xTime.count }
    private var selectionImage: String {colorSchema == ColorScheme.light ? "selection_frame_light" : "selection_frame_dark" }
    
    func onDragChangedRectangle1(gesture: DragGesture.Value) {
        let translationX = gesture.translation.width
        let locationX = gesture.location.x
        if locationX > 0 {
            
            self.chart.lowerBound =
            self.constrainedMin(byAdding: (translationX - self.prevTranslation) / self.widthRange)
            self.prevTranslation = translationX
        }
    }
    
    func onDragChangedImage(gesture: DragGesture.Value) {
        let translationX = gesture.translation.width
        let locationX = gesture.location.x
        guard translationX != 0 else {return}
        
        if  locationX > 16 && locationX  < (self.rightBorder - 16 ){
            if  !(self.chart.lowerBound == 0 && translationX < 0) &&
                !(self.chart.upperBound == 1 && translationX > 0) {
                
                self.chart.lowerBound =
                self.constrainedMin(byAdding: (translationX - self.prevTranslation) / self.widthRange)
                self.chart.upperBound =
                self.constrainedMax(byAdding: (translationX - self.prevTranslation) / self.widthRange)
            }
        }  else if locationX <  16 {
            self.chart.lowerBound =
            self.constrainedMin(byAdding: (translationX ) / self.widthRange)
        } else if locationX > (self.rightBorder - 16) {
            self.chart.upperBound =
            self.constrainedMax(byAdding: (translationX - self.prevTranslation) / self.widthRange)
            
            self.prevTranslation = translationX
        }
    }
    
    func onDragChangedRectangle2(gesture: DragGesture.Value) {
        
       let translationX = gesture.translation.width
       let locationX = gesture.location.x
       if locationX > 0 {
        self.chart.upperBound = self.constrainedMax(byAdding: (translationX - self.prevTranslation) / self.widthRange)
      }
    }
    
    private func constrainedMin(byAdding delta: CGFloat) -> CGFloat {
            return min(max(chart.lowerBound + delta, 0), chart.upperBound - defaultMinimumRangeDistance)
        }
        
    private func constrainedMax(byAdding delta: CGFloat) -> CGFloat {
        return max(min(chart.upperBound + delta, 1), chart.lowerBound + defaultMinimumRangeDistance)
        }
}

struct RangeView1_Previews: PreviewProvider {
    static var previews: some View {
        RangeView1(chart: .constant(chartsData[0]),
               height: 100,
               widthRange:  UIScreen.main.bounds.width,
               indent: 10)
    }
}
