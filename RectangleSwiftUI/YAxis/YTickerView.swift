
import SwiftUI

struct YTickerView : View {
    
    var chart: LinesSet
    var rangeTime: Range<Int>
    var colorYAxis: Color
    var colorYMark: Color
    
    var estimatedMarksNumber = 6
    
    var rangeY : Range<Int>? {
        let rangeY = rangeOfRanges(chart.lines.filter{!$0.isHidden}.map {$0.points[rangeTime].min()!..<$0.points[rangeTime].max()!})
        return rangeY == 0..<0 ? 0..<1 : rangeY
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                ForEach(self.calcScale(height: geometry.size.height).marks.reversed(), id:\.self){ mark in
                    YMarkView(yValue: mark, colorYAxis: self.colorYAxis, colorYMark: self.colorYMark)
                } // ForEach
                .frame(width: geometry.size.width,
                       height:  self.calcScale(height: geometry.size.height).stepYHeight,
                       alignment: .leading)
                .offset(y:( self.calcScale(height: geometry.size.height).scaleY * CGFloat(self.rangeY!.upperBound -  self.calcScale(height: geometry.size.height).marks.last!)))
                    .animation(.easeInOut(duration: 0.6))
            } //VStack
            .transition(.moveAndFadeMarks)
            
        } //Geometry
         .overlay(YAxisView(color: self.colorYAxis))
    }
    
    private func calcScale(height: CGFloat) -> (scaleY :CGFloat,stepYHeight: CGFloat, marks: [Int]  ){
            
            let scaleY :CGFloat  = height / CGFloat(rangeY!.distance)
            let stepYHeight: CGFloat = height / CGFloat((0..<estimatedMarksNumber).distance - 1)
            let stepYValue: CGFloat = stepYHeight / scaleY
            var marks = [Int]()
            for i in 0..<estimatedMarksNumber{
                marks.append(rangeY!.lowerBound + Int(stepYValue) * i)
            }
            
            return (scaleY: scaleY, stepYHeight:  CGFloat(Int(stepYValue)) * scaleY, marks: marks)
        }
}

struct YTickerView_Previews : PreviewProvider {
    static var previews: some View {
        YTickerView(chart: chartsData[0], rangeTime: 0..<(chartsData[0].xTime.count - 1),
                    colorYAxis: Color.red,
                    colorYMark: Color.blue)
            .frame(height: 500)
        
    }
}
