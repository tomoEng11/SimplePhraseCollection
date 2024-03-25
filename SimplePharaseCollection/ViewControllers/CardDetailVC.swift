//
//  CardDetailVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

final class CardDetailVC: UIViewController {

    let tagTextView = CustomLabelTextView(
        fontSize: 12,
        backgroundColor: .systemOrange)
    let sentenceTextView = UITextView()
    let memoTextView = UITextView()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let cardView = UIView()
    private let realmModel = CardDetailVCRealmModel()
    var previousItem: ItemData?
    let toolBar = UIToolbar()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagTextView.text = previousItem?.tag
        sentenceTextView.text = previousItem?.sentence
        memoTextView.text = previousItem?.memo
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
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 20

        let padding: CGFloat = 24

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: tagTextView.bottomAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding)
        ])
    }

    //MARK: - StackView Components

    private func configureTagTextView() {
        cardView.addSubview(tagTextView)
        tagTextView.text = "Phrase"
        tagTextView.isEditable = true

        NSLayoutConstraint.activate([
            tagTextView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            tagTextView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tagTextView.heightAnchor.constraint(equalToConstant: 32),
            tagTextView.widthAnchor.constraint(equalToConstant: 110)
        ])
    }

    private func configureSentenceTextView() {
        stackView.addArrangedSubview(sentenceTextView)
        sentenceTextView.font = UIFont.systemFont(ofSize: 20)
        sentenceTextView.layer.cornerRadius = 10
        sentenceTextView.textAlignment = .left
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = false
        sentenceTextView.backgroundColor = .secondarySystemBackground
        sentenceTextView.delegate = self

        NSLayoutConstraint.activate([
            sentenceTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            sentenceTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            sentenceTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureMemoTextView() {
        stackView.addArrangedSubview(memoTextView)
        memoTextView.font = UIFont.systemFont(ofSize: 20)
        memoTextView.layer.cornerRadius = 10
        memoTextView.textAlignment = .left
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            memoTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}

extension CardDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == sentenceTextView {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

extension CardDetailVC {

    //MARK: - ViewController Setting
    private func configureViewController() {
        view.backgroundColor = .systemBackground

        //MARK: - NavButtons Setting

        let navEditButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self ,
            action: #selector(navEditButtonPressed))
        navigationItem.rightBarButtonItem = navEditButton

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(with:)))
        view.addGestureRecognizer(tapGesture)

        let tapGestureForNav = UITapGestureRecognizer(
            target: self,
            action: #selector(navBarTapped))
        navigationController?.navigationBar.addGestureRecognizer(tapGestureForNav)
    }

    //MARK: - Button Actions

    @objc private func dismissKeyboard(with gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func navEditButtonPressed() {
        switchEdittingMode()
        if sentenceTextView.isEditable {
            //編集中に表示するキャンセルボタンの生成
            generateCancelButtonOnEdittingMode()
        } else {
            //編集ボタンの生成
            generateEditButtonOnViewingMode()
        }
    }

    private func generateCancelButtonOnEdittingMode() {
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self ,
            action: #selector(navEditButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }

    private func generateEditButtonOnViewingMode() {
        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self ,
            action: #selector(navEditButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }

    private func switchEdittingMode() {
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()
        tagTextView.isEditable.toggle()
        scrollView.isScrollEnabled.toggle()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        toolBar.isHidden.toggle()
        sentenceTextView.becomeFirstResponder()
    }

    //MARK: - ToolBar

    private func addToolBarToKeyboard() {
        toolBar.sizeToFit()
        toolBar.backgroundColor = .systemBackground
        toolBar.isHidden = true

        let spacer = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: self,
            action: nil)
        let deleteButton = UIBarButtonItem(
            title: "delete",
            style: .plain,
            target: self,
            action: #selector(deleteButtonTapped))
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped))

        toolBar.items = [ spacer, deleteButton, spacer, saveButton, spacer]
        sentenceTextView.inputAccessoryView = toolBar
        memoTextView.inputAccessoryView = toolBar
        tagTextView.inputAccessoryView = toolBar
    }

    @objc private func saveButtonTapped() {
        memoTextView.isEditable.toggle()
        sentenceTextView.isEditable.toggle()
        tagTextView.isEditable.toggle()

        guard previousItem != nil else { return }

        do {
            try realmModel.saveItem(
                previousItem: previousItem!,
                sentence: sentenceTextView.text,
                memo: memoTextView.text,
                tag: tagTextView.text)

            presentAlert(
                title: "カードが保存されました。",
                message: "",
                buttonTitle: "OK")

        } catch {
            presentErrorAlert(
                title: CRUDError.update.description,
                message: "",
                buttonTitle: "OK")
        }
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func deleteButtonTapped() {
        guard previousItem != nil else { return }
        do {
            try realmModel.deleteItem(previousItem: previousItem!)
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
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func navBarTapped() {
        view.endEditing(true)
    }
}
