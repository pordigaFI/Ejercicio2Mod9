//
//  FugitivesTableViewController.swift
//  BountyHunter
//
//  Created by Ángel González on 11/11/23.
//

import UIKit

class FugitivesTableViewController: UITableViewController {
    var items = Fugitives()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(loadData), for:.valueChanged)
        self.refreshControl = refreshControl
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Optimizar la llamada al backend solo cuando el usuario haga swipe hacia abajo
    }
    
    @objc func loadData() {
        if InternetMonitor.shared.internetStatus {
            APIService().getTodos { fugitives in
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                    if fugitives != nil {
                        self.items = fugitives!
                        self.tableView.reloadData()
                    }
                }
            }
        }
        else {
            refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        self.performSegue(withIdentifier: "detail", sender:item)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        destinationVC.fugitive = sender as? Fugitive
    }

}
