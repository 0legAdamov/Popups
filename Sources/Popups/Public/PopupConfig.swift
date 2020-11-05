import UIKit


public class PopupConfig {
    
    public class var colors: PopupColors {
        PopupConfig.shared.colors
    }
    
    public class var layout: PopupLayout {
        PopupConfig.shared.layout
    }
    
    public class var fonts: PopupFonts {
        PopupConfig.shared.fonts
    }
    
    
    public class func setup(colors: PopupColors) {
        PopupConfig.shared.colors = colors
    }
    
    public class func setup(layout: PopupLayout) {
        PopupConfig.shared.layout = layout
    }
    
    public class func setup(fonts: PopupFonts) {
        PopupConfig.shared.fonts = fonts
    }
    
    
    private static let shared = PopupConfig()
    
    private var colors: PopupColors = PopupColorsDefault()
    private var fonts: PopupFonts = PopupFontsDefault()
    private var layout: PopupLayout = PopupLayoutDefault()
}


public protocol PopupFonts {
    
    var title: UIFont { get }
    
    var subtitle: UIFont { get }
    
    var button: UIFont { get }
    
    var buttonBold: UIFont { get }
    
    var textfield: UIFont { get }
    
    var textfieldPlaceholder: UIFont { get }
}


public protocol PopupColors {
    
    var background: UIColor { get }
    
    var separator: UIColor { get }
    
    var title: UIColor { get }
    
    var subtitle: UIColor { get }
    
    var destructive: UIColor { get }
    
    var buttonText: UIColor { get }
    
    var textfieldIcon: UIColor { get }
    
    var textfieldPlaceholder: UIColor { get }
    
    var textfieldText: UIColor { get }
}


public protocol PopupLayout {}


private class PopupColorsDefault: PopupColors {
    
    var background: UIColor { .systemBackground }
    
    var separator: UIColor { .systemGray6 }
    
    var title: UIColor { .darkText }
    
    var subtitle: UIColor { .lightText }
    
    var destructive: UIColor { .systemRed }
    
    var buttonText: UIColor { .darkText }
    
    var textfieldIcon: UIColor { .darkText }
    
    var textfieldPlaceholder: UIColor { .lightGray }
    
    var textfieldText: UIColor { .darkText }
}


private class PopupFontsDefault: PopupFonts {
    
    var title: UIFont { .systemFont(ofSize: 17, weight: .semibold) }
    
    var subtitle: UIFont { .systemFont(ofSize: 16, weight: .regular) }
    
    var button: UIFont { .systemFont(ofSize: 16, weight: .regular) }
    
    var buttonBold: UIFont { .systemFont(ofSize: 16, weight: .medium) }
    
    var textfield: UIFont { .systemFont(ofSize: 16, weight: .medium) }
    
    var textfieldPlaceholder: UIFont { .italicSystemFont(ofSize: 16) }
}


private class PopupLayoutDefault: PopupLayout {
}
