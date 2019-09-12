//
//  BindingPounds.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 17/07/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI
import Combine

@propertyWrapper
struct UnitRange <Value: FloatingPoint>: Equatable {
    var range : ClosedRange<Value>
    var defaultMinimumRangeDistance: Value
    
    init(initialValue range : ClosedRange<Value>, _ defaultMinimumRangeDistance: Value){
        precondition( range.lowerBound <= range.upperBound)
        self.range = range
        self.defaultMinimumRangeDistance = defaultMinimumRangeDistance
    }
    
    var wrappedValue: ClosedRange<Value>{
        get{range}
        set{
            let newUpper = newValue.upperBound
            let newLower = newValue.lowerBound
            guard newUpper >= 0 && newLower >= 0 else { return }
            
            let deltaUpper = newUpper - range.upperBound
            let deltaLower = newLower - range.lowerBound
            guard deltaLower != 0 || deltaUpper != 0 else {return}
            
            let translationX = deltaUpper != 0 ? deltaUpper : deltaLower
            guard !(range.lowerBound  == 0 && translationX < 0) &&
                !( range.upperBound == 1 && translationX > 0) else { return }
            
            if (newUpper - newLower) >= defaultMinimumRangeDistance {
                let lower =  min(max(newLower, 0), newUpper - defaultMinimumRangeDistance)
                let upper =  max(min( newUpper , 1), newLower + defaultMinimumRangeDistance)
                let rangeNew = lower...upper
                return range = /*lower...upper */rangeNew
 
              } else if (newLower + defaultMinimumRangeDistance) < 1 {
                 let rangeNew = newLower...(newLower + defaultMinimumRangeDistance)
                return range = rangeNew/*newLower...(newLower + defaultMinimumRangeDistance)*/
            } else {
                 let rangeNew = (newUpper - defaultMinimumRangeDistance)...newUpper
                return range = rangeNew /*(newUpper - defaultMinimumRangeDistance)...newUpper*/
            }
        }
    }
}

final class Bounds: ObservableObject {
   let objectWillChange = PassthroughSubject<Void, Never>()

    @UnitRange (initialValue:0.3...0.8, 0.05) var range: ClosedRange <CGFloat>  {
                   willSet {
                       objectWillChange.send()
                   }
               }
}
