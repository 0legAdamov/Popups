import UIKit


// MARK: Buttons

public class PopupButton {
    
    let title: String
    public var boldTitle = false
    public var destructive = false
    public var action: (() -> Void)?
    
    
    public init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
}


public final class PopupAlertButton: PopupButton {
    public var textFieldTracking = false
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
    public var buttons = [PopupButton]()
    
    var isValid: Bool {
        return (title != nil || subtitle != nil) && self.buttons.count > 0
    }
    
    public init() {}
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
