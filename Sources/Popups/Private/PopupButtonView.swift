import UIKit
import RxCocoa
import RxSwift


extension Reactive where Base: PopupButtonView {
    
    var enabled: Binder<Bool> {
        return Binder(self.base) { button, enabled in
            button.enabled = enabled
        }
    }
    
    var tap: ControlEvent<Void> {
        return self.base.button.rx.tap
    }
}


class PopupButtonView: UIView {
    
    static let preferredHeight: CGFloat = 46
    
    fileprivate var button: UIButton!
    
    var enabled: Bool = true {
        didSet { button?.isEnabled = enabled }
    }
    
    
    class func width(for button: PopupButton) -> CGFloat {
        let font = button.boldTitle ? PopupConfig.fonts.buttonBold : PopupConfig.fonts.button
        let size = CGSize(width: 600, height: self.preferredHeight)
        let w = NSAttributedString(string: button.title, attributes: [.font: font]).boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size.width
        return ceil(w)
    }
    
    
    init(frame: CGRect, model: PopupButton, index: Int) {
        super.init(frame: frame)
        
        button = makeButton(model: model)
        button.tag = index
        addSubview(button)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addTarget(target: Any?, action: Selector) {
        self.button?.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
    private func makeButton(model: PopupButton) -> UIButton {
        let button = HighlightingButton(type: .custom)
        button.frame = bounds
        button.titleLabel?.font = model.boldTitle ? PopupConfig.fonts.buttonBold : PopupConfig.fonts.button
        button.clipsToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.7
        button.setTitle(model.title, for: .normal)
        
        if model.destructive {
            button.setTitleColor(PopupConfig.colors.destructive, for: .normal)
        } else {
            button.setTitleColor(PopupConfig.colors.buttonText, for: .normal)
            button.setTitleColor(PopupConfig.colors.buttonText.withAlphaComponent(0.4), for: .disabled)
        }
        
        button.onHighlightingChanged = { [weak self] highlighted in
            self?.alpha = highlighted ? 0.6 : 1
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

