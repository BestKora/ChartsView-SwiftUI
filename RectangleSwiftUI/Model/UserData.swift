/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

//import Combine

import SwiftUI

final class UserData: ObservableObject{
    @Published var charts = chartsData

    func chartIndex(chart: LinesSet ) -> Int {
           return charts.firstIndex(where: { $0.id == chart.id })!
       }
}

/*
   let objectWillChange = PassthroughSubject<Void, Never>()

      @UnitRange (initialValue:0.3...0.8, 0.05) var range: ClosedRange <CGFloat>  {
                     willSet {
                         objectWillChange.send()
                     }
                 }
   */
