//
//  FormsListViewController.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import UIKit

class FormsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedForm:Int?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.forms?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        let item = Data.forms![indexPath.row]
        cell.imageTitle.image = UIImage(named: "list")
        cell.title.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedForm = indexPath.row
        performSegue(withIdentifier: "showForm", sender: self)
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getList()
        // Do any additional setup after loading the view.
    }
    
    
    
    func getList(){
        let load = loading(view: self.view, text: "Please Wait...")
        getFormList(){ val in
            load.hide(animated: true)
            if val.error ?? true {
                let dialog = createDialog(message: "Connection Error")
                self.present(dialog, animated: true, completion: nil)
                print(val.code ?? -1)
            } else {
                Data.forms = val.forms
                self.tableView.reloadData()
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        segue.destination.modalPresentationStyle = .fullScreen
        if let dest = segue.destination as? ViewFormViewController {
            dest.formId = selectedForm
        }
    }
    

}
