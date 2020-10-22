import UIKit


//.. inject classes
public class PopupConfig {
    
    public static let colors = PopupColors()
    public static let fonts  = PopupFonts()
    public static let layout = PopupLayout()
}


public class PopupLayout {
    
}

public class PopupColors {
    
    public var background           = UIColor.white
    public var separator            = UIColor.lightGray
    public var title                = UIColor.black
    public var subtitle             = UIColor.darkGray
    public var destructive          = UIColor.red
    public var buttonBorder         = UIColor.darkGray
    public var buttonFill           = UIColor.blue
    public var buttonText           = UIColor.black
    public var buttonHighlighted    = UIColor.green
    public var textfieldIcon        = UIColor.blue
    public var textfieldPlaceholder = UIColor.lightGray
    public var textfield            = UIColor.black
}


public class PopupFonts {
    
    public var title        = UIFont.systemFont(ofSize: 19, weight: .medium)
    public var subtitle     = UIFont.systemFont(ofSize: 17, weight: .regular)
    public var button       = UIFont.systemFont(ofSize: 17, weight: .medium)
    public var buttonBold   = UIFont.systemFont(ofSize: 17, weight: .bold)
    public var textfield    = UIFont.systemFont(ofSize: 17, weight: .regular)
    
}
