import UIKit

class PopupView: UIView {

    var hideAction: (() -> Void)?
    
    let contentInsets = UIEdgeInsets(top: 19, left: 30, bottom: 6, right: 30)

    
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
    
    
    func makeSubtitle(text: String, lastContentY: CGFloat) -> UILabel {
        let availableSize = CGSize(width: self.bounds.width - contentInsets.left - contentInsets.right, height: 200)
        let attrText = NSAttributedString(string: text, attributes: [.font: PopupConfig.fonts.subtitle,
                                                                     .foregroundColor: PopupConfig.colors.subtitle])
        let height = ceil(attrText.boundingRect(with: availableSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height)
        let y = lastContentY + 13
        let frame = CGRect(x: contentInsets.left, y: y, width: availableSize.width, height: max(height, 26))
        
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
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 7
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
