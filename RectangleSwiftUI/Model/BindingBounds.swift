//
//  BindingPounds.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 17/07/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI
import Combine

final class Bounds: BindableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
    var lower: CGFloat = 0.3 {
        didSet {
            willChange.send()
        }
    }
    
    var  upper: CGFloat = 0.8 {
        didSet {
            willChange.send()
        }
    }
    
}
