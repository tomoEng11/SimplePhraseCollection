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
    private let realmModel = CollectionViewRealmModel()
    private let toolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        updateData(with: realmModel.readItems())
        configureSearchController()
        configureViewController()
        configureToolBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData(with: realmModel.readItems())
        checkItemEmptyAndShowEmptyView(numberOfItems: realmModel.itemCount())
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

    private func updateData(with items: Results<ItemData>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(items))
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    //MARK: - CollectionView

    private func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout().createTwoColumnFlowLayout(in: self.view)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
    }
}

//MARK: - SearchBar Delegate

extension CardCollectionVC: UISearchResultsUpdating, UISearchBarDelegate {

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
        updateData(with: realmModel.readItems())
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        updateData(with: realmModel.readFilteredItems(filter: filter))
    }
}

//MARK: - CollectionView Delegate

extension CardCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView.allowsMultipleSelection {
            //編集中にセルをタップした時のキャンセル処理

            guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }

            do {
                try realmModel.reverseCheckmark(for: selectedItem)
            } catch {
                presentErrorAlert(
                    title: CRUDError.unknown.description,
                    message: "",
                    buttonTitle: "OK")
            }
            updateData(with: realmModel.readItems())

        } else {
            //編集せずセルをタップした時の画面遷移処理
            guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
            let destinationVC = CardDetailVC()
            destinationVC.previousItem = selectedItem
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}

private extension CardCollectionVC {
    //MARK: - ViewController Setting

    func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Phrase Collection"
        let selectButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(navBarButtonPressed))
        navigationItem.rightBarButtonItem = selectButton
    }

    func checkItemEmptyAndShowEmptyView(numberOfItems: Int) {
        if numberOfItems == 0 {
            let message = "Welcome to Phrase Collection. \nAdd your favorite phrase\nin New Card Screen. "
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message)
            }
        } else {
            DispatchQueue.main.async {
                self.hideEmptyStateView()
            }
        }
    }

    //MARK: - NavButton Actions

    @objc func navBarButtonPressed() {
        collectionView.allowsMultipleSelection.toggle()

        if collectionView.allowsMultipleSelection {
            //編集ボタンを押した時の処理
            toolBar.isHidden = false
            generateCancelButtonOnEdittingMode()
        } else {
            //キャンセルボタンを押した時の処理
            generateEditButtonOnViewingMode()

            do {
                try realmModel.removeAllCheckmark()
            } catch {
                presentErrorAlert(
                    title: CRUDError.unknown.description,
                    message: "",
                    buttonTitle: "OK")
            }
            updateData(with: realmModel.readItems())
            toolBar.isHidden = true
        }
    }

    func generateCancelButtonOnEdittingMode() {
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self ,
            action: #selector(navBarButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }

    func generateEditButtonOnViewingMode() {
        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self ,
            action: #selector(navBarButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }

    @objc func deleteButtonTapped() {
        do {
            try realmModel.deleteItems()
            presentAlert(
                title: "カードが削除されました",
                message: "",
                buttonTitle: "OK")
        } catch {
            presentErrorAlert(
                title: CRUDError.delete.description,
                message: "",
                buttonTitle: "OK")
        }
        updateData(with: realmModel.readItems())
        //編集モードから抜ける
        navBarButtonPressed()
        checkItemEmptyAndShowEmptyView(numberOfItems: realmModel.itemCount())
    }

    //MARK: - ToolBar

    func configureToolBar() {
        view.addSubview(toolBar)
        toolBar.sizeToFit()
        toolBar.backgroundColor = .systemBackground
        toolBar.isHidden = true
        toolBar.set(constraints: [
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
        lineView.set(constraints: [
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor)
        ])
    }
}
