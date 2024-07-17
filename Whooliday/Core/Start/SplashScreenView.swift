import SwiftUI
import RiveRuntime
import CoreHaptics

// spash screen, when app is launched
struct SplashScreenView: View {
    let textAnimationIntro = RiveViewModel(fileName: "introSplash")
    
    // Timer properties
    @State private var timer: Timer?
    @State var navigateToContentView = false
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    func startTypingAnimation() {
        var itr = 0
        generator.prepare()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if itr >= 2 {
                generator.impactOccurred()
            }
            if itr >= 40 {
                navigateToContentView = true
                timer.invalidate()
            } else {
                itr += 1
            }
        }
    }
    
    var body: some View {
        Group {
            if navigateToContentView {
                ContainerView()
            } else {
                textAnimationIntro.view()
                    .onAppear {
                        startTypingAnimation()
                        textAnimationIntro.play()
                    }
                    .ignoresSafeArea()
            }
        }
        .accessibilityIdentifier("SplashScreenView")
    }
}

#Preview {
    SplashScreenView()
}
