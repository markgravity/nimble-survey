//
//  L10n.swift
//  SwiftyBase
//
//  Created by Mark G on 26/09/2020.
//

import L10n_swift

public extension String {
    func trans(_ args: Any...) -> String {
        self.l10n(args: args.map { "\($0)" } )
    }
    
    func trans() -> String {
        self.l10n()
    }
}
