//
//  GlowingButtonView.swift
//  MiniProjects
//
//  Created by test on 06/05/25.
//

import SwiftUI

struct GlowingButtonView: View {
    
    var text: String
    
    @State private var isAnimating: Bool =  false
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 18)
                .fill(AngularGradient(colors: [.teal, .pink,.teal], center: .center, angle: .degrees(isAnimating ? 360 : 0)))
                .frame(width: 260, height: 60)
                .blur(radius: 30)
                .onAppear {
                    withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)){
                        isAnimating = true
                    }
                }
            
            Button {
                
            } label: {
                Text(text)
                    .bold()
                    .font(.title3)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.background)
                    .frame(width: 260, height: 60)
                    .background(.red.gradient, in: .rect(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.gray, lineWidth: 1)
                    }
            }

        }
    }
}

#Preview {
    GlowingButtonView(text: "Subscribe")
}
