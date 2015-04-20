//
//  User.swift
//  Event_App
//
//  Created by Johnny Appleseed on 11/26/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import Foundation

class User: PFUser, PFSubclassing
{
    override class func initialize()
    {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken)
            {
                self.registerSubclass()
        }
    }

    ///Creates a new user
    class func registerNewUser(username : String!, password : String!, completed:(result : Bool!, error : NSError!) -> Void)
    {
        let newUser = User()
        newUser.username = username.lowercaseString
        newUser.password = password.lowercaseString

        newUser.signUpInBackgroundWithBlock { (succeeded, parseError) -> Void in

            if parseError != nil
            {
                completed(result: false, error: parseError)
            }
            else
            {
                Profile.createProfile(newUser, completed: { (profile, succeeded, error) -> Void in

                    Profile.queryForCurrentUsersProfile({ (theProfile, error) -> Void in

                        UniversalProfile.sharedInstance.profile = theProfile as Profile!
                        completed(result: true, error: nil)
                    })
                })
            }
        }
    }

    ///Logs in a user
    class func loginUser(username : String!, password : String!, completed:(result : Bool!, error : NSError!) -> Void)
    {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, parseError) -> Void in

            if parseError != nil
            {
                completed(result: false, error: parseError)
            }
            else
            {
                Profile.queryForCurrentUsersProfile({ (profile, error) -> Void in

                    UniversalProfile.sharedInstance.profile = profile as Profile!
                })
                completed(result: true, error: nil)
            }
        }
    }
}