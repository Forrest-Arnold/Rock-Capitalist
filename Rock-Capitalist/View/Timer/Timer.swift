import SwiftUI

class TimerManager: ObservableObject {
    
    @Published var counter: Double = 0.0
    var timer: Timer?

    func startTimer() {
        timer?.invalidate() // Ensure any existing timer is stopped
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.counter < 3.0 {
                self.counter += 0.01
            } else {
                self.counter = 0.0 // Reset when it reaches 3
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        stopTimer()
    }
}
