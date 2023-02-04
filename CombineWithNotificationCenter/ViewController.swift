//
//  ViewController.swift
//  CombineWithNotificationCenter
//
//  Created by Mashqur Habib Himel on 3/2/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private lazy var bookName: UILabel = {
        let bookName = UILabel()
        bookName.translatesAutoresizingMaskIntoConstraints = false
        bookName.draw(CGRect(x: 0, y: 0, width: 5, height: 0))
        bookName.layer.borderWidth = 1
        bookName.layer.borderColor = UIColor.blue.cgColor
        bookName.textColor = .brown
        return bookName
    }()
    
    private lazy var blogname: UILabel = {
        let blogname = UILabel()
        blogname.translatesAutoresizingMaskIntoConstraints = false
        return blogname
    }()
    
    private lazy var bookNameInput: UITextField = {
        let bookNameInput = UITextField()
        bookNameInput.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        bookNameInput.leftView = paddingView
        bookNameInput.leftViewMode = .always
        bookNameInput.placeholder = "book name"
        bookNameInput.tintColor = .blue
        bookNameInput.textColor = .brown
        bookNameInput.layer.borderColor = UIColor.blue.cgColor
        bookNameInput.layer.borderWidth = 1
        return bookNameInput
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bookNameInput.delegate = self
        setUpviews()
        let bookPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBookName).map({
            (notification) -> String? in
            return (notification.object as? Books)?.title
        })
        
        let lastBookNameSubscriber = Subscribers.Assign(object: bookName, keyPath: \.text)
        bookPostPublisher.subscribe(lastBookNameSubscriber)
    }
    
    private func setUpviews() {
        view.addSubview(bookName)
        view.addSubview(bookNameInput)
        
        NSLayoutConstraint.activate([
            bookName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            bookName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            bookName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            bookName.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            bookNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            bookNameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            bookNameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            bookNameInput.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}

extension Notification.Name {
    static let newBookName = Notification.Name("new_book_post")
}

struct Books {
    let title: String
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let bookName = Books(title: textField.text ?? "")
        NotificationCenter.default.post(name: .newBookName, object: bookName)
        return true
    }
}



