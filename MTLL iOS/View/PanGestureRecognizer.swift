// jm

import UIKit.UIGestureRecognizerSubclass

class PanGestureRecognizer: UIPanGestureRecognizer {
    private(set) public var touchBegin: UITouch!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        touchBegin = touches.first
    }
}
