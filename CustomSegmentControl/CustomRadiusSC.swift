//
//  CustomSegmentControl.swift
//  CustomSegmentControl
//
//  Created by BCL-Device-12 on 5/6/23.
//

import Foundation
import UIKit

protocol CustomRadiusSCDelegate: AnyObject{
    func didChangeCustomRadiusSC(_ index: Int)
}

class CustomRadiusSC: UIView{
    
    private var segmentView = UIView(frame: CGRect(origin: .zero, size: .zero))
    private var moveView = UIView(frame: CGRect(origin: .zero, size: .zero))
    
    private var segmentCount: Int = 0
    private var moveViewXOrgin = [CGFloat]()
    
    var segmentIndex: Int = 0
    var allButton = [UIButton]()
    var segmentBtnTags = 0

    weak var delegate: CustomRadiusSCDelegate?
    
    
    //MARK: init
    init(frame: CGRect, segment: Int, background: UIColor,
         cornerRadius: CGFloat, moveViewColor: UIColor,
         buttonTitles:[String]) {
        
        super.init(frame: frame)
        self.layoutIfNeeded()
        
        segmentCount = segment
        
        self.backgroundColor = background
        self.frame = frame
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        moveView.frame = CGRect(x: 0, y: 0,
                                width: self.bounds.width / CGFloat(segment),
                                height: self.bounds.height)
        moveView.backgroundColor = moveViewColor
        moveView.layer.cornerRadius = cornerRadius
        self.addSubview(moveView)
    
        
        var xOffset = segmentView.bounds.width
        for i in stride(from: 0, to: segment, by: 1){
            let frame = CGRect(x: xOffset,
                               y: 0,
                               width: (self.bounds.width / CGFloat(segment)),
                               height: frame.height)
            
            segmentView = getSegmentView(frame: frame,background: .clear,buttonTitle: buttonTitles[i])
            
            moveViewXOrgin.append(xOffset)
            xOffset += segmentView.bounds.width
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
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 14)

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
                                y: 0,
                                width: lineW,
                                height: frame.height)
        lineView.backgroundColor = lineColor
        self.addSubview(lineView)
        return lineView
    }
    
    
    //MARK: BUTTON ACTION
    @objc func didTapSegmentButton(_ sender: UIButton){
        
        segmentIndex = sender.tag
        
        var xOffeset = self.moveViewXOrgin[self.segmentIndex]
        var width = self.bounds.width / CGFloat(self.segmentCount)
        
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
            }
        }
    
        delegate?.didChangeCustomRadiusSC(segmentIndex)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
