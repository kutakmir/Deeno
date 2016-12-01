//
//  AddRideViewController.swift
//  Deeno
//
//  Created by Michal Severín on 01.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase
import GooglePlaces
import UIKit

class AddRideViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: Private Properties
    fileprivate let addRideImageView = ImageView()
    fileprivate let fromLabel = Label()
    fileprivate let toLabel = Label()
    fileprivate let dateLabel = Label()
    
    fileprivate let priceTextField = UITextField()
    fileprivate let seatsTextField = UITextField()
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let datePicker = UIDatePicker()
    fileprivate let datePickerToolbar = View()
    fileprivate let fromImageView = ImageView(image: #imageLiteral(resourceName: "mark"))
    fileprivate let toImageView = ImageView(image: #imageLiteral(resourceName: "flag"))
    
    internal var isFromLabelTapped = false
    fileprivate var isDatePickerUp = false
    
    fileprivate let createButton = Button(type: .system)
    fileprivate let toolbarButton = Button(type: .system)
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        addRideImageView.image = #imageLiteral(resourceName: "ridesBg")
        addRideImageView.contentMode = .scaleAspectFit
        
        fromImageView.contentMode = .scaleAspectFit
        toImageView.contentMode = .scaleAspectFit
        
        priceTextField.placeholder = "Price"
        priceTextField.textColor = Palette[.gray]
        priceTextField.keyboardType = .numberPad
        
        seatsTextField.placeholder = "Free seats"
        seatsTextField.textColor = Palette[.gray]
        seatsTextField.keyboardType = .numberPad
        
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(pickerDateChanged), for: .valueChanged)
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = Palette[.white]
        
        dateLabel.text = "When?"
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDatePicker)))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.textColor = Palette[.lightGray]
        
        fromLabel.text = "From"
        fromLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromLabelTapped)))
        fromLabel.isUserInteractionEnabled = true
        fromLabel.textColor = Palette[.lightGray]
        
        toLabel.text = "To"
        toLabel.textColor = Palette[.lightGray]
        toLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toLabelTapped)))
        toLabel.isUserInteractionEnabled = true
        
        createButton.setTitle("Create", for: .normal)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.backgroundColor = Palette[.primary]
        createButton.tintColor = Palette[.white]
        createButton.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        
        toolbarButton.setTitle("Ok", for: .normal)
        toolbarButton.addTarget(self, action: #selector(closeDatepicker), for: .touchUpInside)
        toolbarButton.tintColor = Palette[.white]
        
        datePickerToolbar.backgroundColor = Palette[.primary]
        datePicker.isHidden = true
        datePickerToolbar.isHidden = true
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    internal override func addElements() {
        super.addElements()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonPressed))

        view.addSubview(scrollView)
        scrollView.addSubviews(views:
            [
                addRideImageView,
                fromImageView,
                toImageView,
                fromLabel,
                toLabel,
                dateLabel,
                priceTextField,
                seatsTextField,
                createButton,
                datePicker,
                datePickerToolbar,
            ]
        )
        
        datePickerToolbar.addSubview(toolbarButton)
    }
    
    internal override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[.white]
    }
    
    internal override func customInit() {
        super.customInit()
        
        title = "Add new ride"
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        fromImageView.snp.makeConstraints { make in
            make.bottom.equalTo(toLabel.snp.top).offset(-12)
            make.leading.equalTo(scrollView).inset(25)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        toImageView.snp.makeConstraints { make in
            make.bottom.equalTo(dateLabel.snp.top).offset(-14)
            make.leading.equalTo(scrollView).inset(29)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        addRideImageView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(scrollView).inset(5)
            make.height.equalTo(300)
            make.leading.equalTo(scrollView).inset(30)
            make.trailing.equalTo(scrollView).inset(30)
        }
        
        toLabel.snp.makeConstraints { make in
            make.leading.equalTo(toImageView.snp.trailing).offset(5)
            make.trailing.equalTo(scrollView).inset(5)
            make.top.equalTo(fromLabel.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        
        fromLabel.snp.makeConstraints { make in
            make.leading.equalTo(fromImageView.snp.trailing).offset(10)
            make.trailing.equalTo(scrollView).inset(5)
            make.top.equalTo(addRideImageView.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(addRideImageView.snp.width)
            make.centerX.equalTo(scrollView)
            make.top.equalTo(toLabel.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.width.equalTo(addRideImageView.snp.width)
            make.centerX.equalTo(scrollView)
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        
        seatsTextField.snp.makeConstraints { make in
            make.width.equalTo(addRideImageView.snp.width)
            make.centerX.equalTo(scrollView)
            make.top.equalTo(priceTextField.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        
        createButton.snp.makeConstraints { make in
            make.width.equalTo(addRideImageView.snp.width)
            make.centerX.equalTo(scrollView)
            make.top.equalTo(seatsTextField.snp.bottom).offset(5)
            make.height.equalTo(35)
            make.bottom.equalTo(scrollView).inset(10)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(scrollView)
            make.trailing.equalTo(scrollView)
            make.height.equalTo(150)
            make.bottom.equalTo(scrollView).inset(-180)
        }
        
        datePickerToolbar.snp.makeConstraints { make in
            make.leading.equalTo(scrollView)
            make.trailing.equalTo(scrollView)
            make.height.equalTo(30)
            make.bottom.equalTo(datePicker.snp.top)
        }

        toolbarButton.snp.makeConstraints { make in
            make.trailing.equalTo(scrollView)
            make.width.equalTo(80)
            make.centerY.equalTo(datePickerToolbar)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: - User Actions
    func closeDatepicker() {
        reloadDatePicker()
    }

    func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func addButtonPressed() {
        addNewRide()
    }

    func fromLabelTapped() {
        isFromLabelTapped = true
        openAddresses()
    }
    
    func toLabelTapped() {
        isFromLabelTapped = false
        openAddresses()
    }
    
    func openDatePicker() {
        reloadDatePicker()
    }
    
    func pickerDateChanged() {
        let date = TimeFormatsEnum.dateTime.stringFromDate(datePicker.date)
        dateLabel.text = date
    }
    
    func createButtonTapped() {
        addNewRide()
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    fileprivate func reloadDatePicker() {
        datePicker.isHidden = false
        datePickerToolbar.isHidden = false
        isDatePickerUp = !isDatePickerUp
        self.datePicker.snp.remakeConstraints { make in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(150)
            make.bottom.equalTo(self.view).inset(!isDatePickerUp ? -180 : 0)
        }
        self.datePickerToolbar.snp.remakeConstraints { make in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(30)
            make.bottom.equalTo(self.datePicker.snp.top)
        }
        UIView.animate(
            withDuration: Configuration.DefaultAnimationTimeInterval,
            animations: { _ in
                self.view.layoutIfNeeded()
        }, completion: { completion in
            if completion {
                if !self.isDatePickerUp {
                    self.datePicker.isHidden = true
                    self.datePickerToolbar.isHidden = true
                }
            }
        })
    }

    fileprivate func addNewRide() {
        guard let from = fromLabel.text, from != "From", let date = dateLabel.text, date != "When?", let to = toLabel.text, to != "To", let price = priceTextField.text, let seats = seatsTextField.text, let userId = AccountSessionManager.manager.accountSession?.userInfo?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference(withPath: Configuration.Entits.Rides)
        ref.child(from).childByAutoId().setValue(["date": "\(date)", "departure": "\(from)", "destination": "\(to)", "freeSeats": "\(seats)", "price": "\(price)", "userId": userId, "userPhone": Defaults[.userPhone].string ?? String.empty, "username": "\(AccountSessionManager.manager.accountSession?.userInfo?.displayName ?? String.empty)"], withCompletionBlock: { error, reference in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    fileprivate func openAddresses() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
}

// MARK: - <GMSAutocompleteViewControllerDelegate>
extension AddRideViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if isFromLabelTapped {
            fromLabel.text = place.name
        }
        else {
            toLabel.text = place.name
        }
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
