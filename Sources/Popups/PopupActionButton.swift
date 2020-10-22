import UIKit


class PopupActionButton: UIView {
    
    static let preferredSize = CGSize(width: 118, height: 40)
    
    override var tag: Int {
        didSet { button?.tag = tag }
    }
    
    var enabled: Bool = true {
        didSet { button?.isEnabled = enabled }
    }
    
    var style: PopupButton.Style = .bordless {
        didSet {
            if self.style != oldValue { updateStyle() }
        }
    }
    
    var text: String = "" {
        didSet {
            self.button?.setTitle(self.text, for: .normal)
        }
    }
    
    var visible: Bool = true {
        didSet {
            if self.visible != oldValue { updateVisible() }
        }
    }
    
    var destructive: Bool = false {
        didSet {
            if oldValue != self.destructive { updateTextColor() }
        }
    }
    
    var highlighted: Bool = false {
        didSet {
            if oldValue != self.highlighted { updateTextColor() }
        }
    }
    
    var liteFont: Bool = false {
        didSet { button?.titleLabel?.font = liteFont ? PopupConfig.fonts.button : PopupConfig.fonts.buttonBold }
    }
    
    fileprivate var button: UIButton!
    
    
    convenience init(style: PopupButton.Style, visible: Bool) {
        self.init(frame: CGRect(origin: .zero, size: PopupActionButton.preferredSize), style: style, visible: visible)
    }
    
    
    class func width(for button: PopupButton) -> CGFloat {
        let font = button.boldTitle ? PopupConfig.fonts.buttonBold : PopupConfig.fonts.button
        let size = CGSize(width: 600, height: self.preferredSize.height)
        let w = NSAttributedString(string: button.title, attributes: [.font: font]).boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size.width
        return ceil(w)
    }
    
    
    init(frame: CGRect, style: PopupButton.Style, visible: Bool) {
        super.init(frame: frame)
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.4
        
        self.button = makeButton()
        self.addSubview(self.button)
        
        self.style = style
        updateStyle()
        
        if !visible {
            self.visible = false
            self.alpha = 0
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addTarget(target: Any?, action: Selector) {
        self.button?.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
    func setCustomTitleColor(_ color: UIColor) {
        guard self.style == .bordless else { return }
        button?.setTitleColor(color, for: .normal)
    }
    
    
    private func updateStyle() {
        switch self.style {
        case .filled:
            layer.shadowColor = PopupConfig.colors.buttonFill.cgColor
            button.backgroundColor = PopupConfig.colors.buttonFill
            button?.layer.borderWidth = 0
            
        case .bordered:
            layer.shadowColor = UIColor.clear.cgColor
            button?.backgroundColor = .clear
            button?.layer.borderColor = PopupConfig.colors.buttonBorder.cgColor
            button?.layer.borderWidth = 2
            
        case .bordless:
            layer.shadowColor = UIColor.clear.cgColor
            button?.backgroundColor = .clear
            button?.layer.borderWidth = 0
        }
        
        updateTextColor()
    }
    
    
    private func updateTextColor() {
        switch self.style {
        case .filled:
            button?.setTitleColor(PopupConfig.colors.background, for: .normal)
        case .bordered:
            button?.setTitleColor(PopupConfig.colors.buttonBorder, for: .normal)
        case .bordless:
            if self.destructive {
                button?.setTitleColor(PopupConfig.colors.destructive, for: .normal)
            } else if self.highlighted {
                button?.setTitleColor(PopupConfig.colors.buttonHighlighted, for: .normal)
                button?.setTitleColor(PopupConfig.colors.buttonHighlighted.withAlphaComponent(0.4), for: .disabled)
            } else  {
                button?.setTitleColor(PopupConfig.colors.buttonText, for: .normal)
                button?.setTitleColor(PopupConfig.colors.buttonText.withAlphaComponent(0.4), for: .disabled)
            }
        }
    }
    
    
    fileprivate func updateVisible() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = self.visible ? 1 : 0
        }
    }
    
    
    private func makeButton() -> UIButton {
        let button = HighlightingButton(type: .custom)
        button.frame = self.bounds
        button.titleLabel?.font = self.liteFont ? PopupConfig.fonts.button : PopupConfig.fonts.buttonBold
        button.layer.cornerRadius = self.bounds.height / 2
        button.clipsToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.7
        
        button.onHighlightingChanged = { [weak self] highlighted in
            self?.layer.shadowOpacity = highlighted ? 0.0 : 0.4
        }
        
        return button
    }
}


private class HighlightingButton: UIButton {
    
    public var onHighlightingChanged: ((Bool) -> Void)?
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onHighlightingChanged?(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onHighlightingChanged?(false)
        super.touchesEnded(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onHighlightingChanged?(false)
        super.touchesCancelled(touches, with: event)
    }
}

