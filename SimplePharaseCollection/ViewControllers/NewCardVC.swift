//
//  CardEdittingVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

final class NewCardVC: UIViewController {

    private let tagTextView = TagTextView(
        fontSize: 12,
        backgroundColor: .systemOrange)
    private let sentenceTextView = PlaceholderTextView(placeholder: "フレーズを入力してください")
    private let memoTextView = PlaceholderTextView(placeholder: "メモ(任意)")
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let cardView = UIView()
    private let realmModel = NewCardVCRealmModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureScrollContentView()
        configureViewController()
        configureTapGesture()
        configureTagTextView()
        configureSentenceTextView()
        configureMemoTextView()
        configureStackView()
        configureCardView()
        configureTagTextView()
    }

    //MARK: - ScrollView & ScrollContentView

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.set(
            constraints: [
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
            ])
    }

    private func configureScrollContentView() {
        scrollView.addSubview(scrollContentView)
        scrollContentView.backgroundColor = .systemBackground
        scrollContentView.set(constraints:[
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
        cardView.set(constraints: [
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
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 20
        let padding: CGFloat = 24
        stackView.set(constraints: [
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
        tagTextView.textContainer.lineBreakMode = .byTruncatingTail
        tagTextView.set(constraints: [
            tagTextView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            tagTextView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tagTextView.heightAnchor.constraint(equalToConstant: 32),
            tagTextView.widthAnchor.constraint(equalToConstant: 130)
        ])
    }

    private func configureSentenceTextView() {
        stackView.addArrangedSubview(sentenceTextView)
        sentenceTextView.font = UIFont.systemFont(ofSize: 20)
        sentenceTextView.layer.cornerRadius = 10
        sentenceTextView.textAlignment = .left
        sentenceTextView.backgroundColor = .secondarySystemBackground
        sentenceTextView.delegate = self
        sentenceTextView.set(constraints: [
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
        memoTextView.backgroundColor = .secondarySystemBackground
        memoTextView.set(constraints: [
            memoTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}

//MARK: - UITextView Delegate
extension NewCardVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == sentenceTextView {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

//MARK: - ViewController Setting
private extension NewCardVC {
    func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "New Card"

        let addButton = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addButtonPressed))

        navigationItem.rightBarButtonItem = addButton

        let tapGestureForNavi = UITapGestureRecognizer(
            target: self,
            action: #selector(navBarTapped))

        navigationController?.navigationBar.addGestureRecognizer(tapGestureForNavi)
    }

    //MARK: - Button Actions

    @objc func addButtonPressed() {
        guard sentenceTextView.text != nil && sentenceTextView.text != "" else {
            presentErrorAlert(
                title: "フレーズセクションが空です。",
                message: "フレーズを入力してください。",
                buttonTitle: "OK")
            return
        }

        do {
            try realmModel.createData(sentence: sentenceTextView.text, memo: memoTextView.text, tag: tagTextView.text)
            presentAlert(
                title: "カードが追加されました。",
                message: "",
                buttonTitle: "OK")
        } catch {
            presentErrorAlert(
                title: CRUDError.create.description,
                message: "",
                buttonTitle: "OK")
        }
        resetCardView()
    }

    func resetCardView() {
        sentenceTextView.text = ""
        memoTextView.text = ""
        tagTextView.text = "Phrase"
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tagTextView.becomeFirstResponder()
    }

    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(with:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard(with gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func navBarTapped() {
        view.endEditing(true)
    }
}
