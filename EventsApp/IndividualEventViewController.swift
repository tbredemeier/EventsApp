//
//  IndividualEventViewController.swift
//  EventsApp
//
//  Created by tbredemeier on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

import UIKit

class IndividualEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var thisEvent = Event(className: "Event")
    var photosArray = [Photo]()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setPhotosData()
    }

    func setPhotosData() {
        photosArray.removeAll(keepCapacity: false)
        Photo.queryForPhotos { (photos, error) -> Void in
            for photo in photos {
                if photo.event.objectId == self.thisEvent.objectId {
                    self.photosArray.append(photo)
                }
            }
            self.tableView.reloadData()
        }
    }

    func setupCamera() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
    }


    @IBAction func onAddButtonTapped(sender: UIBarButtonItem) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            let newPhoto = Photo(className: "Photo")
            newPhoto.imageFile = PFFile(data: UIImagePNGRepresentation(image))
            newPhoto.event = self.thisEvent
            newPhoto.photographer = kProfile
            newPhoto.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                self.setPhotosData()
            }
        })
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoTableViewCell
        let photo = photosArray[indexPath.row]
        cell.dateLabel.text = photo.createdAt!.toStringOfAbbrevMonthDayAndTime()
        photo.imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            cell.photoImageView.image = UIImage(data: data!)
        }
        photo.photographer.profilePicFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            cell.photographerImageView.image = UIImage(data: data!)
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
}
