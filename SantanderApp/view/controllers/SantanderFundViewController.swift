//
//  SantanderFundViewController.swift
//  SantanderApp
//
//  Created by Andre Nogueira on 30/04/18.
//  Copyright © 2018 Andre Nogueira. All rights reserved.
//

import UIKit
import SnapKit

protocol BuilderFundView2{
    func buildFundMainView(screenInfo: ScreenInfo)
    func buildFundStatsView(moreInfoMonth: MoreInfoScreen)
    func buildCDIStatsView(moreInfoMonth: MoreInfoScreen)
}

class SantanderFundViewController: UIViewController {
    
    
    @IBOutlet weak var fundTableView: UITableView!
    
    @IBOutlet var santanderFundView: SantanderFundView!
    var downInfo: [DownInfo]?
    var info: [Info]?
    override func viewDidLoad() {
        self.fundTableView.delegate = self
        self.fundTableView.dataSource = self
        
        self.registerTableViewCell()
        
        SantanderPresenter.sharedManager.fetchedFundScreen(completion: { (screen, error) in
            
            let screenInfo = screen?.screenData!
            self.buildFundMainView(screenInfo: screenInfo!)
            
            let moreInfoMonth =  (screenInfo?.moreInfo)!
            self.buildFundStatsView(moreInfoMonth: moreInfoMonth)
            self.buildCDIStatsView(moreInfoMonth: moreInfoMonth)
            self.downInfo = screenInfo?.downinfo
            self.info = screenInfo?.info
            self.fundTableView.reloadData()
            
        })
    }
    
    private func registerTableViewCell(){
        self.fundTableView.register(UINib(nibName: "SantanderFundTableViewCell", bundle: nil), forCellReuseIdentifier: "SantanderFundTableViewCell")
        
    }
    
    @objc func clickedDownloadButton(){
        self.startWebView(url: "https://www.google.com")
    }
}

extension SantanderFundViewController: BuilderFundView2{
    func buildFundMainView(screenInfo: ScreenInfo){
        let fundName = (screenInfo.fundName)!
        let topTitle = (screenInfo.title)!
        let definition = (screenInfo.definition)!
        let riskTitle = (screenInfo.riskTitle)!
        let whatIs = (screenInfo.whatIs)!
        let moreInfo = (screenInfo.infoTitle)!
        let risk = (screenInfo.risk)!
        self.santanderFundView.startFundView(subtitle: topTitle, fundName: fundName, whatIs: whatIs, riskTitle: riskTitle, definitionLabel: definition, moreInfo: moreInfo, risk: risk)
    }
    
    func buildFundStatsView(moreInfoMonth: MoreInfoScreen){
        let monthlyFund = String(format:"%.1f", (moreInfoMonth.month!["fund"]!)) + "%"
        let annuallyFund = String(format:"%.1f", (moreInfoMonth.year!["fund"]!)) + "%"
        let twelveMonthsFund = String(format:"%.1f", (moreInfoMonth.twelvemonths!["fund"]!)) + "%"
        
        self.santanderFundView.startFundStats(monthlyFund: monthlyFund, annuallyFund: annuallyFund, twelveMonthsFund: twelveMonthsFund)
    }
    
    func buildCDIStatsView(moreInfoMonth: MoreInfoScreen){
        let monthlyCDI = String(format:"%.1f", (moreInfoMonth.month!["CDI"]!)) + "%"
        let annuallyCDI = String(format:"%.1f", (moreInfoMonth.year!["CDI"]!)) + "%"
        let twelveMonthsCDI = String(format:"%.1f", (moreInfoMonth.twelvemonths!["CDI"]!)) + "%"
        
        self.santanderFundView.startCDIStats(monthlyCDI: monthlyCDI, annuallyCDI: annuallyCDI, twelveMonthsCDI: twelveMonthsCDI)
    }
    
    
}

extension SantanderFundViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.downInfo == nil && self.info == nil){
            return 0
        }
        return (self.downInfo?.count)! + (self.info?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.downInfo == nil && self.info == nil){
            return SantanderFundTableViewCell()
        }
        
        let cell = fundTableView.dequeueReusableCell(withIdentifier: "SantanderFundTableViewCell", for: indexPath) as! SantanderFundTableViewCell
        
        if(indexPath.row < (self.info?.count)!){
            let index = indexPath.row
            if let nameValue = self.info![index].name {
                cell.name.text = nameValue
            }
            if let dataValue = self.info![index].data {
                cell.data.text = dataValue
            }else{
                cell.data.text = "Baixar"
            }
        }else{
            let index = indexPath.row - (self.info?.count)!
            if let nameValue = self.downInfo![index].name {
                cell.name.text = nameValue
            }
            if let dataValue = self.downInfo![index].data {
                cell.data.text = dataValue
            }else{
                cell.data.text = "Baixar"
            
                self.unHideDownloadIcon(cell: cell)
            }
        }
        
        
        self.santanderFundView.tableViewHeightConstraint.constant += cell.frame.height
//        self.santanderFundView.scrollViewConstraint.constant += cell.frame.height
        return cell
        
    }
    
    func unHideDownloadIcon(cell: SantanderFundTableViewCell){
        cell.downloadIcon.isHidden = false
        cell.downloadIcon.addTarget(self, action: #selector(clickedDownloadButton), for: UIControlEvents.touchUpInside)
    }
    
}

extension SantanderFundViewController: UIWebViewDelegate{
    
    func startWebView(url: String){
        let myWebView:UIWebView = UIWebView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    
        self.view.addSubview(myWebView)
    
        myWebView.delegate = self
    
        let myURL = URL(string: url)
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        myWebView.loadRequest(myURLRequest)
    }
}

