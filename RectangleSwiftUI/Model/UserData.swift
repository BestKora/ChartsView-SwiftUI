/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

import Combine
import SwiftUI

final class UserData: BindableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
    var charts = chartsData {
        didSet {
            willChange.send()
        }
    }
    
    func chartIndex(chart: LinesSet ) -> Int {
           return charts.firstIndex(where: { $0.id == chart.id })!
       }
}


