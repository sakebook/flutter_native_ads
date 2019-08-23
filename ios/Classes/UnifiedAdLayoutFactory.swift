//
//  UnifiedAdLayoutFactory.swift
//  native_ads
//
//  Created by ShinyaSakemoto on 2019/08/23.
//

import Foundation

public class UnifiedAdLayoutFactory : NSObject, FlutterPlatformViewFactory {
    let messeneger: FlutterBinaryMessenger
    
    public init(messeneger: FlutterBinaryMessenger) {
        self.messeneger = messeneger
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return UnifiedAdLayout(
            frame: frame,
            viewId: viewId,
            args: args as? [String : Any] ?? [:],
            messeneger: messeneger
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
