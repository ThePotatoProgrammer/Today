//
//  CAGradientLayer+ListStyle.swift
//  Today
//
//  Created by Joshua Baker on 4/29/22.
//

import UIKit

extension CAGradientLayer {
    // TODO: think more about this.
    static func gradientLayer(for style: ReminderListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
    }
    
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
            case .today:
                beginColor = .systemTeal
                endColor = .blue
            case .future:
                beginColor = .orange
                endColor = .red
            case .all:
                beginColor = .purple
                endColor = .blue
        }
        
        return [
            beginColor.cgColor,
            endColor.cgColor
        ]
    }
}
