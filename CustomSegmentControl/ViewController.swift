//
//  ViewController.swift
//  CustomSegmentControl
//
//  Created by BCL-Device-12 on 5/6/23.
//

import UIKit
import ColorSync

class ViewController: UIViewController{
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var onOffLabel: UILabel!
    
    private var secondSegmentView:CustomSegmentControl?
    private var firstSegmentView:CustomSegmentControlBC?
    private var radiusSegmentView:CustomRadiusSC?
    
    private let greenColor = UIColor(named: "greenColor")
    private let firstSegmentTitles = ["On","Off","On","Off","On","Off","On","Off"]
    private let secondSegmentTitles = ["Forever","5 times","10 times","15 times","On","Off","On","Off"]
    
    let numberOfSegment = 4
    var secSegmentCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onOffLabel.backgroundColor = greenColor
        onOffLabel.layer.cornerRadius = onOffLabel.bounds.height / 4
        onOffLabel.clipsToBounds = true

        self.setupFirstSegment()
        self.setupSecondSegment()
        self.setupRadiusSegment()
        
    }
    
    func setupFirstSegment(){
        firstSegmentView = CustomSegmentControlBC.init(frame: CGRect(x: 20, y: 200,
                                                                  width: 380,
                                                                  height: 40),
                                                    segment: numberOfSegment,
                                                    background: .cyan,
                                                    cornerRadius: 10.0,
                                                    moveViewColor: .blue,
                                                    buttonTitles: firstSegmentTitles,
                                                    sepLineCol:.orange,
                                                    sepLineW: 1.0)
        
        firstSegmentView?.delegate = self
        firstSegmentView?.allButton[0].setTitleColor(.white, for: .normal)
        firstSegmentView?.allButton[0].titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        firstSegmentView?.center.x = view.center.x
        view.addSubview(firstSegmentView!)
        onOffLabel.text = secondSegmentTitles[0]
    }

    
    func setupSecondSegment(){
        secondSegmentView = CustomSegmentControl.init(frame: CGRect(x: 20, y: 400,
                                                                  width: 380,
                                                                  height: 40),
                                                    segment: numberOfSegment,
                                                    background: .white,
                                                    cornerRadius: 10.0,
                                                    moveViewColor: .orange,
                                                    buttonTitles: secondSegmentTitles,
                                                    sepLineCol:.orange,
                                                    sepLineW: 1.0,
                                                    borderCol: .orange,
                                                    borderW: 1.0)
        secondSegmentView?.delegate = self
        secondSegmentView?.allButton[0].setTitleColor(.white, for: .normal)
        secondSegmentView?.allButton[0].titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        secondSegmentView?.center.x = view.center.x
        view.addSubview(secondSegmentView!)
        onOffLabel.text = secondSegmentTitles[0]
    }
    
    
    func setupRadiusSegment(){
        radiusSegmentView = CustomRadiusSC.init(frame: CGRect(x: 20, y: 300,
                                                                  width: 300,
                                                                  height: 40),
                                                    segment: numberOfSegment,
                                                    background: .orange,
                                                    cornerRadius: 20.0,
                                                    moveViewColor: .blue,
                                                    buttonTitles: firstSegmentTitles)
        radiusSegmentView?.delegate = self
        radiusSegmentView?.allButton[0].setTitleColor(.white, for: .normal)
        radiusSegmentView?.allButton[0].titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        radiusSegmentView?.center.x = view.center.x
        view.addSubview(radiusSegmentView!)
        onOffLabel.text = firstSegmentTitles[0]
    }
    
    
    
    @IBAction func clickToChangedState(_ sender: UIButton) {
        
        guard let segmentView = secondSegmentView else{return}

        secSegmentCount = segmentView.segmentIndex
        
        if segmentView.allButton.count == secSegmentCount + 1 {
            secSegmentCount = 0
            segmentView.didTapSegmentButton((segmentView.allButton[secSegmentCount]))
            return
        }
        
        secSegmentCount = segmentView.segmentIndex + 1
        segmentView.didTapSegmentButton((segmentView.allButton[secSegmentCount]))
        
        secSegmentCount += 1

    }
}



//MARK: ALL SEGMENT DELEGATE

extension ViewController: CustomSegmentControlDelegate{
    func didChangeSegment(_ index: Int) {
        print("index = ", index)
        
        if index%2 == 0{
            onOffLabel.backgroundColor = greenColor
        }else{
            onOffLabel.backgroundColor = .red
        }
        onOffLabel.text = secondSegmentTitles[index]
        
    }
    
}


extension ViewController: CustomSegmentControlBCDelegate{
    func didChangeSegmentButton(_ index: Int) {        
        if index%2 == 0{
            onOffLabel.backgroundColor = greenColor
        }else{
            onOffLabel.backgroundColor = .red
        }
        onOffLabel.text = firstSegmentTitles[index]
        
    }
}

extension ViewController:  CustomRadiusSCDelegate {
    func didChangeCustomRadiusSC(_ index: Int) {
        if index%2 == 0{
            onOffLabel.backgroundColor = greenColor
        }else{
            onOffLabel.backgroundColor = .red
        }
        onOffLabel.text = firstSegmentTitles[index]
        

    }
}




extension UIColor {
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                    b = CGFloat(hexNumber & 0x0000FF) / 255.0
                    a = 1.0
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


/*
extension UIColor {
    static func gradientColor(fromHex startHex: String, toHex endHex: String, withBound bound: CGFloat) -> UIColor? {
        guard let startColor = UIColor(hexString: startHex), let endColor = UIColor(hexString: endHex) else {
            return nil
        }
        
        let startComponents = startColor.cgColor.components
        let endComponents = endColor.cgColor.components
        
        guard let start = startComponents, let end = endComponents else {
            return nil
        }
        
        let interpolatedRed = start[0] + (end[0] - start[0]) * bound
        let interpolatedGreen = start[1] + (end[1] - start[1]) * bound
        let interpolatedBlue = start[2] + (end[2] - start[2]) * bound
        let interpolatedAlpha = start[3] + (end[3] - start[3]) * bound
        
        return UIColor(red: interpolatedRed, green: interpolatedGreen, blue: interpolatedBlue, alpha: interpolatedAlpha)
    }
}

*/
