//
//  ViewController.swift
//  GithubStargazers
//
//  Created by Aleksandr Milashevski on 01/03/21.
//

import UIKit
import Network
import Alamofire

class ViewController: UIViewController {
    
    //    MARK: - Outlets
    @IBOutlet weak var stargazersTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerSubView: UIView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var conectionView: UIView!
    
    //    MARK: - let
    let requestManager = RequestManager<RequestRouter>()
    
    //    MARK: - var
    var listStargazer = [ListStargazer]() {
        didSet {
            DispatchQueue.main.async {
                self.stargazersTableView.reloadData()
            }
        }
    }
    
    var requestError = ""
    var requestErrorMessage: String? {
        get {
            return requestError
        }
        set {
            requestError = newValue ?? ""
            if requestError != "" {
                alertOneButton(title: "\(requestError)", message: Constants.errorMessage, titleAction: Constants.titleActionAlertError, style: .alert) { _ in
                    self.alertSearchRepo()
                    print(#function)
                }
            }
        }
    }
    
    // My value for TEST
    var myOwner = "JohnSundell"
    var myRepo = "Publish"
    
    //    MARK: - Lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        alertSearchRepo()
        configTableView()
        monitorNetwork()
    }
    
    //    MARK: - IBActions
    @IBAction func addRepoButton(_ sender: UIBarButtonItem) {
        alertSearchRepo()
    }
    
    //    MARK: - Flow funcs
    private func configTableView() {
        stargazersTableView.delegate = self
        stargazersTableView.dataSource = self
        stargazersTableView.separatorStyle = .none
    }
    
    private func configUI() {
        headerSubView.layer.cornerRadius = Constants.viewCornerValue
        headerSubView.myShadow()
    }
    
    private func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.conectionView.isHidden = true
                    print("internet connection is present")
                }
            } else {
                DispatchQueue.main.async {
                    self.conectionView.isHidden = false
                    print("no internet connection")
                }
            }
        }
        let queue = DispatchQueue.global()
        monitor.start(queue: queue)
    }
    
    private func sendRequest() {
        requestManager.send(service: .getListOfStargazers(pagen: Constants.indexOfPageToRequest), decodeType: [ListStargazer].self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.ownerLabel.text = Constants.ownerForRequest
                self?.repoLabel.text = Constants.repoForRequest
                self?.listStargazer = response
                DispatchQueue.main.async {
                    self?.stargazersTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.requestError = String("\(error)")
                    print(error)
                }
            }
        }
    }
    
    private func sendRequestPagination() {
        requestManager.send(service: .getListOfStargazers(pagen: Constants.indexOfPageToRequest), decodeType: [ListStargazer].self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.listStargazer.append(contentsOf: response)
                DispatchQueue.main.async {
                    self?.stargazersTableView.reloadData()
                }
                print("load page \(Constants.indexOfPageToRequest)")
            case .failure(let error):
                self?.requestError = String("\(error)")
                print(error)
            }
        }
    }
}

//MARK: - UITableViewDelegate + UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStargazer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewCell") as? CustomViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let myList = listStargazer[indexPath.row]
        cell.configCell(with: myList)
        return cell
    }
}

//MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // calculates where the user is in the y-axis
        let headerViewhight = headerView.frame.size.height
        let position = scrollView.contentOffset.y + headerViewhight
        let contentHeight = view.bounds.size.height
        let scrollViewHight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHight) {
            
            // increments the number of the page to request
            Constants.indexOfPageToRequest += 1
            sendRequestPagination()
        }
    }
}

//MARK: - UIAlertController
extension ViewController {
    
    private func alertSearchRepo() {
        let alert = UIAlertController(title: Constants.titleAlertSearch, message: Constants.messageOfSearchAlert, preferredStyle: .alert)
        
        alert.addTextField { textFieldOwner in
            textFieldOwner.placeholder = Constants.ownerPlaceholderAlert
            textFieldOwner.autocapitalizationType = .words
            
            alert.addTextField { textFieldRepo in
                textFieldRepo.placeholder = Constants.repoPlaceholderAlert
                textFieldRepo.autocapitalizationType = .words
            }
        }
        
        let action = UIAlertAction(title: Constants.titleActionOfSearchAlert, style: .default) { action in
            let ownerTextField = alert.textFields?[0]
            let repoTextField = alert.textFields?[1]
            
            guard let ownerName = ownerTextField?.text else { return }
            guard let repoName = repoTextField?.text else { return }
            
            if !ownerName.isEmpty && !ownerName.isEmpty {
                let owner = ownerName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
                let repo = repoName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
                
                Constants.ownerForRequest = owner!
                Constants.repoForRequest = repo!
                self.sendRequest()
            }
        }
        let cancelAction = UIAlertAction(title: Constants.titleCancelActionOfSearchAlert, style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
