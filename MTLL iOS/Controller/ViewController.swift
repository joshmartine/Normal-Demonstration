// jm

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    private var menuState: Int! //1 = opened, 0 = closed
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet var coreRenderer: CoreRenderer!
    
    @IBOutlet var horizontalViewDistanceSlider: UISlider!
    @IBOutlet var verticalViewDistanceSlider: VerticalSlider!
    @IBOutlet var horizontalSliderSafetyArea: UIView!
    @IBOutlet var verticalSliderSafetyArea: UIView!
    
    //MARK: - Menu
    @IBOutlet var menu: UIView!
    @IBOutlet var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuState = 0
                
        verticalViewDistanceSlider.slider.addTarget(self, action: #selector(handleVerticalMovement(_:)), for: .valueChanged)
        
        self.view.sendSubviewToBack(horizontalSliderSafetyArea)
        self.view.sendSubviewToBack(verticalSliderSafetyArea)
        
        mtll_application.view.updateProjectionMatrix()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleHorizontalMovement(_ sender: UISlider) {
        mtll_application.notify(self, "camera.position", [0, sender.value])
    }
    
    @IBAction func handleVerticalMovement(_ sender: UISlider) {
        mtll_application.notify(self, "camera.position", [1, sender.value])
    }
    
    @IBAction func handleRotations(_ sender: PanGestureRecognizer) {
        let touchDownPointHoriz = sender.touchBegin.location(in: self.horizontalSliderSafetyArea)
        let touchDownPointVert = sender.touchBegin.location(in: self.verticalSliderSafetyArea)
        let horizontalBarHit = self.horizontalSliderSafetyArea.bounds.contains(touchDownPointHoriz)
        let verticalBarHit = self.verticalSliderSafetyArea.bounds.contains(touchDownPointVert)
        if !horizontalBarHit && !verticalBarHit {
            let translation = sender.translation(in: self.view)
            mtll_application.notify(self, "camera.rotate", [Float(-translation.x / 500.0), Float(translation.y / 500.0)])
        }
    }
    
    @IBAction func moveMenu(_ sender: UIButton) {
        if menuState == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.menu.center = CGPoint(x: self.menu.center.x, y: 16)
                self.menuBtn.center = CGPoint(x: self.menuBtn.center.x, y: 48)
            })
            menuState = 1
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.menu.center = CGPoint(x: self.menu.center.x, y: -32)
                self.menuBtn.center = CGPoint(x: self.menuBtn.center.x, y: 16)
            })
            menuState = 0
        }
    }
    
    @IBAction func resetCamera(_ sender: UIButton) {
        horizontalViewDistanceSlider.value = -30
        verticalViewDistanceSlider.slider.value = 0
        mtll_application.notify(self, "camera.reset", [])
    }
    
    @IBAction func rotateModel(_ sender: UIButton) {
        mtll_application.notify(self, "model.rotate", [0])
    }
}

