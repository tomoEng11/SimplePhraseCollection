//
//  CardCollectionVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

final class CardCollectionVC: UIViewController {

    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ItemData>!
    private var isSearching: Bool = false
    private let realm = try! Realm()
    private let toolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        let items = realm.objects(ItemData.self)
        configureCollectionView()
        configureDataSource()
        updateData(on: items)
        configureSearchController()
        configureViewController()
        configureToolBar()
        checkItemEmptyAndShowEmptyView(items: items)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let items = realm.objects(ItemData.self)
        updateData(on: items)
        checkItemEmptyAndShowEmptyView(items: items)
    }

    //MARK: - DataSource

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CardCollectionViewCell.reuseID,
                    for: indexPath) as! CardCollectionViewCell

                DispatchQueue.main.async {
                    cell.set(with: item)
                }
                return cell
            }
        )
    }

    //MARK: - Snapshot

    func updateData(on items: Results<ItemData>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(items))
        dataSource.apply(snapshot, animatingDifferences: true)
    }


    //MARK: - CollectionView

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
    }

    //MARK: - Configure ViewController

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Phrase Collection"
        let selectButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(navBarButtonPressed))
        navigationItem.rightBarButtonItem = selectButton
    }

    private func checkItemEmptyAndShowEmptyView(items: Results<ItemData>) {
        if items.count == 0 {
            let message = "New journey for getting your favorite phrases. \nAdd a card \nin New Card Screen. "
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
            }
        } else {
            return
        }
    }

    //MARK: - Button Actions

    @objc private func navBarButtonPressed() {
        collectionView.allowsMultipleSelection.toggle()

        if collectionView.allowsMultipleSelection {
            //編集ボタンを押した時の処理
            toolBar.isHidden = false
            let cancelButton = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(navBarButtonPressed))
            navigationItem.rightBarButtonItem = cancelButton

        } else {
            //キャンセルボタンを押した時の処理
            let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self, 
                action: #selector(navBarButtonPressed))
            navigationItem.rightBarButtonItem = editButton

            let items = realm.objects(ItemData.self)
            do {
                try realm.write {
                    for item in items {
                        if let currentItem = realm.objects(ItemData.self).filter("id == %@", item.id).first {
                            currentItem.isChecked = false
                        }
                    }

                }
            } catch {
                print("error")
            }
            let newItems = realm.objects(ItemData.self)
            updateData(on: newItems)
            toolBar.isHidden = true
        }
    }

    @objc private func deleteButtonTapped() {
        let items = realm.objects(ItemData.self).filter("isChecked == true")
        do {
            try realm.write {
                for item in items {
                    realm.delete(item)
                }
            }
        } catch {
            print("error")
        }
        let newItems = realm.objects(ItemData.self)
        updateData(on: newItems)
        //編集モードから抜ける
        navBarButtonPressed()
        presentAlertOnMainThread(
            title: "カードが削除されました",
            message: "",
            buttonTitle: "OK")
    }

    //MARK: - ToolBar

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

        let spacer = UIBarButtonItem(
            barButtonSystemItem:UIBarButtonItem.SystemItem.flexibleSpace,
            target: self,
            action: nil)

        let deleteButton = UIBarButtonItem(
            title: "delete",
            style: .plain,
            target: self,
            action: #selector(deleteButtonTapped))

        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(navBarButtonPressed))

        toolBar.items = [ spacer, deleteButton, spacer, cancelButton, spacer]
        
        let lineView = UIView()
        lineView.backgroundColor = .secondarySystemBackground
        toolBar.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
    }

    //MARK: - SearchBar

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for your favorite phrase!"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        let items = realm.objects(ItemData.self)
        updateData(on: items)
    }
}

//MARK: - SearchBar Delegate

extension CardCollectionVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true

        let filteredItem = realm.objects(ItemData.self).filter("sentence contains '\(filter.lowercased())' OR sentence contains '\(filter.uppercased())'")

        updateData(on: filteredItem)
    }
}

//MARK: - CollectionView Delegate

extension CardCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView.allowsMultipleSelection {
            //編集中にセルをタップした時のキャンセル処理

            if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
                removeCheckmarkAndUpdateData(selectedItem: selectedItem)
            }
        } else {
            //編集せずセルをタップした時の画面遷移処理
            if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
                let destinationVC = CardDetailVC()
                destinationVC.previousItem = selectedItem
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }

    func removeCheckmarkAndUpdateData(selectedItem: ItemData) {
        if let currentItem = realm.objects(ItemData.self).filter("id == %@", selectedItem.id).first {

                do {
                    try realm.write {
                        currentItem.isChecked.toggle()
                        realm.add(currentItem)
                    }
                } catch {
                    print("error")
                }
                let items = realm.objects(ItemData.self)
                updateData(on: items)
            }
    }
}
