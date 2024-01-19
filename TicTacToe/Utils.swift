//
//  Utils.swift
//  TicTacToe
//
//  Created by Nick Schaefer on 11/13/23.
//

import SwiftUI

func indexOfContainingRect(point: CGPoint, in rects: [CGRect?]) -> Int? {
    for (index, rect) in rects.enumerated() {
        if rect!.contains(point) {
            return index
        }
    }
    return nil
}
