//
//  CardCollectionVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

class CardCollectionVC: UIViewController {

    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, DataModel>!
    var isSearching: Bool = false
    let realm = try! Realm()
    let toolBar = UIToolbar()

    override func viewDidLoad() {
        let items = realm.objects(DataModel.self)
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        updateData(on: items)
        configureSearchController()
        configureViewController()
        configureToolBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let items = realm.objects(DataModel.self)
        updateData(on: items)
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseID, for: indexPath) as! CardCollectionViewCell

                DispatchQueue.main.async {
                    cell.set(with: item)
                }
                return cell
            }
        )
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
    }

    private func createTwoColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        return flowLayout
    }

    private func updateData(on items: Results<DataModel>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(items))
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Phrase Collection"
        let selectButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = selectButton
    }

    @objc private func editButtonPressed() {
        collectionView.allowsMultipleSelection.toggle()

        if collectionView.allowsMultipleSelection {
            toolBar.isHidden = false
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editButtonPressed))
            navigationItem.rightBarButtonItem = cancelButton
            print("編集ボタンが押されました")

        } else {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
            navigationItem.rightBarButtonItem = editButton

            let items = realm.objects(DataModel.self)
            do {
                try realm.write {

                    for item in items {
                        if let currentItem = realm.objects(DataModel.self).filter("sentence == %@", item.sentence).first {
                            currentItem.isChecked = false
                        }
                    }
                }
            } catch {
                print("error")
            }
            print("キャンセルボタンが押されました")
            let newitems = realm.objects(DataModel.self)
            updateData(on: newitems)
            toolBar.isHidden = true
        }
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for your favorite phrase!"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        let items = realm.objects(DataModel.self)
        updateData(on: items)
    }

    private func configureToolBar() {
        view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.sizeToFit()
        toolBar.backgroundColor = .systemBackground
        toolBar.isHidden = true

        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 55)
        ])

        // スペーサー構築
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 削除ボタン構築

        let deleteButton = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteButtonTapped))

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(editButtonPressed))

        toolBar.items = [ spacer, deleteButton, spacer, cancelButton, spacer]
        let lineView = UIView()
        lineView.backgroundColor = .secondarySystemBackground // グレーのラインを作成

        // 2. ToolBarまたはTabBarにビューを追加します。
        toolBar.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true // ラインの高さを設定
        lineView.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor).isActive = true // ToolBarの左端に配置
        lineView.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor).isActive = true // ToolBarの右端に配置
        lineView.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true // ToolBarの上端に配置
    }

    @objc private func deleteButtonTapped() {
        print("delete tapped")
        let items = realm.objects(DataModel.self).filter("isChecked == true")
        do {
            try realm.write {
                for item in items {
                    realm.delete(item)
                }
            }
        } catch {
            print("error")
        }
        let newItems = realm.objects(DataModel.self)
        updateData(on: newItems)
        //編集モードから抜ける
        editButtonPressed()
    }
}

extension CardCollectionVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true

        let filteredItem = realm.objects(DataModel.self).filter("sentence contains '\(filter.lowercased())' OR sentence contains '\(filter.uppercased())'")

        updateData(on: filteredItem)
    }
}

extension CardCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("セルをタップしました：\(indexPath)")
        if collectionView.allowsMultipleSelection {
            print("編集モードでセルが押されました")

            if let selectedItem = dataSource.itemIdentifier(for: indexPath) {

                if let currentItem = realm.objects(DataModel.self).filter("sentence == %@", selectedItem.sentence).first {
                    do {
                        try realm.write {
                            currentItem.isChecked.toggle()
                            realm.add(currentItem)
                        }
                    } catch {
                        print("error")
                    }
                    let items = realm.objects(DataModel.self)
                    updateData(on: items)
                }
            }
        } else {
            if let selectedItem = dataSource.itemIdentifier(for: indexPath) {

                let destinationVC = CardDetailVC()
                destinationVC.sentenceTextView.text = selectedItem.sentence
                destinationVC.memoTextView.text = selectedItem.memo
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
}

#Preview {
    let vc = CardCollectionVC()
    return vc
}

