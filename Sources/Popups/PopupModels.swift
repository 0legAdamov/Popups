import UIKit


//MARK: - Popup

public class PopupButton {
    
    public enum Style {
        case bordered
        case filled
        case bordless
    }
    
    let title: String
    
    public var boldTitle = false
    public var destructive = false
    public var highlighted = false
    
    public var onAction: (() -> Void)?
    
    
    public init(title: String) {
        self.title = title
    }
}


public class PopupModel <ButtonType: PopupButton> {
    public var title: String?
    public var subTitle: String?
    public var modalInteraction = false
    public var buttons = [ButtonType]()
    
    var isValid: Bool {
        return (title != nil || subTitle != nil) && self.buttons.count > 0
    }
    
    public init() {}
}


//MARK: - Alert Popup

public final class PopupAlertButton: PopupButton {
    public var textFieldTracking = false
    public var style: PopupButton.Style = .bordless
}


public final class PopupAlertTextField {
    let placeholder: String?
    let image: UIImage?
    public var text: String?
    
    public init(placeholder: String?, image: UIImage?) {
        self.placeholder = placeholder
        self.image = image
    }
}


public final class PopupAlert: PopupModel<PopupAlertButton> {
    public var textField: PopupAlertTextField?
    
    typealias ButtonType = PopupAlertButton
    
    override var isValid: Bool {
        return super.isValid && buttons.count < 3
    }
}


//MARK: - ActionSheet Popup

public final class PopupActionSheetButton: PopupButton {
}


public final class PopupActionSheet: PopupModel<PopupActionSheetButton> {
    
    public var cancelButtonTitle: String?
    public var onCancel: (() -> Void)?
    
    override var isValid: Bool {
        return super.isValid && cancelButtonTitle != nil
    }
}
