//
//  CheckMarksViewNewView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 28/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CheckMarksView : View {
    @EnvironmentObject var userData: UserData
    
    var chart: LinesSet
    var height: CGFloat
    var width: CGFloat
    
    private var chartIndex: Int { userData.charts.firstIndex(where: { $0.id == chart.id })! }
    private func lineInex(line: Line) -> Int {
        userData.charts[chartIndex].lines.firstIndex(where: { $0.id == line.id})!
    }
    private func colorFor(indexLine: Int) -> Color {
        let colorLine = userData.charts[chartIndex].lines[indexLine].color!
        return Color(uiColor: colorLine)
    }
    var body: some View {
        HStack (alignment: .top) {
            ForEach( chart.lines){ line in
                Group  {
                    HStack(alignment: .bottom) {
                        Image(systemName: !self.userData.charts[self.chartIndex].lines[self.lineInex(line: line)].isHidden ? "checkmark" : "square")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .leading)
                            .foregroundColor(.white)
                        
                        Text(self.userData.charts[self.chartIndex].lines[self.lineInex(line: line)].title!)
                            .foregroundColor(!self.userData.charts[self.chartIndex].lines[self.lineInex(line: line)].isHidden ? Color.white : self.colorFor(indexLine: self.lineInex(line: line)))
                    }
                    .font(.body)
                } // Group
                    .frame(height: 10, alignment: .leading)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 4).foregroundColor(self.colorFor(indexLine: self.lineInex(line: line))))
                  //  .border(self.colorFor(indexLine: self.lineInex(line: line)), width: 4, cornerRadius: 10)
                    .background(!self.userData.charts[self.chartIndex].lines[self.lineInex(line: line)].isHidden ? self.colorFor(indexLine: self.lineInex(line: line)) : .white)
                    .cornerRadius(10)
                    .onTapGesture (count:1){
                        self.userData.charts[self.chartIndex].lines[self.lineInex(line: line)].isHidden.toggle()
                    }
            }
        }
        .frame(width: width, height: height,  alignment: .topLeading)
        
    } // body
}

#if DEBUG
struct CheckMarksView_Previews : PreviewProvider {
    static var previews: some View {
        CheckMarksView(chart: chartsData[0], height: 40, width: UIScreen.main.bounds.width)
            .environmentObject(UserData())
    }
}
#endif
