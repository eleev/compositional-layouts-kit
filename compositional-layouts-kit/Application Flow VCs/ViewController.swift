//
//  ViewController.swift
//  compositional-layouts-kit
//
//  Created by Astemir Eleev on 19/06/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    class OutlineItem: Hashable {
        let title: String
        let indentLevel: Int
        let subitems: [OutlineItem]
        let outlineViewController: UIViewController.Type?
        let configuration: ((UIViewController) -> Void)?
        
        var isExpanded = false
        
        init(title: String,
             indentLevel: Int = 0,
             viewController: UIViewController.Type? = nil,
             configuration: ((UIViewController) -> Void)? = nil,
             subitems: [OutlineItem] = []) {
            self.title = title
            self.indentLevel = indentLevel
            self.subitems = subitems
            self.outlineViewController = viewController
            self.configuration = configuration
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        var isGroup: Bool {
            return self.outlineViewController == nil
        }
        private let identifier = UUID()
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
    var outlineCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Layouts"
        configureCollectionView()
        configureDataSource()
    }
    
    private lazy var vcDefaultConfiguration: (_ vc: UIViewController) -> Void = {
        return { (vc: UIViewController) in
            vc.view.backgroundColor = .systemBackground
        }
    }()
    
    private lazy var menuItems: [OutlineItem] = {
        return [
            OutlineItem(title: "Vertical Advanced Layouts", indentLevel: 0, subitems: [
                OutlineItem(title: "Waterfall", indentLevel: 1, viewController: WaterfallViewController.self, configuration: vcDefaultConfiguration),
                OutlineItem(title: "Mosaic", indentLevel: 1, viewController: MosaicViewController.self, configuration: vcDefaultConfiguration),
                OutlineItem(title: "Tiled", indentLevel: 1, subitems: [
                    OutlineItem(title: "Tile Grid", indentLevel: 2, viewController: TileGridViewController.self, configuration: vcDefaultConfiguration),
                    OutlineItem(title: "Banner Grid", indentLevel: 2, viewController: BanerTileGridViewController.self, configuration: vcDefaultConfiguration),
                    OutlineItem(title: "Portrait Grid", indentLevel: 2, viewController: PortraitTileGridViewController.self, configuration: vcDefaultConfiguration)
                    ])
                ]),
            OutlineItem(title: "Horizontal Advanced Layouts", indentLevel: 0, subitems: [
                OutlineItem(title: "Gallery", indentLevel: 1, viewController: GalleryViewController.self, configuration: vcDefaultConfiguration),
                OutlineItem(title: "Group Grid", indentLevel: 1, viewController: GroupGridViewController.self, configuration: vcDefaultConfiguration)
                ]),
            OutlineItem(title: "Orthogonal Advanced Layouts", indentLevel: 0, subitems: [
                ])
        ]
    }()
}

extension ViewController {
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(OutlineItemCell.self, forCellWithReuseIdentifier: OutlineItemCell.reuseIdentifier)
        self.outlineCollectionView = collectionView
    }
    
    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource
            <Section, OutlineItem>(collectionView: outlineCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, menuItem: OutlineItem) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OutlineItemCell.reuseIdentifier,
                    for: indexPath) as? OutlineItemCell else { fatalError("Could not create new cell") }
                cell.label.text = menuItem.title
                cell.indentLevel = menuItem.indentLevel
                cell.isGroup = menuItem.isGroup
                cell.isExpanded = menuItem.isExpanded

                return cell
        }
        
        // load our initial data
        let snapshot = snapshotForCurrentState()
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemHeightDimension = NSCollectionLayoutDimension.absolute(44)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemHeightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, OutlineItem> {
        let snapshot = NSDiffableDataSourceSnapshot<Section, OutlineItem>()
        snapshot.appendSections([Section.main])
        func addItems(_ menuItem: OutlineItem) {
            snapshot.appendItems([menuItem])
            if menuItem.isExpanded {
                menuItem.subitems.forEach { addItems($0) }
            }
        }
        menuItems.forEach { addItems($0) }
        return snapshot
    }
    
    func updateUI() {
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        if menuItem.isGroup {
            menuItem.isExpanded.toggle()
            if let cell = collectionView.cellForItem(at: indexPath) as? OutlineItemCell {
                UIView.animate(withDuration: 0.3) {
                    cell.isExpanded = menuItem.isExpanded
                    self.updateUI()
                }
            }
        } else {
            if let viewController = menuItem.outlineViewController {
                // Instantiate and apply optional configuration closure to the destination view controller
                let destinationViewController = viewController.init()
                menuItem.configuration?(destinationViewController)
                
                let navController = UINavigationController(rootViewController: destinationViewController)
                present(navController, animated: true)
            }
        }
    }
}
