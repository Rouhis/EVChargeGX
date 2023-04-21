//
//  DeBouncer.swift
//  EVChargeGX
//
//  Created by iosdev on 20.4.2023.
//

import Foundation

class Debouncer {
    let delay: TimeInterval
    var timer: Timer?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func debounce(_ action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
}
