//
//  ViewController.swift
//  NearMe
//
//  Created by Zahraa Herz on 12/10/2023.
//

import UIKit

class InitTableViewController: UITableViewController {
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*,unavailable , message: "Nibs are unsupported")
    public required init?(coder: NSCoder) {
        fatalError("Nibs are Unsupported")
    }

}
