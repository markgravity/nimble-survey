//
//  PopThenPushSegue.swift
//  Moco360
//
//  Created by Mark G on 7/19/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit

public class PopThenPushSegue: UIStoryboardSegue {
    public override func perform() {
        let navigationController = source.navigationController
        source.navigationController?.popViewController(animated: false)
        navigationController?.pushViewController(destination, animated: true)
    }
}
#endif
