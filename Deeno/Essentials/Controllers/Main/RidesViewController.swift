//
//  RidesViewController.swift
//  Deeno
//
//  Created by Michal Severín on 23.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import GooglePlaces
import Firebase
import SnapKit
import UIKit


class RidesViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: - Private
    fileprivate let filterBox = UIView()
    fileprivate let tableView = TableView(frame: .zero, style: .grouped)
    fileprivate let imageView = ImageView()

    fileprivate let fromLabel = Label()
    fileprivate let toLabel = Label()
    
    internal var isFromLabelTapped = false

    fileprivate let searchButton = Button(type: .system)

    fileprivate var rides: [Rides] = [] {
        didSet {
            filterBox.isHidden = true
            tableView.reloadData()
        }
    }

    // MARK: - Initialization
    internal override func initializeElements() {
        super.initializeElements()

        filterBox.isHidden = true
        filterBox.backgroundColor = Palette[.white]
        filterBox.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)
        filterBox.layer.borderColor = Palette[.black].cgColor
        filterBox.layer.borderWidth = 0.5

        imageView.image = #imageLiteral(resourceName: "ridesBg")
        imageView.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill

        fromLabel.text = "Brno+SDFSDF"
        fromLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromLabelTapped)))
        fromLabel.isUserInteractionEnabled = true
        fromLabel.textColor = Palette[.lightGray]
        
        toLabel.text = "To"
        toLabel.textColor = Palette[.lightGray]
        toLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toLabelTapped)))
        toLabel.isUserInteractionEnabled = true

        searchButton.setTitle("Next", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.backgroundColor = Palette[.primary]
        searchButton.tintColor = Palette[.white]
        searchButton.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)

        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = Palette[.clear]
        tableView.delegate = self
        tableView.dataSource = self
    }

    internal override func addElements() {
        super.addElements()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterButtonPressed))

        view.addSubviews(views:
            [
                tableView,
                filterBox,
            ]
        )
        filterBox.addSubviews(views:
            [
                imageView,
                fromLabel,
                toLabel,
                searchButton,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        filterBox.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.top.equalTo(view).inset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(400)
        }

        imageView.snp.makeConstraints { make in
            make.leading.equalTo(filterBox)
            make.trailing.equalTo(filterBox)
            make.top.equalTo(filterBox)
            make.bottom.equalTo(fromLabel.snp.top).offset(-10)
        }

        searchButton.snp.makeConstraints { make in
            make.bottom.equalTo(filterBox)
            make.leading.equalTo(filterBox)
            make.trailing.equalTo(filterBox)
            make.height.equalTo(40)
        }

        toLabel.snp.makeConstraints { make in
            make.bottom.equalTo(searchButton.snp.top).offset(-10)
            make.leading.equalTo(filterBox).inset(10)
            make.trailing.equalTo(filterBox).inset(10)
            make.height.equalTo(35)
        }

        fromLabel.snp.makeConstraints { make in
            make.leading.equalTo(filterBox).inset(10)
            make.trailing.equalTo(filterBox).inset(10)
            make.bottom.equalTo(toLabel.snp.top).offset(-5)
            make.height.equalTo(35)
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

    internal override func loadData() {
        super.loadData()

//        let ref = FIRDatabase.database().reference(withPath: "rides")
//        let post = ["data": "10-9-2016", "departure": "3013", "destination": "Brno+SDFSDF", "freeSeats": "3", "price": "59", "userId": "DFSA323"]
////        
//        ref.child("rides").childByAutoId().setValue(post) { error, reference in
//            guard error == nil else {
//                print("\(error)")
//                return
//            }
//            print(reference)
//        }
//

//        ref.childByAutoId().setValue(["data": "10-9-2016", "departure": "3013", "destination": "Brno+SDFSDF", "freeSeats": "3", "price": "59", "userId": "DFSA323"])
    }

    override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
    }
    
    internal override func customInit() {
        super.customInit()
        
        tableView.register(RidesTableViewCell.self)
    }

    // MARK: - User Actions
    func searchButtonTapped() {
        search()
    }

    func filterButtonPressed() {
        filterBox.isHidden = !filterBox.isHidden
    }
    
    func fromLabelTapped() {
        isFromLabelTapped = true
        openAddresses()
    }
    
    func toLabelTapped() {
        isFromLabelTapped = false
        openAddresses()
    }

    // MARK: - Actions
    fileprivate func openAddresses() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    fileprivate func search() {
        guard let from = fromLabel.text else {
            return
        }
        FIRDatabase.database()
            .reference(withPath: Configuration.Entits.Rides)
            .child(from)
            .observe(.value, with: { snapshot in
                self.fromLabel.text = "From"
                self.toLabel.text = "To"
                self.rides.removeAll()
                for item in snapshot.children {
                    if let item = item as? FIRDataSnapshot {
                        let ride = Rides(snapshot: item)
                        self.rides.append(ride)
                    }
                }
            }
        )
    }
}

// MARK: - <UITableViewDataSource>
extension RidesViewController: UITableViewDataSource {

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RidesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        if let ride = rides[safe: indexPath.row] {
            cell.content.dayText = "Monday"
            cell.content.timeText = ride.date
            cell.content.dateText = ride.departure
            cell.content.priceText = ride.price
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
}

// MARK: - <UITableViewDelegate>
extension RidesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Configuration.GUI.DefaultCellHeight)
    }
}

// MARK: - <GMSAutocompleteViewControllerDelegate>
extension RidesViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if isFromLabelTapped {
            fromLabel.text = place.name
        }
        else {
            toLabel.text = place.name
        }
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress ?? String.empty)
        print("Place attributions: ", place.attributions ?? String.empty)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
