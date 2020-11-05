//
//  SwapRootViewControllerSegue.swift
//  iOSBaseProject
//
//  Created by Mark G on 9/19/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

#if os(iOS)
import UIKit
import UIWindowTransitions

public class SwapRootViewControllerSegue: UIStoryboardSegue {
    public override func perform() {
        source.view.window?.setRootViewController(destination)
    }
}

#endif
