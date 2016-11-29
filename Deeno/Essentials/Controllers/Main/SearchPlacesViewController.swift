//
//  SearchPlacesViewController.swift
//  Deeno
//
//  Created by Michal Severín on 29.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import GooglePlaces
import UIKit

class SearchPlacesViewController: AbstractViewController, UISearchDisplayDelegate {
    
    // MARK: - Properties
    fileprivate var searchBar: UISearchBar?
    fileprivate var tableDataSource: GMSAutocompleteTableDataSource?
    fileprivate var resultsViewController: GMSAutocompleteResultsViewController?
    fileprivate var searchController: UISearchController?
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 250.0, height: 44.0))

        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource?.delegate = self
        
        if let searchbar = searchBar {
            searchController = UISearchController(searchResultsController: resultsViewController)
            searchController?.searchResultsUpdater = resultsViewController
            searchController?.searchBar.sizeToFit()
            searchController?.hidesNavigationBarDuringPresentation = false
            searchController?.dimsBackgroundDuringPresentation = false
            searchController?.hidesNavigationBarDuringPresentation = false

            self.view.addSubview(searchbar)
        }
    }
}

// MARK: - <GMSAutocompleteTableDataSourceDelegate>
extension SearchPlacesViewController: GMSAutocompleteTableDataSourceDelegate {
    
    public func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
    
        print(place.name)
    }
    
    public func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {}
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        print(place.name)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
