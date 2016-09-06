//
//  LabelBuilder.swift
//  Interface Builder
//
//  Created by Дмитрий Козлов on 03/09/15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit

var builderid = 0

class ViewBuilder: DView {
    
    var name: String
    var subs = [ViewBuilder]()
    
    var position: CGPoint {
        get {
            var f = anchorView != nil ? anchorView!.frame : superview!.bounds
            let a = anchor.raw()
            let av = anchorViewAnchor.raw()
            let x = frame.origin.x + frame.size.width * a.x - f.origin.x - f.size.width * av.x
            let y = frame.origin.y + frame.size.height * a.y - f.origin.y - f.size.height * av.y
            return CGPoint(Int(x),Int(y))
        }
        set {
            var f = anchorView != nil ? anchorView!.frame : superview!.bounds
            let a = anchor.raw()
            let av = anchorViewAnchor.raw()
            let x = newValue.x - frame.size.width * a.x + f.origin.x + f.size.width * av.x
            let y = newValue.y - frame.size.height * a.y + f.origin.y + f.size.height * av.y
            frame = CGRectOffset(bounds, x, y)
        }
    }
    var anchor: AnchorType = .topLeft
    weak var anchorView: ViewBuilder? {
        didSet {
            oldValue?.subs.removeObject(self)
            anchorView?.subs.append(self)
        }
    }
    var anchorViewName: String?
    var anchorViewAnchor: AnchorType = .topLeft
    var width: CGFloat = 100 {
        didSet {
            let offset = width - oldValue
            let a = offset * anchor.raw().x
            
            for sub in subs {
                sub.offsetAnimated(CGPoint(offset * sub.anchorViewAnchor.raw().x - a,0))
            }
            UIView.animateWithDuration(0.3, animations: {
                self.frame = CGRect(self.frame.origin.x - a,self.frame.origin.y,self.width,self.frame.size.height)
            })
        }
    }
    var height: CGFloat = 100 {
        didSet {
            let offset = height - oldValue
            let a = offset * anchor.raw().y
            for sub in subs {
                sub.offsetAnimated(CGPoint(0,offset * sub.anchorViewAnchor.raw().y - a))
            }
            UIView.animateWithDuration(0.3, animations: {
                self.frame = CGRect(self.frame.origin.x, self.frame.origin.y - a,self.frame.size.width, self.height)
            })
        }
    }
    var cornerRadius = 0 {
        didSet {
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = NSNumber(integerLiteral: oldValue)
            animation.toValue = NSNumber(integerLiteral: cornerRadius)
            animation.duration = 0.3
            layer.cornerRadius = CGFloat(cornerRadius)
            layer.addAnimation(animation, forKey: "cornerRadius")
        }
    }
    
    var bgColor = ""
    
    // Editor parameters
    
    override init() {
        builderid++
        name = "view\(builderid)"
        super.init(frame: CGRect(0, 0, 100, 100))
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        bViews.append(self)
    }
    
    init(data: [String: AnyObject]) {
        loaded = true
        name = data["name"] as! String
        anchor = AnchorType(rawValue: data["anchor"] as! Int)!
        cornerRadius = data["cornerRadius"] as! Int
        bgColor = data["backgroundColor"] as! String
        anchorViewName = data["anchorView"] as? String
        if anchorViewName != nil {
            anchorViewAnchor = AnchorType(rawValue: data["anchorViewAnchor"] as! Int)!
        }
        
        let hx = data["x"] as! CGFloat
        let hy = data["y"] as! CGFloat
        
        self.width = data["width"] as! CGFloat
        self.height = data["height"] as! CGFloat
        
        super.init(frame: CGRect(hx, hy, width, height))
        layer.cornerRadius = CGFloat(cornerRadius)
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        bViews.append(self)
        selected = false
    }
    var loaded = false
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil && !loaded {
            frame = CGRect(superview!.frame.size.width/2,superview!.frame.size.height/2,0,0)
            UIView.animateWithDuration(0.3, animations: {
                self.frame = CGRect(position: self.superview!.bounds.center, size: CGSize(100,100), anchorPoint: anchorPointCenter)
            })
        }
    }

    required init(coder aDecoder: NSCoder) {
        builderid++
        name = "view\(builderid)"
        super.init(coder: aDecoder)
    }
    
    func getCode() -> String {
        var code = ""
        //code.addLine("View(frame: CGRect(0,0,\(Int(size.width)),\(Int(size.height))")
        return code
    }
    
    func delete() {
        bViews.removeObject(self)
        UIView.animateWithDuration(0.3, animations: {
            self.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0)
        }) { (c) -> Void in
            self.removeFromSuperview()
        }
    }
    
    override func offset(offset: CGPoint) {
        super.offset(offset)
        for sub in subs {
            sub.offset(offset)
        }
    }
    func offsetAnimated(offset: CGPoint) {
        UIView.animateWithDuration(0.3, animations: {
            self.frame = CGRectOffset(self.frame, offset.x, offset.y)
        })
        for sub in subs {
            sub.offsetAnimated(offset)
        }
    }
    func save() -> [String: AnyObject] {
        var subnames = [String]()
        for sub in subs {
            subnames.append(sub.name)
        }
        let pos = frame.origin
        var result: [String: AnyObject] = [
            "type": "view",
            "name": name,
            "x": pos.x,
            "y": pos.y,
            "anchor": anchor.rawValue,
            "width": width,
            "height": height,
            "cornerRadius": cornerRadius,
            "backgroundColor": bgColor
            ]
        if anchorView != nil {
            result["anchorView"] = anchorView!.name
            result["anchorViewAnchor"] = anchorViewAnchor.rawValue
        }
        return result
    }
}

class LabelBuilder: ViewBuilder {
    override var frame: CGRect {
        didSet {
            label.frame = bounds
        }
    }
    let label: Label = Label(frame: CGRect(0,0,100,100), text: "Вставить текст", font: defaultFont(12), color: textColorLight, alignment: .Center)
    
    var text = "" {
        didSet {
            label.text = text
        }
    }
    var fontSize = 12 {
        didSet {
            label.font = defaultFont(CGFloat(fontSize))
        }
    }
    var color = "" {
        didSet {
            
        }
    }
    var alignment = 1 {
        didSet {
            switch alignment {
            case 0:
                label.textAlignment = .Left
            case 1:
                label.textAlignment = .Center
            case 2:
                label.textAlignment = .Right
            default:
                break
            }
        }
    }
    var fixWidth = false
    var fixHeight = false
    
    var numberOfLines: Int = 1 {
        didSet {
            label.numberOfLines = numberOfLines
        }
    }
    override init() {
        super.init()
        name = "label\(builderid)"
        addSubview(label)
    }
    
    override init(data: [String: AnyObject]) {
        super.init(data: data)
        text = data["text"] as! String
        fontSize = data["fontSize"] as! Int
        color = data["color"] as! String
        alignment = data["alignment"] as! Int
        fixWidth = data["fixWidth"] as! Bool
        fixHeight = data["fixHeight"] as! Bool
        numberOfLines = data["numberOfLines"] as! Int
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func save() -> [String : AnyObject] {
        var result = super.save()
        result["type"] = "label"
        result["text"] = text
        result["fontSize"] = fontSize
        result["color"] = color
        result["alignment"] = alignment
        result["fixWidth"] = fixWidth
        result["fixHeight"] = fixHeight
        result["numberOfLines"] = numberOfLines
        return result
    }
}
