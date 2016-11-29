//
//  RidesViewController.swift
//  Deeno
//
//  Created by Michal Severín on 23.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

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

        // TODO - here will be Google API for select city etc.
        fromLabel.text = "Brno+SDFSDF"
        fromLabel.textColor = Palette[.lightGray]
        
        toLabel.text = "To"
        toLabel.textColor = Palette[.lightGray]

        searchButton.setTitle("Next", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.backgroundColor = Palette[.primary]
        searchButton.tintColor = Palette[.white]
        searchButton.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)

        tableView.register(UITableViewCell.self)
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

    // MARK: - User Actions
    func searchButtonTapped() {
        search()
    }

    func filterButtonPressed() {
        filterBox.isHidden = !filterBox.isHidden
    }

    // MARK: - Actions
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
        let cell: UITableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        if let ride = rides[safe: indexPath.row] {
            cell.textLabel?.text = ride.departure
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

}
