//
//  CustomSegmentControl.swift
//  CustomSegmentControl
//
//  Created by BCL-Device-12 on 5/6/23.
//

import Foundation
import UIKit

protocol CustomSegmentControlBCDelegate: AnyObject{
    func didChangeSegmentButton(_ index: Int)
}

class CustomSegmentControlBC: UIView{
    
    private var segmentView = UIView(frame: CGRect(origin: .zero, size: .zero))
    private var separateLine = UIView(frame: CGRect(origin: .zero, size: .zero))
    private var moveView = UIView(frame: CGRect(origin: .zero, size: .zero))
    
    private var segmentCount: Int = 0
    private var moveViewXOrgin = [CGFloat]()
    private var lineWstore : CGFloat = 0
    
    var segmentIndex: Int = 0
    var allButton = [UIButton]()
    var segmentBtnTags = 0



    weak var delegate: CustomSegmentControlBCDelegate?
    
    
    //MARK: init
    init(frame: CGRect, segment: Int, background: UIColor,
         cornerRadius: CGFloat, moveViewColor: UIColor,
         buttonTitles:[String],sepLineCol: UIColor,sepLineW: CGFloat) {
        
        super.init(frame: frame)
        self.layoutIfNeeded()
        
        segmentCount = segment
        lineWstore = sepLineW
        
        self.backgroundColor = background
        self.frame = frame
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        moveView.frame = CGRect(x: 0, y: 0,
                                width: self.bounds.width / CGFloat(segment),
                                height: self.bounds.height)
        moveView.backgroundColor = moveViewColor
        self.addSubview(moveView)
    
        
        var xOffset = segmentView.bounds.width
        for i in stride(from: 0, to: segment, by: 1){
            let frame = CGRect(x: xOffset,
                               y: 0,
                               width: (self.bounds.width / CGFloat(segment)) - sepLineW,
                               height: frame.height)
            
            segmentView = getSegmentView(frame: frame,background: .clear,buttonTitle: buttonTitles[i])
            if i != 0 || i == segment - 1{
                separateLine =  getSeparateLine(frame: frame,lineColor: sepLineCol,lineW: sepLineW)
            }
            
            
            moveViewXOrgin.append(xOffset)
            xOffset += (segmentView.bounds.width + sepLineW)
        }
    }
    
    
    func getSegmentView(frame: CGRect,background: UIColor,buttonTitle: String) -> UIView{
        let segmentView = UIView()
        segmentView.frame = frame
        segmentView.backgroundColor = background
        
        let button = UIButton()
        button.frame = segmentView.bounds
        button.backgroundColor = .clear
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        segmentView.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapSegmentButton(_:)), for: .touchUpInside)
        button.tag = segmentBtnTags
        segmentBtnTags += 1
        
        allButton.append(button)
        self.addSubview(segmentView)
        return segmentView
    }
    
    func getSeparateLine(frame: CGRect,lineColor: UIColor,lineW: CGFloat) -> UIView{
        
        let lineView = UIView()
        lineView.frame = CGRect(x: frame.origin.x,
                                y: frame.height / 3,
                                width: lineW,
                                height: frame.height / 3)
        lineView.backgroundColor = lineColor
        lineView.layer.cornerRadius = 2
        self.addSubview(lineView)
        return lineView
    }
    
    
    //MARK: BUTTON ACTION
    @objc func didTapSegmentButton(_ sender: UIButton){
        
        segmentIndex = sender.tag
        
        var xOffeset = self.moveViewXOrgin[self.segmentIndex] + lineWstore
        var width = self.bounds.width / CGFloat(self.segmentCount) - lineWstore
        
        if segmentIndex == 0{
             xOffeset = self.moveViewXOrgin[self.segmentIndex]
             width = self.bounds.width / CGFloat(self.segmentCount)
        }
        
        UIView.animate(withDuration: 0.2) { [self] in
            
            self.moveView.frame = CGRect(x: xOffeset,
                                         y: 0,
                                         width: width,
                                         height: self.bounds.height)
            
            for button in self.allButton{
                if button.tag != sender.tag{
                    button.setTitleColor(.black, for: .normal)
                    button.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
                }
            }
            
            if self.segmentIndex == sender.tag{
                self.allButton[self.segmentIndex].setTitleColor(.white, for: .normal)
                self.allButton[self.segmentIndex].titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

//                let button = self.allButton[self.segmentIndex]
//                let duration: TimeInterval = 1.0
//                changeTitleColor(from: .black, to: .white, duration: duration, button: button)
            }
            
        }
        
    
        delegate?.didChangeSegmentButton(segmentIndex)
    }
    
    
    func changeTitleColor(from startColor: UIColor, to endColor: UIColor, duration: TimeInterval, button: UIButton) {
        let startComponents = startColor.cgColor.components ?? []
        let endComponents = endColor.cgColor.components ?? []
        let numberOfComponents = min(startComponents.count, endComponents.count)
        
        let timerInterval = 0.05
        let steps = Int(duration / timerInterval)
        
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            let ratio = CGFloat(currentStep) / CGFloat(steps)
            
            var interpolatedComponents: [CGFloat] = []
            for i in 0..<numberOfComponents {
                let interpolatedComponent = startComponents[i] + (endComponents[i] - startComponents[i]) * ratio
                interpolatedComponents.append(interpolatedComponent)
            }
            
            let interpolatedColor = UIColor(
                red: interpolatedComponents[0],
                green: interpolatedComponents[0],
                blue: interpolatedComponents[1],
                alpha: startColor.cgColor.alpha + (endColor.cgColor.alpha - startColor.cgColor.alpha) * ratio
            )
            
            button.setTitleColor(interpolatedColor, for: .normal)
            
            currentStep += 1
            
            if currentStep >= steps {
                timer.invalidate()
            }
        }
    }


    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
