//
//  ViewController.swift
//  UITableViewIndex
//
//  Created by Henrique Valcanaia on 2019-12-03.
//  Copyright © 2019 Henrique Valcanaia. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var indicesSwitch: UISwitch!
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: UIScreen.main.bounds)
        sv.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: UIScreen.main.bounds.height)
        sv.delegate = self
        return sv
    }()
    
    private var t1: UITableView!
    private var t2: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: String(describing: Cell.self), bundle: Bundle(for: Cell.self))
        
        self.t1 = UITableView(frame: self.scrollView.frame)
        self.t1.dataSource = self
        self.t1.delegate = self
        self.t1.estimatedRowHeight = 44
        self.t1.rowHeight = UITableView.automaticDimension
        self.t1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.t1.translatesAutoresizingMaskIntoConstraints = false
        self.t1.register(cellNib, forCellReuseIdentifier: "Cell")
        self.scrollView.addSubview(self.t1)
        
        let frame = CGRect(origin: CGPoint(x: self.t1.frame.maxX, y: 0), size: self.t1.frame.size)
        self.t2 = UITableView(frame: frame)
        self.t2.dataSource = self
        self.t2.delegate = self
        self.t2.estimatedRowHeight = 44
        self.t2.rowHeight = UITableView.automaticDimension
        self.t2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.t2.translatesAutoresizingMaskIntoConstraints = false
        self.t2.register(cellNib, forCellReuseIdentifier: "Cell")
        self.scrollView.addSubview(self.t2)
        
        self.view.addSubview(self.scrollView)
        self.view.bringSubviewToFront(self.indicesSwitch)
    }
    
    @IBAction func toggled(_ sender: Any) {
        self.t1.reloadData()
        self.t2.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    
}
    
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell else {
            return UITableViewCell()
        }
        
        cell.customLabel.text = String(repeating: "\(indexPath.row)", count: 5)
        cell.customImage.image = UIImage(named: "Sgt_Peppers.jpg")
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard indicesSwitch.isOn else {
            return nil
        }
        
        let numbers: [Int] = Array(1...10)
        let indices = numbers.map { "\($0)" }
        return indices
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let page = (scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) >= scrollView.frame.width).intValue
        let newXOffset = scrollView.frame.width * CGFloat(page)
        scrollView.setContentOffset(CGPoint(x: newXOffset, y: 0), animated: true)
    }
}
