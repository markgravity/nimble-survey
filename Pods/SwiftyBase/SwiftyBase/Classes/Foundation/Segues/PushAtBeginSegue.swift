//
//  PushAtBeginSegue.swift
//  Moco360
//
//  Created by Mark G on 7/19/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit

public class PushAtBeginSegue: UIStoryboardSegue {
    public override func perform() {
//        let destination = self.destination
//        let width = source.view.frame.size.width;
//        let height = source.view.frame.size.height;
//
//        let previousFrame = CGRect(x:width-1, y:0.0, width:width, height:height)
//        let nextFrame = CGRect(x:-width, y:0.0, width:width, height:height);
//
//
//        destination.view.frame = previousFrame
//        UIApplication.shared.delegate?.window??.addSubview(destination.view)
//        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
//            self.destination.view.frame = self.source.view.frame
//            self.source.view.frame = nextFrame
//        })
//        {  _ in
//            UIApplication.shared.delegate?.window??.rootViewController = destination
//        }
        
        UIApplication.shared.delegate?.window??.rootViewController = destination
    }
}
#endif
