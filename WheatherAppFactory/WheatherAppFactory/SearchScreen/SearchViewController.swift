//
//  SearchViewController.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

protocol hideViewController{
    func didLoadData()
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    //MARK: Variables
    let viewModel: SearchViewModel!
    let searchBar: UISearchBar!
    weak var cancelButtonPressed: hideKeyboard!
    var keyboardHeight: CGFloat!
    var bottomConstraint: Constraint?
    let disposeBag = DisposeBag()
    weak var selectedLocationButton: ChangeLocationBasedOnSelection?
    weak var coordinatorDelegate: CoordinatorDelegate?
    var vSpinner : UIView?
    
    
    let searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurryBackground: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let cancelButton: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "cancel_icon"), for: .normal)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: Table view setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.locationData.count != 0 {
            return viewModel.locationData[0].geonames.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataForCellSetup = viewModel.locationData[0].geonames[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? LocationTableViewCell else {
            fatalError("nije settano")
            
        }
        cell.setupCell(data: dataForCellSetup)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.locationData[0].geonames[indexPath.row]
        showSpinner(onView: self.view)
        selectedLocationButton?.didSelectLocation(long: Double(data.lng)!, lat: Double(data.lat)!, location: data.name, countryc: data.countryCode)
    }
    
    
    //MARK: init
    init(model: SearchViewModel, searchBar: UISearchBar) {
        self.viewModel = model
        self.searchBar = searchBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        coordinatorDelegate?.viewControllerHasFinished()
        print("Deinit: \(self)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        prepareForViewModel()
        bindTextFieldWithRx()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
    //MARK: Setup view
    func setupView(){
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "cellID")
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(screenPressed))
        tap.minimumPressDuration = 0
        view.addSubview(blurryBackground)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        
        blurryBackground.addGestureRecognizer(tap)
        cancelButton.addTarget(self, action: #selector(screenPressed), for: .touchUpInside)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setupConstraints()
        
        
    }
    //MARK: Constraints
    func setupConstraints(){

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(searchBar.snp.top).offset(-20)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(tableView).offset(view.bounds.width/25)
            make.trailing.equalTo(tableView).offset(-view.bounds.width/25)
        }
        
        blurryBackground.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        searchBar.snp.makeConstraints { [unowned self] (make) in
            self.bottomConstraint = make.top.equalTo(view.snp.bottom).offset(-60).constraint
            make.leading.trailing.equalTo(view)
        }
        
        
    }
    //MARK: Prepare for view model
    func prepareForViewModel(){
        let input = SearchViewModel.Input(getLocationSubject: PublishSubject<String>())
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        viewModel.output.popUpSubject
               .observeOn(MainScheduler.instance)
               .subscribeOn(viewModel.dependencies.scheduler)
               .subscribe(onNext: {[unowned self] bool in
                       self.showPopUp()
                   }).disposed(by: disposeBag)
        
        reloadTableViewData(subject: viewModel.output.dataDoneSubject).disposed(by: disposeBag)
       }
    
    //MARK: Actions
    @objc func screenPressed(gesture: UITapGestureRecognizer){
        if gesture.state == .began {
            handleHidingViewController()
        }
    }
    
    func handleHidingViewController() {
        removeSpinner()
        cancelButtonPressed.hideViewController()
        searchBar.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        UIView.setAnimationsEnabled(true)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let isKeyboardShown = notification.name == UIResponder.keyboardWillShowNotification
            keyboardHeight = -viewModel.getKeyboardHeight(isKeyboardShown, keyboardFrame)
            
            self.bottomConstraint?.update(offset: self.keyboardHeight)
            
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
   
    //MARK: Bind textfield
    func bindTextFieldWithRx(){
        @discardableResult let _ = searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .enumerated()
            .skipWhile({ (index, value) -> Bool in
                return index == 0
            })
            .map({ (index, value) -> String in
                return value
            })
            .debounce(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: viewModel.input.getLocationSubject)
    }
    
    func reloadTableViewData(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  article in
                self.tableView.reloadData()
            },  onError: {[unowned self] (error) in
                self.viewModel.output!.popUpSubject.onNext(true)
                    print(error)
            })
    }
    //MARK: Spinner
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    func showPopUp(){
        let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }}
extension SearchViewController: hideViewController {
    func didLoadData() {
        handleHidingViewController()
    }
}
