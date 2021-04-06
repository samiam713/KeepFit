//
//  LoadingAnimation.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/31/21.
//

import SwiftUI

struct LoadingAnimationView: View {
    
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            BlurView(effect: .systemUltraThinMaterial)
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 14)
                        .frame(width: 100, height: 100)
                    Circle()
                        .trim(from: 0, to: 0.2)
                        .stroke(Color.green, lineWidth: 7)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .onAppear() {
                            self.isLoading = true
                        }
                    Image(systemName: "network")
                        .font(.title)
                }
                KeepFitLogoView()
                Text("We'll be with you shortly")
                    .italic()
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    init(effect: UIBlurEffect.Style){
        self.effect = effect
    }
    let effect: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView(effect: UIBlurEffect(style: effect)) }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {}
}

struct LoadingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimationView()
    }
}
