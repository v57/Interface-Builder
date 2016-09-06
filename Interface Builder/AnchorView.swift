//
//  AnchorView.swift
//  Interface Builder
//
//  Created by LinO_dska on 06/09/15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit

let avFont = defaultFont(12)
let avText = "●"
let avColor = UIColor(white: 0, alpha: 0.2)
let avColorH = UIColor(white: 1, alpha: 0.6)

enum AnchorType: Int {
    case top = 0, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight, center
    func raw() -> CGPoint {
        switch self {
        case .topLeft:
            return anchorPointTopLeft
        case .top:
            return anchorPointTop
        case .topRight:
            return anchorPointTopRight
        case .left:
            return anchorPointLeft
        case .center:
            return anchorPointCenter
        case .right:
            return anchorPointRight
        case .bottomLeft:
            return anchorPointBottomLeft
        case .bottom:
            return anchorPointBottom
        case .bottomRight:
            return anchorPointBottomRight
        }
    }
}

class AnchorView: View {
    var delegate: AnchorViewDelegate?
    
    let topLeftButton       = Button(frame: CGRect(0,0,20,20), text: avText, font: avFont, color: avColorH)
    let topButton           = Button(frame: CGRect(20,0,20,20), text: avText, font: avFont, color: avColor)
    let topRightButton      = Button(frame: CGRect(40,0,20,20), text: avText, font: avFont, color: avColor)
    let leftButton          = Button(frame: CGRect(0,20,20,20), text: avText, font: avFont, color: avColor)
    let centerButton        = Button(frame: CGRect(20,20,20,20), text: avText, font: avFont, color: avColor)
    let rightButton         = Button(frame: CGRect(40,20,20,20), text: avText, font: avFont, color: avColor)
    let bottomLeftButton    = Button(frame: CGRect(0,40,20,20), text: avText, font: avFont, color: avColor)
    let bottomButton        = Button(frame: CGRect(20,40,20,20), text: avText, font: avFont, color: avColor)
    let bottomRightButton   = Button(frame: CGRect(40,40,20,20), text: avText, font: avFont, color: avColor)
    
    var sButton: Button!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        sButton = topLeftButton
        topLeftButton.addTarget(self, action: "topLeft", forControlEvents: .TouchUpInside)
        topButton.addTarget(self, action: "top", forControlEvents: .TouchUpInside)
        topRightButton.addTarget(self, action: "topRight", forControlEvents: .TouchUpInside)
        leftButton.addTarget(self, action: "left", forControlEvents: .TouchUpInside)
        centerButton.addTarget(self, action: "c", forControlEvents: .TouchUpInside)
        rightButton.addTarget(self, action: "right", forControlEvents: .TouchUpInside)
        bottomLeftButton.addTarget(self, action: "bottomLeft", forControlEvents: .TouchUpInside)
        bottomButton.addTarget(self, action: "bottom", forControlEvents: .TouchUpInside)
        bottomRightButton.addTarget(self, action: "bottomRight", forControlEvents: .TouchUpInside)
        addSubviews([topLeftButton,topButton,topRightButton,leftButton,centerButton,rightButton,bottomLeftButton,bottomButton,bottomRightButton])
    }
    var anchor: AnchorType = .topLeft {
        didSet {
            if anchor != oldValue {
                sButton.setTitleColor(avColor, forState: .Normal)
                switch anchor {
                case .topLeft:
                    sButton = self.topLeftButton
                case .top:
                    sButton = self.topButton
                case .topRight:
                    sButton = self.topRightButton
                case .left:
                    sButton = self.leftButton
                case .center:
                    sButton = self.centerButton
                case .right:
                    sButton = self.rightButton
                case .bottomLeft:
                    sButton = self.bottomLeftButton
                case .bottom:
                    sButton = self.bottomButton
                case .bottomRight:
                    sButton = self.bottomRightButton
                }
                sButton.setTitleColor(avColorH, forState: .Normal)
            }
        }
    }
    func topLeft() {
        anchor = .topLeft
        delegate?.anchorChanged(self)
    }
    func top() {
        anchor = .top
        delegate?.anchorChanged(self)
    }
    func topRight () {
        anchor = .topRight
        delegate?.anchorChanged(self)
    }
    func left() {
        anchor = .left
        delegate?.anchorChanged(self)
    }
    func c() {
        anchor = .center
        delegate?.anchorChanged(self)
    }
    func right() {
        anchor = .right
        delegate?.anchorChanged(self)
    }
    func bottomLeft() {
        anchor = .bottomLeft
        delegate?.anchorChanged(self)
    }
    func bottom() {
        anchor = .bottom
        delegate?.anchorChanged(self)
    }
    func bottomRight() {
        anchor = .bottomRight
        delegate?.anchorChanged(self)
    }
}

protocol AnchorViewDelegate {
    func anchorChanged(view: AnchorView)
}
