//
//  ViewController.swift
//  Interface Builder
//
//  Created by Дмитрий Козлов on 03/09/15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit

var vc: ViewController!

let tc = UIColor(white: 1, alpha: 0.6)
let tcH = UIColor(white: 1, alpha: 1.0)

var bViews = [ViewBuilder]()

class ViewController: UIViewController, DViewDelegate, AnchorViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sv: ViewBuilder!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var nameBlock: EView!
    @IBOutlet weak var positionBlock: EView!
    @IBOutlet weak var sizeBlock: EView!
    @IBOutlet weak var advancedBlock: EView!
    @IBOutlet weak var labelBlock: EView!
    @IBOutlet weak var deleteButton: Button!
    
    var selectedView: ViewBuilder! {
        didSet {
            oldValue?.selected = false
            oldValue?.alpha = 1.0
            if selectedView != nil {
                selectedView.alpha = 0.8
                name.text = selectedView.name
                let p = selectedView.position
                x.text = "\(Int(p.x))"
                y.text = "\(Int(p.y))"
                anchor.anchor = selectedView.anchor
                anchorViewAnchor.anchor = selectedView.anchorViewAnchor // anchor anchor anchor
                anchorView.setTitle(selectedView.anchorView != nil ? selectedView.anchorView!.name : "Anchor View", forState: .Normal)
                width.text = "\(Int(selectedView.width))"
                height.text = "\(Int(selectedView.height))"
                cornerRadius.text = "\(selectedView.cornerRadius)"
                
                nameBlock.show = true
                positionBlock.show = true
                sizeBlock.show = true
                advancedBlock.show = true
                deleteButton.show = true
                scrollView.contentSize = CGSize(scrollView.contentSize.width, advancedBlock.frame.bottom)
                if selectedView is LabelBuilder {
                    let v = selectedView as! LabelBuilder
                    labelBlock.show = true
                    scrollView.contentSize = CGSize(scrollView.contentSize.width, labelBlock.frame.bottom)
                    text.text = v.text
                    fontSize.text = "\(v.fontSize)"
                    color.text = v.color
                    alignment.selectedSegmentIndex = v.alignment
                    widthFit.on = v.fixWidth
                    heightFit.on = v.fixHeight
                    linesCount.text = "\(v.numberOfLines)"
                    
                } else {
                    labelBlock.show = false
                }
            } else {
                nameBlock.show = false
                positionBlock.show = false
                sizeBlock.show = false
                advancedBlock.show = false
                labelBlock.show = false
                deleteButton.show = false
            }
        }
    }
    
    @IBAction func createView(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let view = ViewBuilder()
            view.delegate = self
            sv.addSubview(view)
            selectedView = view
        } else if sender.selectedSegmentIndex == 1 {
            let view = LabelBuilder()
            view.delegate = self
            sv.addSubview(view)
            selectedView = view
        } else {
            
        }
        sender.selectedSegmentIndex = -1
    }
    
    @IBOutlet weak var name: ETF!
    @IBAction func changeName(sender: UITextField) {
        selectedView.name = name.text
    }
    @IBOutlet weak var x: ETF!
    @IBAction func changeX(sender: UITextField) {
        let xn = safe(x.text.toInt())
        let yn = safe(y.text.toInt())
        selectedView.position = CGPoint(CGFloat(xn),CGFloat(yn))
    }
    @IBAction func addX(sender: ESegButton) {
        var p = selectedView.position
        if sender.selectedSegmentIndex == 0 {
            p.x--
        } else {
            p.x++
        }
        x.text = "\(Int(p.x))"
        selectedView.position = p
        sender.selectedSegmentIndex = -1
    }
    @IBOutlet weak var y: ETF!
    @IBAction func changeY(sender: UITextField) {
        let xn = safe(x.text.toInt())
        let yn = safe(y.text.toInt())
        selectedView.position = CGPoint(CGFloat(xn),CGFloat(yn))
    }
    @IBAction func addY(sender: ESegButton) {
        var p = selectedView.position
        if sender.selectedSegmentIndex == 0 {
            p.y--
        } else {
            p.y++
        }
        y.text = "\(Int(p.y))"
        selectedView.position = p
        sender.selectedSegmentIndex = -1
    }
    
    
    @IBOutlet weak var anchorView: UIButton!
    var anchorViewSelected = false {
        didSet {
            if anchorViewSelected {
                anchorView.setTitleColor(tc, forState: .Normal)
            } else {
                anchorView.setTitleColor(tcH, forState: .Normal)
            }
        }
    }
    @IBAction func selectAnchorView(sender: AnyObject) {
        anchorViewSelected = !anchorViewSelected
    }
    
    @IBOutlet weak var anchor: AnchorView!
    @IBOutlet weak var anchorViewAnchor: AnchorView!
    
    
    @IBOutlet weak var width: ETF!
    @IBAction func changeWidth(sender: AnyObject) {
        selectedView.width = CGFloat(safe(width.text.toInt()))
    }
    @IBOutlet weak var height: ETF!
    @IBAction func changeHeight(sender: AnyObject) {
        selectedView.height = CGFloat(safe(height.text.toInt()))
        
    }
    @IBAction func addWidth(sender: ESegButton) {
        if sender.selectedSegmentIndex == 0 {
            selectedView.width--
        } else {
            selectedView.width++
        }
        width.text = "\(Int(selectedView.width))"
        sender.selectedSegmentIndex = -1
    }
    @IBAction func addHeight(sender: ESegButton) {
        if sender.selectedSegmentIndex == 0 {
            selectedView.height--
        } else {
            selectedView.height++
        }
        height.text = "\(Int(selectedView.height))"
        sender.selectedSegmentIndex = -1
    }
    
    @IBOutlet weak var cornerRadius: ETF!
    @IBAction func changeCornerRadius(sender: UITextField) {
        selectedView.cornerRadius = safe(cornerRadius.text.toInt())
    }
    
    @IBOutlet weak var backgroundColor: ETF!
    @IBAction func changeBackgroundColor(sender: UITextField) {
        selectedView.bgColor = sender.text
    }
    
    @IBOutlet weak var text: ETF!
    @IBAction func changeText(sender: UITextField) {
        (selectedView as! LabelBuilder).text = sender.text
    }
    @IBOutlet weak var fontSize: ETF!
    @IBAction func changeFont(sender: UITextField) {
        (selectedView as! LabelBuilder).fontSize = safe(sender.text.toInt())
        
    }
    @IBOutlet weak var color: ETF!
    @IBAction func changeColor(sender: UITextField) {
        (selectedView as! LabelBuilder).color = sender.text
        
    }
    @IBOutlet weak var alignment: ESeg!
    @IBAction func changeAlignment(sender: UISegmentedControl) {
        (selectedView as! LabelBuilder).alignment = sender.selectedSegmentIndex
    }
    
    @IBOutlet weak var widthFit: UISwitch!
    @IBAction func changeWidthFit(sender: UISwitch) {
        (selectedView as! LabelBuilder).fixWidth = sender.on
    }
    @IBOutlet weak var heightFit: UISwitch!
    @IBAction func changeHeightFit(sender: UISwitch) {
        (selectedView as! LabelBuilder).fixHeight = sender.on
    }
    @IBOutlet weak var linesCount: ETF!
    @IBAction func changeLinesCount(sender: UITextField) {
        (selectedView as! LabelBuilder).numberOfLines = safe(sender.text.toInt())
    }
    
    func anchorChanged(view: AnchorView) {
        if view == anchor {
            selectedView.anchor = view.anchor
            let p = selectedView.position
            x.text = "\(Int(p.x))"
            y.text = "\(Int(p.y))"
        } else if view == anchorViewAnchor {
            selectedView.anchorViewAnchor = view.anchor
            let p = selectedView.position
            x.text = "\(Int(p.x))"
            y.text = "\(Int(p.y))"
        }
    }
    
    func viewMoved(view: DView, offset: CGPoint) {
        let v = view as! ViewBuilder
        let p = v.position
        x.text = "\(Int(p.x))"
        y.text = "\(Int(p.y))"
    }
    func viewSelected(view: DView) {
        
        if view is ViewBuilder {
            if anchorViewSelected {
                let v = view as! ViewBuilder
                view.selected = false
                anchorViewSelected = false
                selectedView.anchorView = v
                anchorView.setTitle(v.name, forState: .Normal)
            } else {
                selectedView = view as! ViewBuilder
            }
        } else if view == sv {
            sv.selected = false
            if anchorViewSelected {
                selectedView.anchorView = sv
                anchorView.setTitle("Anchor View", forState: .Normal)
            } else {
                selectedView = nil
            }
        }
    }
    
    @IBAction func deleteView(sender: AnyObject) {
        selectedView.delete()
        selectedView = nil
    }
    
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = self
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
        anchor.delegate = self
        anchorViewAnchor.delegate = self
        sv.draggable = false
        sv.delegate = self
        isvsv = isv
        load()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    
    @IBOutlet weak var interfaceName: UITextField!
    @IBAction func changeInterfaceName(sender: AnyObject) {
        selectedInterface.name = interfaceName.text
    }
    @IBOutlet weak var isv: UIScrollView!
    func load() {
        let array = data.array("views")
        for interfaceData in array {
            let data = interfaceData as! NSDictionary
            loadInterface(data)
        }
        if buttons.count > 0 {
            selectInterface(buttons.first!)
        }
        if array.count == 0 {
            newInterface()
        }
    }
    
    @IBAction func newInterface(sender: AnyObject) {
        newInterface()
    }
    func newInterface() {
        let b = InterfaceBuilderButton(name: "ProjectName", animated: true)
        b.addTarget(self, action: "selectInterface:", forControlEvents: .TouchUpInside)
        isv.addSubview(b)
        selectInterface(b)
        buttons.append(b)
    }
    
    func loadInterface(data: NSDictionary) {
        let b = InterfaceBuilderButton(name: data.string("name"), animated: false)
        b.data = NSMutableDictionary(dictionary: data)
        b.addTarget(self, action: "selectInterface:", forControlEvents: .TouchUpInside)
        isv.addSubview(b)
        buttons.append(b)
    }
    
    func showInterface() {
        
    }
    
    var selectedInterface: InterfaceBuilderButton!
    func selectInterface(interface: InterfaceBuilderButton) {
        if interface != selectedInterface {
            if selectedInterface != nil {
                selectedInterface.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
                save()
                selectedView = nil
                bViews.removeAll(keepCapacity: false)
                for v in sv.subviews as! [UIView] {
                    v.removeFromSuperview()
                }
            }
            selectedInterface = interface
            selectedInterface.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
            interfaceName.text = selectedInterface.name
            let views = interface.data.array("views")
            for interfaceData in views {
                let data = interfaceData as! NSDictionary
                let type = data.string("type")
                if type == "view" {
                    let view = ViewBuilder(data: data as! [String : AnyObject])
                    view.delegate = self
                    sv.addSubview(view)
                } else if type == "label" {
                    let view = LabelBuilder(data: data as! [String : AnyObject])
                    view.delegate = self
                    sv.addSubview(view)
                }
            }
            for v in bViews {
                v.anchorView = findBuilderWithName(v.anchorViewName)
            }
            
        }
    }
    func save() {
        var array = NSMutableArray()
        for view in bViews {
            array.addObject(NSDictionary(dictionary: view.save()))
        }
        selectedInterface.data.setObject(array, forKey: "views")
        println("saved: \(array.count) views")
        unsaved = true
    }
    
    func findBuilderWithName(name: String?) -> ViewBuilder? {
        if name != nil {
            for view in bViews {
                if view.name == name {
                    return view
                }
            }
        }
        return nil
    }
    
    func saveAll() {
        var views = NSMutableArray()
        for d in buttons {
            views.addObject(d.data)
        }
        data.setObject(views, forKey: "views")
    }
    
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    ///############################################################################################################################################
    
    @IBAction func themeChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.3, animations: {
                self.sv.backgroundColor = UIColor(white: 1, alpha: 0.5)
                sender.tintColor = UIColor.whiteColor()
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.sv.backgroundColor = UIColor(white: 0, alpha: 0.5)
                sender.tintColor = UIColor.grayColor()
            })
        }
    }
    func orientationChanged() {
        screen.update()
    }
}
var isvy: CGFloat = 50
var isvsv: UIScrollView!
var buttons = [InterfaceBuilderButton]()

class InterfaceBuilderButton: Button {
    var data = NSMutableDictionary()
    var name: String = "" {
        didSet {
            setTitle(name, forState: .Normal)
            data.setObject(name, forKey: "name")
        }
    }
    init(name: String, animated: Bool) {
        self.name = name
        super.init(frame: CGRect(0,animated ? 0 : 50, 240, 50), text: name, font: defaultFont(16), color: tc)
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        isvy += 50
        if animated {
            alpha = 0.0
            UIView.animateWithDuration(0.3, animations: {
                self.alpha = 1.0
                self.frame = CGRect(0,50,240,50)
                for view in isvsv.subviews as! [UIView] {
                    if view is InterfaceBuilderButton {
                        view.frame = CGRectOffset(view.frame, 0, 50)
                    }
                }
            })
        } else {
            for view in isvsv.subviews as! [UIView] {
                if view is InterfaceBuilderButton {
                    view.frame = CGRectOffset(view.frame, 0, 50)
                }
            }
        }
        isvsv.contentSize = CGSize(isvsv.contentSize.width, isvy)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DView: View {
    var delegate: DViewDelegate?
    var selected = true
    var draggable = true
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if draggable && selected {
            let touch = touches.first as! UITouch
            let pos = touch.locationInView(self)
            let ppos = touch.previousLocationInView(self)
            let delta = pos - ppos
            offset(delta)
            delegate?.viewMoved(self, offset: delta)
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !selected {
            selected = true
            delegate?.viewSelected(self)
        }
    }
    func offset(offset: CGPoint) {
        frame = CGRectOffset(frame, offset.x, offset.y)
    }
}
protocol DViewDelegate {
    func viewMoved(view: DView, offset: CGPoint)
    func viewSelected(view: DView)
}

class TLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textColor = UIColor.whiteColor()
    }
}

class ELabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textColor = tc
    }
}

class ETF: UITextField {
    var ptext = ""
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 4
        addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.EditingDidEndOnExit)
    }
    override func becomeFirstResponder() -> Bool {
        let a = super.becomeFirstResponder()
        if a {
            ptext = text
            text = ""
            let p = self.convertPoint(bounds.origin, toView: UIApplication.sharedApplication().keyWindow!.rootViewController!.view)
            if screen.height - p.y < 400 {
                vc.view.frame.origin.y = screen.height - p.y - 400
            }
        }
        return a
    }
    override func resignFirstResponder() -> Bool {
        if text == "" {
            text = ptext
        }
        vc.view.frame.origin.y = 0
        return super.resignFirstResponder()
    }
    func dismiss() {
        resignFirstResponder()
    }
}
class ESeg: UISegmentedControl {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = tc
    }
    
}

class ESegButton: UISegmentedControl {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = tc
    }
}

class EView: View {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        alpha = 0.0
        show = false
        backgroundColor = UIColor.clearColor()
    }
}



/*
let i5: CGFloat = 326
let i6: CGFloat = 326
let i6p: CGFloat = 401
let ia: CGFloat = 264
let i5res = CGSize(320, 568)
let i6res = CGSize(375, 667)
let i6pres = CGSize(540, 960)
let iares = CGSize(768, 1024)
let i5scale =   ia / i5
let i6scale =   ia / i6
let i6pscale =  ia / i6p
let i5size = CGSize(width: Int(i5res.width * (ia / i5))/2, height: Int(i5res.height * (ia / i5))/2)
let i6size = CGSize(width: Int(i6res.width * (ia / i6))/2, height: Int(i6res.height * (ia / i6))/2)
let i6psize = CGSize(width: Int(i6pres.width * (ia / i6p))/2, height: Int(i6pres.height * (ia / i6p))/2)
let originalSize = CGSize(320, 568)
*/