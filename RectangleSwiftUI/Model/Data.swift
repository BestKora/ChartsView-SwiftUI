/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import Foundation
import UIKit
import SwiftUI

let columns: [ChartElement] = load("chart.json")
let chartsData : [LinesSet]  =  addID( charts: columns.compactMap { convertToInternalModel($0)})
 
/* let columns: ChartElement = load("overview.json")
 let chartsData : [LinesSet]  =  addID( charts: [columns].compactMap { convertToInternalModel($0)})
 */

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func addID(charts : [LinesSet] ) -> [LinesSet] {
    var i = 0
    var newCharts = [LinesSet]()
    for chart in charts {
        var newChart = chart
        newChart.id = i
        newChart.lowerBound = 0.3
        newChart.upperBound = 0.8
        newCharts.append(newChart)
        i += 1
    }
    return newCharts
}
func convertToInternalModel(_ chatti: ChartElement ) -> LinesSet {
    var nameLine = ""
    var values = [Int]()
    var graph = LinesSet()
    var lines = [Line] ()
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en-US")
    dateFormatter.setLocalizedDateFormatFromTemplate("MMM d yyyy")
    
    for line in chatti.columns {
        for element in line {
            switch element {
            case .integer(let value): values.append(value)
            case .string(let name): nameLine = name
            }
        }
        switch nameLine  {
        case "x":
            graph.namex = "x"
            graph.xTime = values.map{ dateFormatter.string (
                from:Date(timeIntervalSince1970: TimeInterval($0/1000))
                )
            }
        case "y0" :
            lines.append(Line(id: lines.count,
                              title: chatti.names.y0,
                              points: values,
                              color: chatti.colors.y0.hexStringToUIColor(),
                              isHidden: false,
                              type: chatti.types.y0,
                              minY: values.min(),
                              maxY: values.max(),
                              countY: values.count))
        case "y1" :
            lines.append(Line(id: lines.count,
                              title: chatti.names.y1,
                              points: values,
                              color: chatti.colors.y1.hexStringToUIColor(),
                              isHidden: false,
                              type: chatti.types.y1,
                              minY: values.min(),
                              maxY: values.max(),
                              countY: values.count))
        case "y2" :
            lines.append(Line(id: lines.count,
                              title: chatti.names.y2,
                              points: values,
                              color: chatti.colors.y2 != nil ? chatti.colors.y2!.hexStringToUIColor() : nil,
                              isHidden: false,
                              type: chatti.types.y2,
                              minY: values.min(),
                              maxY: values.max(),
                              countY: values.count))
        case "y3" :
            lines.append(Line(id: lines.count,
                              title: chatti.names.y3,
                              points: values,
                              color: chatti.colors.y3 != nil ? chatti.colors.y3!.hexStringToUIColor() : nil,
                              isHidden: false,
                              type: chatti.types.y3,
                              minY: values.min(),
                              maxY: values.max(),
                              countY: values.count))
        default: break
        }
        nameLine = ""
        values = [Int]()
        
    }
    graph.colorX = chatti.colors.x != nil ? chatti.colors.x!.hexStringToUIColor() : nil
    graph.lines = lines
    return graph
}

extension String {
    
    func hexStringToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension Color {
    public init(uiColor: UIColor) {
        let r, g, b, a: Double
        
                    r = Double(uiColor.rgba.red)
                    g = Double(uiColor.rgba.green)
                    b = Double(uiColor.rgba.blue)
                    a = Double(uiColor.rgba.alpha)
                    
                    self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

