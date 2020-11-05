import UIKit

class PopupView: UIView {

    var hideAction: (() -> Void)?
    
    let xOffset: CGFloat = 24
    let contentInsets = UIEdgeInsets(top: 15, left: 12, bottom: 0, right: 12)
    let buttonHeight: CGFloat = 40
    

    
    func makeTitle(text: String) -> UILabel {
        let availableSize = CGSize(width: self.bounds.width - contentInsets.left - contentInsets.right, height: 200)
        let attrText = NSAttributedString(string: text, attributes: [.font: PopupConfig.fonts.title,
                                                                     .foregroundColor: PopupConfig.colors.title])
        let height = ceil(attrText.boundingRect(with: availableSize,
                                                options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                context: nil).size.height)
        let frame = CGRect(x: contentInsets.left, y: contentInsets.top, width: availableSize.width, height: max(height, 26))
        
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attrText
        return label
    }
    
    
    func makeSubtitle(text: String, y: CGFloat) -> UILabel {
        let availableSize = CGSize(width: self.bounds.width - contentInsets.left - contentInsets.right, height: 200)
        let attrText = NSAttributedString(string: text, attributes: [.font: PopupConfig.fonts.subtitle,
                                                                     .foregroundColor: PopupConfig.colors.subtitle])
        let height = ceil(attrText.boundingRect(with: availableSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height)
        let frame = CGRect(x: contentInsets.left, y: y + 7, width: availableSize.width, height: max(height, 26))
        
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attrText
        return label
    }
    
    
    func makeLine(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = PopupConfig.colors.separator
        return view
    }
}


extension UIView {
    
    func applyPopupStyle() {
        backgroundColor = PopupConfig.colors.background
        layer.cornerRadius = 14
        layer.shadowOpacity = 0.24
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOffset = .zero
    }
}
