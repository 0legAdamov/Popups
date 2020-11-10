import UIKit
import RxSwift


// MARK: Buttons

public class PopupButton {
    
    public var boldTitle = false
    
    public var destructive = false
    
    public lazy var onAction: Observable<Void> = {
        return actionSubject.asObservable()
    }()
    
    let title: String
    
    let actionSubject = PublishSubject<Void>()
    
    
    public init(title: String) {
        self.title = title
    }
    
    
    deinit {
        actionSubject.onCompleted()
    }
}


public final class PopupAlertButton: PopupButton {
    
    public var textFieldTracking = false
    
    /// True if `text` is valid
    public var trackingRule: ((_ text: String?) -> Bool)?
}


// MARK: Textfields

public final class PopupAlertTextField {
    
    public var text: String?
    
    let placeholder: String?
    
    let image: UIImage?
    
    
    public init(placeholder: String? = nil, text: String? = nil, image: UIImage? = nil) {
        self.placeholder = placeholder
        self.image = image
        self.text = text
    }
}


// MARK: Models

public class PopupModel {
    
    public var title: String?
    
    public var subtitle: String?
    
    public var modalInteraction = false
    
    public lazy var onDismiss: Observable<Void> = {
        return dismissSubject.asObservable()
    }()
    
    let dismissSubject = PublishSubject<Void>()
    
    var buttons = [PopupButton]()
    
    var isValid: Bool {
        return (title != nil || subtitle != nil) && self.buttons.count > 0
    }
    
    
    public init() {}
    
    
    deinit {
        dismissSubject.onCompleted()
    }
    
    
    public func append(button: PopupButton) {
        buttons.append(button)
    }
    
    
    fileprivate func makeController() -> PopupController {
        assertionFailure("Need implement in subclass")
        return PopupController()
    }
    
    
    public func show(on viewController: UIViewController) {
        viewController.present(makeController(), animated: false)
    }
}


public final class PopupAlert: PopupModel {
    
    public var textField: PopupAlertTextField?
    
    
    override var isValid: Bool {
        return super.isValid && buttons.count < 4
    }
    
    
    public init(title: String? = nil, subtitle: String? = nil) {
        super.init()
        self.title = title
        self.subtitle = subtitle
    }
    
    
    override func makeController() -> PopupController {
        return PopupAlertController(model: self)
    }
}


public final class PopupActionSheet: PopupModel {
    
    public var cancelButtonTitle: String?
    
    public var cancelAction: (() -> Void)?
    
    override var isValid: Bool {
        return super.isValid && cancelButtonTitle != nil
    }
    
    
    public init(title: String? = nil, subtitle: String? = nil, cancelButtonTitle: String? = nil) {
        super.init()
        self.title = title
        self.subtitle = subtitle
        self.cancelButtonTitle = cancelButtonTitle
    }
}
