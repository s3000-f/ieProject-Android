//
//  ViewFormViewController.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import UIKit
import LocationPicker
import CoreLocation
import GoogleMaps
import PopupDialog

class ViewFormViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var hasSubmitted = false
    @IBAction func submit(_ sender: Any) {
        if hasSubmitted {
            return
        }
        for i in 0..<(form?.fields?.count ?? 0) {
            let f = form!.fields![i]
            if f.isRequired! && (datas![i] == nil || datas![i] == ""){
                let dialog = createDialog(message: "Please Fill All Fields Marked With *")
                self.present(dialog, animated: true, completion: nil)
                return
            }
            let load = loading(view: self.view, text: "Please Wait...")
            submitForm(form: form!, datas: datas!){ val in
                load.hide(animated: true)
                if val.error ?? true {
                    print(val.code ?? -1)
                    let dialog = createDialog(message: "Connection Error")
                    self.present(dialog, animated: true, completion: nil)
                } else {
                    self.hasSubmitted = true
                    let dialog = createDialog(message: "Data Sent Successfully")
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        }
    }
    var datas:[String?]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form?.fields?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = form!.fields![indexPath.row]
        var cell = UITableViewCell()
        var title = "\(item.title!): "
        if item.isRequired ?? false {
            title = "\(item.title!)*: "
        }
        switch item.fieldType {
        case .Text:
            let inCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextNumberCell
            inCell.title.text = title
            inCell.input.tag = indexPath.row
            inCell.input.placeholder = "Enter \(item.title!)"
            inCell.input.addTarget(self, action: #selector(setText(_:)), for: .editingDidEnd)
            cell = inCell
            break
        case .Number:
            let inCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextNumberCell
            inCell.title.text = title
            inCell.input.tag = indexPath.row
            inCell.input.placeholder = "Enter \(item.title!)"
            inCell.input.keyboardType = .numberPad
            inCell.input.addTarget(self, action: #selector(setText(_:)), for: .editingDidEnd)
            cell = inCell
            break
        case .Date:
            let inCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            inCell.title.text = title
            inCell.dropdown.tag = indexPath.row
            inCell.dropdown.addTarget(self, action: #selector(openDatePicker(_:)), for: .touchUpInside)
            cell = inCell
            break
        case .DropDown:
            let inCell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath) as! DropdownCell
            inCell.title.text = title
            inCell.dropdown.tag = indexPath.row
            inCell.dropdown.addTarget(self, action: #selector(openDropdown(_:)), for: .touchUpInside)
            cell = inCell
            break
        case .Location:
            let inCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
            inCell.title.text = title
            inCell.select.tag = indexPath.row
            inCell.select.addTarget(self, action: #selector(openLocationPicker(_:)), for: .touchUpInside)
            let camera = GMSCameraPosition.camera(withLatitude: 34, longitude: 52, zoom: 4)
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: inCell.mapView.bounds.size.width, height: inCell.mapView.bounds.size.height), camera: camera)
            if let ops = item.options {
                for o in ops {
                    let initialLocation = CLLocationCoordinate2DMake(o.lat!, o.lng!)
                    let marker = GMSMarker(position: initialLocation)
                    marker.title = o.label!
                    marker.map = mapView
                }
            }
            

            inCell.mapView.addSubview(mapView)
            cell = inCell
            break
        case .none:
            break
        }
        
        return cell;
    }
    
    var formId:Int?
    var form:Form?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        form = Data.forms?[formId!]
        getFields()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    
    
    
    func getFields(){
        let load = loading(view: self.view, text: "Please Wait...")
        getForm(id: form!.id!){ val in
            load.hide(animated: true)
            if val.error ?? true {
                let dialog = createDialog(message: "Connection Error")
                self.present(dialog, animated: true, completion: nil)
                print(val.code ?? -1)
            } else {
                self.form?.fields = val.fields
                self.datas = [String?](repeating: nil, count: val.fields!.count)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func setText(_ sender:UITextField) {
        if sender.text != nil && sender.text != "" {
            self.datas![sender.tag] = sender.text
        }
    }
    @objc func openDatePicker(_ sender:UIButton) {
        RPicker.selectDate(title: "Select Date", datePickerMode: .date, didSelectDate: { [weak self](selectedDate) in
            let df = DateFormatter()
            df.dateFormat = "YYY/MM/dd"
            let text = df.string(from: selectedDate)
            self?.datas?[sender.tag] = text
            sender.setTitle(text, for: .normal)
        })
    }
    @objc func openDropdown(_ sender:UIButton) {
        let item = form!.fields![sender.tag]
        var options = [String]()
        for i in item.options! {
            options.append(i.textValue!)
        }
        RPicker.selectOption(title: "Select \(item.title!)", hideCancel: true, dataArray: options, selectedIndex: 0) {[weak self] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            self?.datas?[sender.tag] = selctedText
            sender.setTitle(selctedText, for: .normal)
        }
        
    }
    
    @objc func openLocationPicker(_ sender:UIButton) {
        let item = form!.fields![sender.tag]
        let locationPicker = LocationPickerViewController()
        if let ops = item.options {
            var lat = 0.0
            var lng = 0.0
            for o in ops {
                lat += o.lat!
                lng += o.lng!
            }
            // you can optionally set initial location
            if lat != 0 || lng != 0 {
                let la = lat/Double(item.options!.count)
                let ln = lng/Double(item.options!.count)
                let location = CLLocation(latitude: la, longitude: ln)
                let initialLocation = Location(name: "Location", location: location, placemark: CLPlacemark())
                locationPicker.location = initialLocation
            }
        }

        locationPicker.showCurrentLocationButton = true // default: true
        locationPicker.currentLocationButtonBackground = .lightGray
        locationPicker.showCurrentLocationInitially = true // default: true
        locationPicker.mapType = .standard // default: .Hybrid
        locationPicker.useCurrentLocationAsHint = true // default: false
        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"
        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"
        locationPicker.resultRegionDistance = 500 // default: 600
        locationPicker.completion = { location in
            if let loca = location {
                let lat = loca.location.coordinate.latitude
                let lng = loca.location.coordinate.longitude
                let loc = "lat=\(lat)&long=\(lng)"
                self.datas?[sender.tag] = loc
                if  item.options != nil {
                    self.form?.fields?[sender.tag].options?.append(FieldOptions(label: "SelectedLocation", lat: lat, lng: lng))
                } else {
                    self.form?.fields?[sender.tag].options = [FieldOptions]()
                    self.form?.fields?[sender.tag].options?.append(FieldOptions(label: "SelectedLocation", lat: lat, lng: lng))
                }
                self.updateCell(path: sender.tag)
                print("Location: \(loc)")
            }

        }

        navigationController?.pushViewController(locationPicker, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func updateCell(path:Int){
        let indexPath = IndexPath(row: path, section: 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic) //try other animations
        tableView.endUpdates()
    }
}
