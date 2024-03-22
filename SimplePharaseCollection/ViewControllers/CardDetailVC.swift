//
//  CardDetailVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

final class CardDetailVC: UIViewController {

    let tagTextView = CustomLabelTextView(fontSize: 12, backgroundColor: .systemOrange)
    let sentenceTextView = UITextView()
    let memoTextView = UITextView()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let cardView = UIView()
    let realm = try! Realm()
    private var previousItem: DataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureScrollContentView()
        configureTagTextView()
        configureSentenceTextView()
        configureMemoTextView()
        configureStackView()
        configureCardView()
        configureViewController()
        addToolBarToKeyboard()
    }

    //MARK: - ScrollView & ScrollContentView

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }

    private func configureScrollContentView() {
        scrollView.addSubview(scrollContentView)
        scrollContentView.backgroundColor = .systemBackground
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            scrollContentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, multiplier: 1.4)
        ])
    }

    //MARK: - CardView
    private func configureCardView() {
        scrollContentView.addSubview(cardView)
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 24
        cardView.layer.borderWidth = 4
        cardView.layer.borderColor = UIColor.systemGray.cgColor

        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -32)
        ])
    }

    //MARK: - StackView
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
            stackView.topAnchor.constraint(equalTo: tagTextView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    //MARK: - StackView Components

    private func configureTagTextView() {
        cardView.addSubview(tagTextView)
        tagTextView.text = "Phrase"
        tagTextView.isEditable = false
        tagTextView.delegate = self

        NSLayoutConstraint.activate([
            tagTextView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            tagTextView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tagTextView.heightAnchor.constraint(equalToConstant: 24),
            tagTextView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureSentenceTextView() {
        stackView.addArrangedSubview(sentenceTextView)
        sentenceTextView.isEditable = false
        sentenceTextView.font = UIFont.systemFont(ofSize: 20)
        sentenceTextView.layer.cornerRadius = 10
        sentenceTextView.textAlignment = .left
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = false
        sentenceTextView.backgroundColor = .secondarySystemBackground
        sentenceTextView.delegate = self

        NSLayoutConstraint.activate([
            sentenceTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            sentenceTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            sentenceTextView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }

    private func configureMemoTextView() {
        stackView.addArrangedSubview(memoTextView)
        print("Before memoTextView.isEditable: \(memoTextView.isEditable)")
        memoTextView.isEditable = false
        print("After memoTextView.isEditable: \(memoTextView.isEditable)")
        memoTextView.font = UIFont.systemFont(ofSize: 20)
        memoTextView.layer.cornerRadius = 10
        memoTextView.textAlignment = .left
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.backgroundColor = .secondarySystemBackground
        memoTextView.delegate = self

        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: sentenceTextView.bottomAnchor, constant: 24),
            memoTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24)
        ])
    }

    //MARK: - Configure ViewController

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let naviEditButton = UIBarButtonItem(title: "Edit", style: .plain, target: self , action: #selector(naviEditButtonPressed))
        navigationItem.rightBarButtonItem = naviEditButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(with:)))
        view.addGestureRecognizer(tapGesture)

        let tapGestureForNavi = UITapGestureRecognizer(target: self, action: #selector(navBarTapped))
                navigationController?.navigationBar.addGestureRecognizer(tapGestureForNavi)
    }

    //MARK: - Button Actions

    @objc private func dismissKeyboard(with gesture: UITapGestureRecognizer) {
        print("Other Areas Tapped!")
        sentenceTextView.resignFirstResponder()
        memoTextView.resignFirstResponder()
        tagTextView.resignFirstResponder()
    }

    @objc private func naviEditButtonPressed() {
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()
        tagTextView.isEditable.toggle()
        scrollView.isScrollEnabled.toggle()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        if sentenceTextView.isEditable {
            sentenceTextView.becomeFirstResponder()


            if let currentItem = realm.objects(DataModel.self).filter("sentence == %@", sentenceTextView.text!).first {
                previousItem = currentItem
            }
            print("編集中")
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self , action: #selector(naviEditButtonPressed))
            navigationItem.rightBarButtonItem = cancelButton
        } else {
            print("閲覧のみ")
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self , action: #selector(naviEditButtonPressed))
            navigationItem.rightBarButtonItem = editButton
        }
    }

    private func addToolBarToKeyboard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = .systemBackground

        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let deleteButton = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))

        toolBar.items = [ spacer, deleteButton, spacer, saveButton, spacer]
        sentenceTextView.inputAccessoryView = toolBar
        memoTextView.inputAccessoryView = toolBar
        tagTextView.inputAccessoryView = toolBar
    }

    @objc private func saveButtonTapped() {
        print("save tapped")
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()
        tagTextView.isEditable.toggle()

        if let newItem = realm.objects(DataModel.self).filter("sentence == %@", previousItem?.sentence).first {
            do {
                try realm.write {
                    newItem.sentence = sentenceTextView.text
                    newItem.memo = memoTextView.text
                    newItem.tag = tagTextView.text
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
    
    @objc private func navBarTapped() {
        sentenceTextView.resignFirstResponder()
        memoTextView.resignFirstResponder()
        tagTextView.resignFirstResponder()
    }
}

extension CardDetailVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        previousItem?.sentence = sentenceTextView.text
        previousItem?.memo = memoTextView.text
        previousItem?.tag = tagTextView.text
    }
}

#Preview {
    let vc = CardDetailVC()
    return vc
}
