import UIKit

class TableViewCell: UITableViewCell {
    
    var title: String? {
        get { label.text }
        set { label.text = newValue }
    }

    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.addSubview(background)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.frame = contentView.bounds.inset(by: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        label.frame = background.frame.insetBy(dx: 4, dy: 0)
    }
    
}
