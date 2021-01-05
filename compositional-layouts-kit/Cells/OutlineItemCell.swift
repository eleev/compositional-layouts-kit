//
//  OutlineItemCell.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 19/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

class OutlineItemCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Properties
    
    let label = UILabel()
    let subitemsLabel = UILabel()
    let containerView = UIView()
    let imageView = UIImageView()
    let typeImage = UIImageView()
    var subitems: Int = 0
    
    private lazy var stackImage = UIImage(systemName: "rectangle.stack.fill")
    private lazy var gridImage = UIImage(systemName: "square.grid.2x2.fill")
    
    var indentLevel: Int = 0 {
        didSet {
            indentContraint.constant = CGFloat(20 * indentLevel)
        }
    }
    var isExpanded = false {
        didSet {
            configureChevron()
            configureType()
            onExpansionUpdate()
        }
    }
    var isGroup = false {
        didSet {
            configureChevron()
            configureType()
        }
    }
    override var isHighlighted: Bool {
        didSet {
            configureChevron()
        }
    }
    override var isSelected: Bool {
        didSet {
            configureChevron()
        }
    }
    
    fileprivate var indentContraint: NSLayoutConstraint! = nil
    fileprivate let inset = CGFloat(10)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureChevron()
        configureType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Conformance to `Configurable` protocol
extension OutlineItemCell: Configurable {
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        containerView.addSubview(label)
        
        subitemsLabel.translatesAutoresizingMaskIntoConstraints = false
        subitemsLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        subitemsLabel.textColor = .systemGray2
        subitemsLabel.adjustsFontForContentSizeCategory = true
        subitemsLabel.textAlignment = .right
        containerView.addSubview(subitemsLabel)
        
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(typeImage)
        
        indentContraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset)
        NSLayoutConstraint.activate([
            indentContraint,
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            typeImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            typeImage.heightAnchor.constraint(equalToConstant: 25),
            typeImage.widthAnchor.constraint(equalToConstant: 25),
            typeImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: typeImage.trailingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: subitemsLabel.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            subitemsLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: inset),
            subitemsLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -inset),
            subitemsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            subitemsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
    }
    
    func configureType() {
        typeImage.image = isGroup ? stackImage : gridImage
        typeImage.contentMode = .scaleAspectFit
        
        let highlighted = isHighlighted || isSelected
        typeImage.tintColor = isGroup ? (highlighted ? .gray : .systemGray2) : (highlighted ? .gray : .cornflowerBlue)
    }
    
    func configureChevron() {
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevron = rtl ? "chevron.left" : "chevron.right"
        let chevronSelected = rtl ? "chevron.left" : "chevron.right"
        let highlighted = isHighlighted || isSelected
        
        if isGroup {
            let imageName = highlighted ? chevronSelected : chevron
            let image = UIImage(systemName: imageName)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            let rtlMultiplier = rtl ? CGFloat(-1.0) : CGFloat(1.0)
            let rotationTransform = isExpanded ?
                CGAffineTransform(rotationAngle: rtlMultiplier * CGFloat.pi / 2) :
                CGAffineTransform.identity
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = rotationTransform
            }
        } else {
            imageView.image = nil
        }
        
        imageView.tintColor = highlighted ? .gray : .systemGray2
    }
    
    func onExpansionUpdate() {
        if subitems > 0, !isExpanded {
            UIView.transition(with: subitemsLabel,
                              duration: 0.3,
                              options: .transitionFlipFromTop,
                              animations: { [weak self] in
                                guard let self = self else { return }
                                self.subitemsLabel.text = "\(self.subitems)"
            },
                              completion: nil)
        } else {
            subitemsLabel.text = ""
        }
    }
}
