//
//  BackgroundView.swift
//  widgetExtension
//
//  Created by Alex on 10/29/20.
//

import WidgetKit
import SwiftUI
import Intents

struct xBackgroundView: View {
    var model: xBackgroundModel
    var body: some View {
        var fillColor = model.type == 0 ? LinearGradient(gradient: Gradient(colors: [model.color, model.color]), startPoint: .topLeading, endPoint: .bottomTrailing)
        : model.type == 1 ? LinearGradient(gradient: Gradient(colors: [model.color, model.color1]), startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)

        Rectangle()
            .fill(fillColor)
            .overlay(
                ZStack {
                    if (model.type > 1) {
                        model.image.resizable().scaledToFit()
//                            .aspectRatio(contentMode: .fit)
                    } else{
                        Spacer()
                    }
                }
            )
    }
}
