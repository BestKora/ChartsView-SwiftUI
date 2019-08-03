//
//  RangeViewNew.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 15/07/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

enum DragInfo {
    case inactive
    case active(translation: CGSize, location: CGPoint)
    
    var translation: CGSize {
        switch self {
        case .inactive :
            return .zero
        case .active(let t, _):
            return t
        }
    }
    
    var location: CGPoint {
        switch self {
        case .inactive :
            return .zero
        case .active(_ , let l):
            return l
        }
    }
    var isActive:Bool {
        switch self {
        case .inactive: return false
        case .active: return true
        }
    }
}

struct RangeViewNew : View {
    @State var prevTranslation: CGFloat = 0
    @ObjectBinding var bounds: Bounds
    
    var widthRange :CGFloat
    var height: CGFloat
    
    let defaultMinimumRangeDistance: CGFloat = 0.05

    var widthRectangle1: CGFloat { widthRange * bounds.lower}
    var widthImage: CGFloat {
      let width = ( bounds.upper - bounds.lower ) * widthRange
        return width
    }
    var widthRectangle2: CGFloat {
        let width = (1 - bounds.upper) *  widthRange
         return width
    }
    
    func constrainedMin(byAdding delta: CGFloat) -> CGFloat {
        let lower =  min(max(bounds.lower + delta, 0), bounds.upper - defaultMinimumRangeDistance)
        return lower
    }
    
    func constrainedMax(byAdding delta: CGFloat) -> CGFloat {
        return max(min(bounds.upper + delta, 1), bounds.lower + defaultMinimumRangeDistance)
    }
    
    var body: some View {
        let gesture1 = DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        if  !(self.bounds.lower == 0 && value.translation.width < 0) &&
                            !(self.bounds.upper == 1 && value.translation.width > 0) {
                            self.bounds.lower = self.constrainedMin(byAdding: (value.translation.width  -  self.prevTranslation) / self.widthRange )
                            self.prevTranslation = value.translation.width
                        }
                }
               .onEnded { value in
                    self.prevTranslation = 0.0
                }
        
        let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
       .onChanged { value in
        
            if  !(self.bounds.lower == 0 && value.translation.width < 0) &&
                !(self.bounds.upper == 1 && value.translation.width > 0) {
            self.bounds.upper = self.constrainedMax(byAdding: value.translation.width / self.widthRange)
            self.bounds.lower = self.constrainedMin(byAdding: value.translation.width / self.widthRange )
            }
        }
  
        let gesture2 = DragGesture(minimumDistance: 0, coordinateSpace: .local)
        .onChanged { value in
            
            if  !(self.bounds.lower == 0 && value.translation.width < 0) &&
                !(self.bounds.upper == 1 && value.translation.width > 0) {
                 self.bounds.upper = self.constrainedMax(byAdding: value.translation.width / self.widthRange)
            }
        }
        
        return VStack{
            HStack (spacing: 0){
            Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(width: widthRectangle1, height: self.height)
                    .gesture(gesture1)
                
            Rectangle()
                .frame(width: widthImage, height: self.height)
                .gesture(gesture)
                
            Rectangle()
                .foregroundColor(Color.red)
                .frame(width: widthRectangle2, height: self.height)
                .gesture(gesture2)
            }
            Text("\(bounds.upper - bounds.lower)")
        }
    } //body
}

#if DEBUG
struct RangeViewNew_Previews : PreviewProvider {
    static var previews: some View {
        RangeViewNew(bounds: Bounds(), widthRange: UIScreen.main.bounds.width, height: 100 )
    }
}
#endif

 /*      .updating($dragInfo) { (value, dragInfo, _) in
               dragInfo = .active(translation: value.translation, location: value.location)
       }
*/
