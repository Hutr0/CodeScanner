//
//  ScannerController.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import UIKit
import Combine
import AVFoundation

final class ScannerController: NSObject {
    
    
    // MARK: Paramters
    
    let session = AVCaptureSession()
    private var configured = false
    
    var onRuntimeError: ((Error) -> Void)?
    
    private let supportedTypes: [AVMetadataObject.ObjectType] = [
        .qr,
        .ean8,
        .ean13,
        .pdf417,
        .code39,
        .code93,
        .code128,
        .upce,
        .aztec,
        .dataMatrix,
        .itf14,
    ]
    
    private let sessionQueue = DispatchQueue(label: "scanner.session.queue")
    private let metadataQueue = DispatchQueue(label: "scanner.metadata.queue")
    
    private let scannedCodeSubject = PassthroughSubject<String, Never>()
    var scannedCodePublisher: AnyPublisher<String, Never> { scannedCodeSubject.eraseToAnyPublisher() }
    
    
    // MARK: Deinit
    
    deinit {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            NotificationCenter.default.removeObserver(self, name: AVCaptureSession.runtimeErrorNotification, object: self.session)
        }
    }

}


// MARK: - Methods

extension ScannerController {
    
    func start() async throws {
        try await runOnSessionQueue {
            guard self.configured else { throw ScannerError.configurationFailed }
            guard !self.session.isRunning else { return }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleRuntimeError(_:)), name: AVCaptureSession.runtimeErrorNotification, object: self.session)
            
            self.session.startRunning()
        }
    }
    
    func stop() async {
        await runOnSessionQueue {
            guard self.session.isRunning else { return }
            
            self.session.stopRunning()
            
            NotificationCenter.default.removeObserver(self, name: AVCaptureSession.runtimeErrorNotification, object: self.session)
        }
    }
    
    @discardableResult
    func toggleTorch(desired: Bool) async throws -> Bool {
        try await runOnSessionQueue {
            guard let device = (self.session.inputs.compactMap { ($0 as? AVCaptureDeviceInput)?.device }.first), device.hasTorch else { throw ScannerError.torchUnsupported }
            
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            
            if desired {
                try device.setTorchModeOn(level: 1.0)
                return true
            } else {
                device.torchMode = .off
                return false
            }
        }
    }

    func configureIfNeeded() async throws {
        try await runOnSessionQueue { [weak self] in
            guard let self else { return }
            
            guard !configured else { return }
            
            session.beginConfiguration()
            defer { session.commitConfiguration() }
            
            if session.canSetSessionPreset(.hd1280x720) {
                session.sessionPreset = .hd1280x720
            }
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            else { throw ScannerError.cameraUnavailable }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                guard session.canAddInput(input) else { throw ScannerError.inputInitFailed }
                session.addInput(input)
            } catch {
                throw ScannerError.inputInitFailed
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            guard session.canAddOutput(metadataOutput) else { throw ScannerError.configurationFailed }
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
            
            let available = metadataOutput.availableMetadataObjectTypes
            metadataOutput.metadataObjectTypes = supportedTypes.filter { available.contains($0) }
            
            configured = true
        }
    }
    
    static func requestCameraPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                continuation.resume(returning: true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            case .denied, .restricted:
                continuation.resume(returning: false)
            @unknown default:
                continuation.resume(returning: false)
            }
        }
    }
    
}


// MARK: - Private helpers

private extension ScannerController {
    
    func runOnSessionQueue<T>(_ work: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            sessionQueue.async {
                do {
                    let result = try work()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func runOnSessionQueue<T>(_ work: @escaping () -> T) async -> T {
        await withCheckedContinuation { cont in
            sessionQueue.async { cont.resume(returning: work()) }
        }
    }

    @objc func handleRuntimeError(_ note: Notification) {
        if let error = note.userInfo?[AVCaptureSessionErrorKey] as? NSError {
            onRuntimeError?(error)
        }
    }
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let value = obj.stringValue else { return }
        
        scannedCodeSubject.send(value)
        
        Task { @MainActor in
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
}
