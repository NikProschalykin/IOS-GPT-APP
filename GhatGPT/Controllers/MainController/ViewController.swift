//
//  ViewController.swift
//  GhatGPT
//
//  Created by Николай Прощалыкин on 14.06.2023.
//

// MARK: - START API SOON
//Task {
//    let api = ChatAPI(apiKey: ViewController.apiKey)
//    do {
////                //потоковый
////                let stream = try await api.sendMessageStream(text: "What is James Bond")
////                for try await line in stream {
////                    print(line)
////                }
//
//        //непотоковый
//        let text = try await api.sendMessage("What is James bond?")
//        print(text)
//    } catch {
//        print(error.localizedDescription)
//    }
//}

// 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 - Данин

import UIKit

// MARK: - VIEWCONTROLLER

class ViewController: BaseController {
    
    //MARK: - PROPERTIES
    public static var textModels = TextModel.makeMockModel()
    
    static var apiKey = "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"//"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"
    private let notificationCenter = NotificationCenter.default
    
    private let contentView = BaseView()
    private let scrollView = ViewControllerScrollView()
    private let footer = MainFooter()
    
    private let layout = ChatCollectionLayout()
    private lazy var collectionView = ChatCollection(frame: .zero, collectionViewLayout: layout)
    
    //MARK: - GESTURES
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    
    
//MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notificationCenter.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyBoardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//MARK: - ViewDidDissappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let api = ChatAPI(apiKey: ViewController.apiKey)
            do {
//                //потоковый
//                let stream = try await api.sendMessageStream(text: "What is James Bond")
//                for try await line in stream {
//                    print(line)
//                }
                
                                //непотоковый
                                let text = try await api.sendMessage("What sun is?")
                                print(text)
                            } catch {
                                print(error.localizedDescription)
            }
        }
    }
//MARK: - CONFIGURE
    override func configure() {
        super.configure()
        contentView.backgroundColor = .blue
        collectionView.reloadData()
    
    }
//MARK: - ADD VIEWS
    override func addViews() {
        super.addViews()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(footer)
        contentView.addSubview(collectionView)
        
        view.addGestureRecognizer(tapGesture)
        
    }
    
//MARK: - LAYOUT
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            
            //scrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
          
            //contentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            //collectionView
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footer.topAnchor, constant: -8),
            
            
            //footer
            footer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            footer.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}

//MARK: - extension
@objc extension ViewController {
    
    //MARK: - keyBoardShow
    private func keyBoardShow(notification: NSNotification){
        if let keyBoardSize: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.setContentOffset(CGPoint(x: 0, y: keyBoardSize.height), animated: true)
        }
    }
    
    //MARK: - keyBoardHide
    private func keyBoardHide() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)

    }
}
