//
//  TransVC.swift
//  OrangeBank
//
//  Created by Luis Rodrigues on 24/01/2019.
//  Copyright © 2018 Luis Rodrigues. All rights reserved.
//

import Alamofire
import DateToolsSwift
import DZNEmptyDataSet
import MaterialComponents
import SnapKit
import UIKit
import UnboxedAlamofire

class TransVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var apiError = false
    var dateFormatter = DateFormatter()
    var refreshControl: UIRefreshControl!
    var transactions: [Transaction]? {
        didSet {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            tableView.reloadData()
        }
    }
    var lastTrans: Transaction?
    var restTrans: [Transaction]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "TransHeaderCell", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "TransCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        fetchData()
    }
    
    // MARK: - Internal methods
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        fetchData()
    }
    
    func fetchData() {
        
        let route = TransAPI.list()
        Alamofire.request(route).responseArray {(response: DataResponse<[Transaction]>) in
            
            if response.response?.statusCode == 200 {
                
                if let result = response.result.value {
                    
                    self.apiError = false
                    self.transactions = result.filter({ $0.date != nil }).sorted(by: { $0.date!.compare($1.date!) == .orderedDescending }).removeDuplicates(byKey: { $0.id })
                }
                else {
                    
                    self.apiError = true
                    self.transactions = []
                }
            }
            else {
                
                self.apiError = true
                self.transactions = []
            }
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension TransVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard ((transactions) != nil) else {
            
            return 0
        }
        
        return (transactions?.count)! > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Header") as! TransHeaderCell
        
        if let data = transactions?[0] {
            
            cell._date.text        = dateFormatter.string(from: data.date!)
            cell._description.text = data.description ?? ""
            cell._amount.text      = "\(String(data.amount))€"
            cell._amount.textColor = data.amount >= 0 ? UIColor(rgb: 0x006400, alpha: 0.87) : UIColor(rgb: 0xff0000, alpha: 0.87)
            
            guard ((data.fee) != nil) else {
                
                cell._fee.text = ""
                
                return cell
            }
            
            cell._fee.text = "Comisión: \(String(data.fee!))€"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 166.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard ((transactions) != nil) else {
            
            return 0
        }
        
        return (transactions?.count)! - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransCell
        
        if let data = transactions?[indexPath.row + 1] {
            
            cell._day.text         = String(data.date!.day)
            cell._month.text       = String(dateFormatter.shortMonthSymbols[data.date!.month - 1]).capitalized
            cell._description.text = data.description ?? ""
            cell._amount.text      = "\(String(data.amount))€"
            cell._amount.textColor = data.amount >= 0 ? UIColor(rgb: 0x006400, alpha: 0.87) : UIColor(rgb: 0xff0000, alpha: 0.87)
            
            guard ((data.fee) != nil) else {
                
                cell._fee.text = ""
                
                return cell
            }
            
            cell._fee.text = "Comisión: \(String(data.fee!))€"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 84.0
    }
}


// MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension TransVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        if apiError {
            
            return UIImage(named: "im_server_error")
        }
        
        return UIImage(named: "im_empty_search")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        if apiError {
            
            let str = "Ups, algo salió mal."
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x000000, alpha: 0.87)]
            
            return NSAttributedString(string: str, attributes: attrs)
        }
        
        let str = "No se encontraron transacciones!"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x000000, alpha: 0.87)]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        if apiError {
            
            let str = "Se ha producido un error desconocido, pero estamos trabajando lo más rápido posible para solucionarlo. Gracias por su paciencia."
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x000000, alpha: 0.87)]
            
            return NSAttributedString(string: str, attributes: attrs)
        }
        
        let str = "Su búsqueda de transacciones no arrojó ningún resultado. Por favor, inténtelo de nuevo más tarde."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x000000, alpha: 0.87)]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        
        return UIColor(rgb: 0xf5f5f5)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        if transactions != nil {
            
            return nil
        }
        
        let activityIndicator = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        activityIndicator.cycleColors = [UIColor.init(rgb: 0xE5875A)]
        tableView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(tableView)
        }
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        
        return true
    }
    
    func emptyDataSetWillAppear(_ scrollView: UIScrollView!) {
        
        if transactions == nil {
            
            tableView.contentOffset = CGPoint(x: 0, y: -tableView.contentInset.top)
        }
    }
}
