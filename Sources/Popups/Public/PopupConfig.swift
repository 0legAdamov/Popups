import UIKit


// how to use
//class ExampleColors: PopupColors {
//    override var background: UIColor {
//        .red
//    }
//}
//PopupConfig.setup(colors: ExampleColors())


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
    
    private init() {}
    
    private var colors = PopupColors()
    private var fonts  = PopupFonts()
    private var layout = PopupLayout()
}


public class PopupLayout {
}


public class PopupColors {
    /// Default: systemBackground
    public var background: UIColor { .systemBackground }
    /// Default: systemGray4
    public var separator: UIColor { .systemGray4 }
    /// Default: darkText
    public var title: UIColor { .darkText }
    /// Default: lightText
    public var subtitle: UIColor { .lightText }
    /// Default: systemRed
    public var destructive: UIColor { .systemRed }
    /// Default: darkText
    public var buttonText: UIColor { .darkText }
    /// Default: lightGray
    public var buttonHighlighted: UIColor { .lightGray }
    /// Default: darkText
    public var textfieldIcon: UIColor { .darkText }
    /// Default: lightGray
    public var textfieldPlaceholder: UIColor { .lightGray }
    /// Default: darkText
    public var textfieldText: UIColor { .darkText }
}


public class PopupFonts {
    /// Default: system semibold 16
    public var title: UIFont { .systemFont(ofSize: 16, weight: .semibold) }
    /// Default: system regular 14
    public var subtitle: UIFont { .systemFont(ofSize: 14, weight: .regular) }
    /// Default: system regular 14
    public var button: UIFont { .systemFont(ofSize: 14, weight: .regular) }
    /// Default: system medium 14
    public var buttonBold: UIFont { .systemFont(ofSize: 14, weight: .medium) }
    ///Default: system medium 15
    public var textfield: UIFont { .systemFont(ofSize: 15, weight: .medium) }
    /// Default: system italic 16
    public var textfieldPlaceholder: UIFont { .italicSystemFont(ofSize: 15) }
    
}
