//
//  UnifiedAdLayout.swift
//  native_ads
//
//  Created by ShinyaSakemoto on 2019/08/23.
//

import Foundation

class UnifiedAdLayout : NSObject, FlutterPlatformView {
    
    private let channel: FlutterMethodChannel
    private let messeneger: FlutterBinaryMessenger
    private let frame: CGRect
    private let viewId: Int64
    private let args: [String: Any]
    
    init(frame: CGRect, viewId: Int64, args: [String: Any], messeneger: FlutterBinaryMessenger) {
        self.args = args
        self.messeneger = messeneger
        self.frame = frame
        self.viewId = viewId
        channel = FlutterMethodChannel(name: "com.github.sakebook/unified_ad_layout_\(viewId)", binaryMessenger: messeneger)
    }
    
    func view() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.red
        return v
    }
    
    fileprivate func dispose() {
        channel.setMethodCallHandler(nil)
    }
}
