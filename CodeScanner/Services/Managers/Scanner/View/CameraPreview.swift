//
//  CameraPreview.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    let session: AVCaptureSession
    var onLayout: ((AVCaptureVideoPreviewLayer, CGRect) -> Void)? = nil

    func makeUIView(context: Context) -> PreviewView {
        let v = PreviewView()
        v.videoPreviewLayer.session = session
        v.videoPreviewLayer.videoGravity = .resizeAspectFill
        v.onLayout = { [onLayout] layer, bounds in onLayout?(layer, bounds) }
        return v
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.onLayout = { [onLayout] layer, bounds in onLayout?(layer, bounds) }
    }

    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
        
        var onLayout: ((AVCaptureVideoPreviewLayer, CGRect) -> Void)?
        
        override func layoutSubviews() {
            super.layoutSubviews()
            onLayout?(videoPreviewLayer, bounds)
        }
    }
}
