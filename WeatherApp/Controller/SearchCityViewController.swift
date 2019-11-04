//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Vidya on 04/11/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import UIKit

protocol CityDelegate: AnyObject {
    func didSelectCity(city: CityDetail)
}

class SearchCityViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var searchOption: SearchOption = .cityLocation
    weak var delegate: CityDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCities: [CityDetail] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchOption.rawValue
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func filterCities(_ searchText: String) {
        guard let cities = appDelegate.cities else {
            return
        }
        if searchOption == SearchOption.cityName {
            filteredCities = cities.filter { (city: CityDetail) -> Bool in
                return city.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredCities = cities.filter { (city: CityDetail) -> Bool in
                return city.country.lowercased().contains(searchText.lowercased())
            }

        }
        tableview.reloadData()
    }
    
    func getCityDetail(indexPath: IndexPath) -> CityDetail {
        let cities = appDelegate.cities!
        let city: CityDetail
        if isFiltering {
            city = filteredCities[indexPath.row]
        } else {
            city = cities[indexPath.row]
        }
        return city
    }
}

extension SearchCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCities.count
        }
        return appDelegate.cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "cityCell") as? CityCell  else {
            return UITableViewCell()
        }
        let city = getCityDetail(indexPath: indexPath)
        cell.updateCell(with: city)
        return cell
    }
}

extension SearchCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = getCityDetail(indexPath: indexPath)
        self.delegate?.didSelectCity(city: city)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension SearchCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterCities(searchBar.text!)
    }
}
