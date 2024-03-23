//
//  CardEdittingVC.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit
import RealmSwift

final class CardEdittingVC: UIViewController {

    private let tagTextView = CustomLabelTextView(fontSize: 12, backgroundColor: .systemOrange)
    private let sentenceTextView = UITextView()
    private let memoTextView = UITextView()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let cardView = UIView()
    private let realm = try! Realm()

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
        tagTextView.text = "Sample Title"
        tagTextView.isEditable = true

        NSLayoutConstraint.activate([
            tagTextView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            tagTextView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tagTextView.heightAnchor.constraint(equalToConstant: 24),
            tagTextView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureSentenceTextView() {
        stackView.addArrangedSubview(sentenceTextView)
        sentenceTextView.font = UIFont.systemFont(ofSize: 20)
        sentenceTextView.layer.cornerRadius = 10
        sentenceTextView.textAlignment = .left
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = false
        sentenceTextView.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            sentenceTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            sentenceTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            sentenceTextView.heightAnchor.constraint(equalToConstant: 190)
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
            memoTextView.topAnchor.constraint(equalTo: sentenceTextView.bottomAnchor, constant: 24),
            memoTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            memoTextView.heightAnchor.constraint(equalTo: sentenceTextView.heightAnchor)
        ])
    }

    //MARK: - ConfigureViewController

    private func configureViewController() {
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

    @objc private func addButtonPressed() {

        guard sentenceTextView.text != nil && sentenceTextView.text != "" else {
            presentAlertOnMainThread(
                title: "Type something.",
                message: "",
                buttonTitle: "OK")
            return
        }
        addNewItem()
        resetCardView()
    }

    private func addNewItem() {
        let newItem = ItemData()
        newItem.sentence = sentenceTextView.text
        newItem.memo = memoTextView.text
        newItem.tag = tagTextView.text

        do {
            try realm.write {
                realm.add(newItem)
                presentAlertOnMainThread(
                    title: "カードが追加されました",
                    message: "",
                    buttonTitle: "OK")
            }
        } catch {
            print("error")
        }
    }

    private func resetCardView() {
        sentenceTextView.text = ""
        memoTextView.text = ""
        tagTextView.text = "Phrase"
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tagTextView.becomeFirstResponder()
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(with:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard(with gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func navBarTapped() {
        view.endEditing(true)
    }
}

//#Preview {
//    let vc = CardEdittingVC()
//    return vc
//}
