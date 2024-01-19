//
//  NumberView.swift
//  TicTacToe
//
//  Created by Nick Schaefer on 11/13/23.
//

import SwiftUI

struct NumberView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    @State var dragOffset = CGSize(width: 0, height: 0)
    @State var dragNumber: Int?
    
    var body: some View {
        HStack {
            Spacer()
            
            ForEach(viewModel.availableNumbers, id: \.self) { numText in
                Text("\(numText)")
                    .font(.custom("Futura-Bold", size: 18))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.gray))
                    .foregroundStyle(.white)
                    .offset(dragNumber == Int(numText) ? dragOffset : CGSize(width: 0, height: 0))
                    .gesture(DragGesture(coordinateSpace: .global)
                        .onChanged({ value in
                            dragNumber = Int(numText)
                            let translation = value.translation
                            dragOffset = CGSize(width: translation.width + 30, height: translation.height)
                            
                            if let dropIndex = indexOfContainingRect(point: value.location, in: viewModel.spaceRects), viewModel.moves[dropIndex] == nil {
                                print(dropIndex, value.location)
                                print(viewModel.spaceRects[0]!)
                            }
                        })
                            .onEnded({ value in
                                Task {
                                    if let dropIndex = indexOfContainingRect(point: value.location, in: viewModel.spaceRects), viewModel.moves[dropIndex] == nil {
                                        viewModel.handlePlayerMove(moveIndex: dropIndex, piece: "\(numText)")
                                    } else {
                                        await animate(duration: 0.3) {
                                            dragOffset = CGSize(width: 0, height: 0) }
                                    }
                                }
                                
                                dragNumber = nil
                            })
                    )
                Spacer()
            }
        }
        .zIndex(3)
    }
}

#Preview {
    NumberView()
}
