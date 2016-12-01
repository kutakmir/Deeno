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

    fileprivate let fromImageView = ImageView(image: #imageLiteral(resourceName: "mark"))
    fileprivate let toImageView = ImageView(image: #imageLiteral(resourceName: "flag"))
    
    fileprivate let fromLabel = Label()
    fileprivate let toLabel = Label()
    fileprivate let dateLabel = Label()
    
    fileprivate let datePicker = UIDatePicker()
    
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
        
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(pickerValueChanged), for: .valueChanged)
        datePicker.datePickerMode = .dateAndTime
        datePicker.isHidden = true
        datePicker.backgroundColor = Palette[.white]

        filterBox.isHidden = true
        filterBox.backgroundColor = Palette[.white]
        filterBox.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        filterBox.layer.borderColor = Palette[.black].cgColor
        filterBox.layer.borderWidth = 0.5

        imageView.image = #imageLiteral(resourceName: "ridesBg")
        imageView.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill

        dateLabel.text = "When?"
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDatePicker)))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.textColor = Palette[.lightGray]
        
        fromLabel.text = "Prague"
        fromLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromLabelTapped)))
        fromLabel.isUserInteractionEnabled = true
        fromLabel.textColor = Palette[.lightGray]

        toLabel.text = "Kolin"
        toLabel.textColor = Palette[.lightGray]
        toLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toLabelTapped)))
        toLabel.isUserInteractionEnabled = true

        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.backgroundColor = Palette[.primary]
        searchButton.tintColor = Palette[.white]
        searchButton.layer.cornerRadius = Configuration.GUI.ItemCornerRadius

        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = Palette[.clear]
        tableView.delegate = self
        tableView.dataSource = self

        filterBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewEditingEnd)))
    }

    internal override func addElements() {
        super.addElements()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))

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
                fromImageView,
                toImageView,
                dateLabel,
                datePicker,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(filterBox)
            make.trailing.equalTo(filterBox)
            make.height.equalTo(100)
            make.bottom.equalTo(filterBox)
        }
        
        fromImageView.snp.makeConstraints { make in
            make.bottom.equalTo(toLabel.snp.top).offset(-12)
            make.leading.equalTo(filterBox).inset(5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        toImageView.snp.makeConstraints { make in
            make.bottom.equalTo(searchButton.snp.top).offset(-19)
            make.leading.equalTo(filterBox).inset(5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
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
            make.leading.equalTo(toImageView.snp.trailing).offset(5)
            make.trailing.equalTo(filterBox).inset(10)
            make.height.equalTo(35)
        }

        fromLabel.snp.makeConstraints { make in
            make.leading.equalTo(fromImageView.snp.trailing).offset(5)
            make.trailing.equalTo(filterBox).inset(10)
            make.bottom.equalTo(toLabel.snp.top).offset(-5)
            make.height.equalTo(35)
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

    override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
    }
    
    internal override func customInit() {
        super.customInit()
        
        title = "Rides"
        
        tableView.register(RidesTableViewCell.self)
    }

    // MARK: - User Actions
    func viewEditingEnd() {
        datePicker.isHidden = true
    }
    
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
    
    func addButtonPressed() {
        let navigation = UINavigationController(rootViewController: AddRideViewController())
        navigation.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[.primary]))
        present(navigation, animated: true, completion: nil)
    }
    
    func pickerValueChanged() {
        dateLabel.text = "\(datePicker.date)"
    }
    
    func openDatePicker() {
        datePicker.isHidden = !datePicker.isHidden
    }

    // MARK: - Actions
    fileprivate func addRide() {
        filterBox.isHidden = !filterBox.isHidden
    }

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
                self.rides.removeAll()
                for item in snapshot.children {
                    if let item = item as? FIRDataSnapshot, let to = self.toLabel.text {
                        let ride = Rides(snapshot: item)
                        if ride.destination == to {
                            self.rides.append(ride)
                        }
                    }
                }
                self.fromLabel.text = "Prague"
                self.toLabel.text = "Kolin"
            }
        )
    }
}

// MARK: - <UITableViewDataSource>
extension RidesViewController: UITableViewDataSource {

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RidesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.inset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        
        if let ride = rides[safe: indexPath.row], let price = ride.price {
            if let date = TimeFormatsEnum.dateTime.dateFromString(ride.date) {
                if date.isToday() {
                    cell.content.dayText = "Today"
                }
                else if date.isTomorrow() {
                    cell.content.dayText = "Tomorrow"
                }
                else {
                    cell.content.dayText = date.day
                }
            }
            if let from = ride.departure, let destination = ride.destination {
                cell.content.dateText = "\(from) -> \(destination)"
            }
            cell.content.timeText = ride.date
            cell.content.priceText = "\(price) $"
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ride = rides[safe: indexPath.row] {
            let detailVC = RideDetailViewController()
            detailVC.ride = ride
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Configuration.GUI.DefaultCellHeight
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
