//
//  CardDetailVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

class CardDetailVC: UIViewController {

    private let tagLabel = CustomTagLabel(backgroundColor: .systemOrange, fontSize: 12)
    let sentenceTextView = UITextView()
    let memoTextView = UITextView()
    private let stackView = UIStackView()
    private let cardView = UIView()
    private let doneButton = UIButton()
    var isModifying: Bool = false
    let realm = try! Realm()
    var previousItem: DataModel?
    let toolBar = UIToolbar()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureTagLabel()
        configureSentenceTextView()
        configureMemoTextView()
        configureStackView()
        configureCardView()
        configureViewController()
    }

    private func configureCardView() {
        view.addSubview(cardView)
        cardView.backgroundColor = .systemBackground
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 2
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 24
        cardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,  constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func configureStackView() {
        cardView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 34),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -34)
        ])
    }

    private func configureTagLabel() {
        cardView.addSubview(tagLabel)
        tagLabel.text = "Followers21-21"

        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            tagLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tagLabel.heightAnchor.constraint(equalToConstant: 24),
            tagLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureSentenceTextView() {
        stackView.addArrangedSubview(sentenceTextView)
        sentenceTextView.isEditable = false
        sentenceTextView.font = UIFont.systemFont(ofSize: 20)
        sentenceTextView.textColor = .white
        sentenceTextView.layer.cornerRadius = 10
        sentenceTextView.textAlignment = .left
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = false
        sentenceTextView.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            sentenceTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            sentenceTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            sentenceTextView.heightAnchor.constraint(equalToConstant: 260)
        ])
    }

    func configureMemoTextView() {
        stackView.addArrangedSubview(memoTextView)
        print("Before memoTextView.isEditable: \(memoTextView.isEditable)")
        memoTextView.isEditable = false
        print("After memoTextView.isEditable: \(memoTextView.isEditable)")
        memoTextView.font = UIFont.systemFont(ofSize: 20)
        memoTextView.textColor = .white
        memoTextView.layer.cornerRadius = 10
        memoTextView.textAlignment = .left
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: sentenceTextView.bottomAnchor, constant: 24),
            memoTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24)
        ])
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        let addButton = UIBarButtonItem(title: "Edit", style: .plain, target: self , action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addButtonPressed() {
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()
        isModifying.toggle()

        if memoTextView.isEditable && isModifying {
            configureToolBar()
            toolBar.isHidden = false

            if let currentItem = realm.objects(DataModel.self).filter("sentence == %@", sentenceTextView.text!).first {
                previousItem = currentItem
            }
            print("編集中")
            let addButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self , action: #selector(addButtonPressed))
            navigationItem.rightBarButtonItem = addButton
        } else {
            print("閲覧のみ")
            let addButton = UIBarButtonItem(title: "Edit", style: .plain, target: self , action: #selector(addButtonPressed))
            navigationItem.rightBarButtonItem = addButton
        }
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

        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))

        toolBar.items = [ spacer, deleteButton, spacer, saveButton, spacer]
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

    @objc private func saveButtonTapped() {
        print("save tapped")
        toolBar.isHidden = true
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()

        if let newItem = realm.objects(DataModel.self).filter("sentence == %@", previousItem?.sentence).first {
            do {
                try realm.write {
                    newItem.sentence = sentenceTextView.text
                    newItem.memo = memoTextView.text
                    realm.add(newItem)
                }
            } catch {
                print("error")
            }
        }
        presentAlertOnMainThread(title: "カードが保存されました", message: "", buttonTitle: "OK")

        self.navigationController?.popViewController(animated: true)
    }

    @objc private func deleteButtonTapped() {
        print("delete tapped")
        if let currentItem = realm.objects(DataModel.self).filter("sentence == %@", sentenceTextView.text!).first {
            do {
                try realm.write {
                    realm.delete(currentItem)
                }
            } catch {
                print("deleteできませんでした")
            }
            presentAlertOnMainThread(title: "削除が完了しました", message: "", buttonTitle: "OK")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

#Preview {
    let vc = CardDetailVC()
    return vc
}
