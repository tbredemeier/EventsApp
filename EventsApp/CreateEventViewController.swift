//
//  CreateEventViewController.swift
//  EventsApp
//
//  Created by tbredemeier on 4/10/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage?()
    var location = CLLocation?()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        detailsTextField.delegate = self
        locationTextField.delegate = self
        setupCamera()  
    }

    func setupCamera() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
    }

    func createNewEvent()
    {
        let newEvent = Event(className: "Event")
        newEvent.host = kProfile
        newEvent.details = detailsTextField.text
        newEvent.title = titleTextField.text
        newEvent.eventPicFile = PFFile(data: UIImagePNGRepresentation(selectedImage))
        newEvent.location = PFGeoPoint(location: location)
        newEvent.date = datePicker.date
        newEvent.saveInBackgroundWithBlock(nil)
    }

    func geocodeLocationWithBlock(located : (succeeded : Bool, error : NSError!) -> Void)
    {
        var geocode = CLGeocoder()
        geocode.geocodeAddressString(locationTextField.text, completionHandler: { (placemarks, error) -> Void in
            if error != nil
            {
                showAlertWithError(error, self)
            }
            else
            {
                let locations : [CLPlacemark] = placemarks as! [CLPlacemark]
                self.location = locations.first?.location
                located(succeeded: true, error: nil)
            }
        })
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        detailsTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        return true
    }

    @IBAction func onSelectPhotoButtonTapped(sender: UIButton) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onDoneButtonTapped(sender: UIBarButtonItem) {
        if titleTextField.text == "" ||
           detailsTextField.text == "" ||
           locationTextField.text == "" ||
           selectedImage == nil
        {
            showAlert("Please fill all required fields", nil, self)
        }
        else
        {
            dismissViewControllerAnimated(true, completion: { () -> Void in
                self.geocodeLocationWithBlock({ (succeeded, error) -> Void in
                    self.createNewEvent()
                })
            })
        }

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.selectedImage = image
        })
    }
}
