//
//  DonutChartView.swift
//  PayMe
//
//  Created by user244521 on 9/29/23.
//

import SwiftUI

struct DonutChartView: View {
    let data: [(Double, Color)] // Data for the donut chart

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    DonutSliceView(data: data[index], geometry: geometry)
                }
            }
        }
    }
}

struct DonutSliceView: View {
    let data: (Double, Color) // Data for a single donut slice
    let geometry: GeometryProxy

    var body: some View {
        let (percentage, color) = data
        let radius = min(geometry.size.width, geometry.size.height) * 0.4

        let startAngle = Angle(degrees: 0)
        let endAngle = Angle(degrees: 360 * percentage)

        return Path { path in
            path.addArc(
                center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )

            path.addArc(
                center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                radius: radius * 0.6,
                startAngle: endAngle,
                endAngle: startAngle,
                clockwise: true
            )

            path.closeSubpath()
        }
        .fill(color)
    }
}
