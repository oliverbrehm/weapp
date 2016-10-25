//
//  SearchTVC.swift
//  weApp
//
//  Created by sohrab on 24/10/16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit
import MapKit

protocol SearchTVCDelegate {
    func returnPlacemark(placeMark: MKPlacemark)
}

struct address {
    var name:String = ""
    var street:String = ""
    var city:String = ""
    var country: String = ""
    var zipCode: String = ""
}



class SearchTVC: UITableViewController {
    
    var delegate : SearchTVCDelegate! = nil
    let locationManager = CLLocationManager()
    var searching = false
    var results:[MKMapItem]?
    var addresses = [address]()
    // user location
    var location: CLLocation = CLLocation.init()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var ResultsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ResultsTable.dataSource = self
        ResultsTable.delegate = self
        
        // ask for user location permission
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {

        guard results?.count != 0 else {return}
        guard let place = results?[indexPath.row].placemark else {return}
        delegate.returnPlacemark(placeMark: place)
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResultsTable.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddressCell
        cell.locationName.text = addresses[indexPath.row].name
        cell.locationStreet.text = addresses[indexPath.row].street
        cell.locationCity.text = addresses[indexPath.row].city
        cell.locationZip.text = addresses[indexPath.row].zipCode
        cell.locationCountry.text = addresses[indexPath.row].country
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
}
extension SearchTVC: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) // called when keyboard search button pressed
    {
        searchBar.resignFirstResponder()
        addresses.removeAll()
        
        // make a request
        let request = MKLocalSearchRequest()
        
        // set search region around the current user location
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        request.region = MKCoordinateRegion(center: location.coordinate, span: span)
        request.naturalLanguageQuery = searchBar.text
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard error == nil else {print(error?.localizedDescription); return }
            guard let response = response else { return }
            guard response.mapItems.count > 0 else { return }
            self.results = [MKMapItem]()
            for m in response.mapItems
            {
                let loc = m.placemark as CLPlacemark
                self.results?.append(m)
                let addDic = loc.addressDictionary
                var add = address()
                if (addDic?["Name"]) != nil
                {
                    add.name = addDic?["Name"] as! String
                }
                else
                {
                    add.name = ""
                }
                if (addDic?["Street"]) != nil
                {
                    add.street = addDic?["Street"] as! String
                }
                else
                {
                    add.street = ""
                }
                if (addDic?["Street"]) != nil
                {
                    add.city = addDic?["City"] as! String
                }
                else
                {
                    add.city = ""
                }
                if (addDic?["Street"]) != nil
                {
                    add.country = addDic?["Country"] as! String
                }
                else
                {
                    add.country = ""
                }
                if (addDic?["ZIP"]) != nil
                {
                    add.zipCode = addDic?["ZIP"] as! String
                }
                else
                {
                    add.zipCode = ""
                }
                self.addresses.append(add)
            }
            self.ResultsTable.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        searchBar.resignFirstResponder()
    }
}

// MARK:- MKlocalsearch delegate
extension SearchTVC: MKLocalSearchCompleterDelegate
{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
    {
        print("func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)")
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error)
    {
        print("func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error)")
    }
}

// MARK:- SearchAddressViewController : Location delegate
extension SearchTVC: CLLocationManagerDelegate {
    
    @objc(locationManager:didChangeAuthorizationStatus:) func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            location = locations.first!
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}
