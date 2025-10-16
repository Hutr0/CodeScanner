//
//  ScannerViewModel.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI
import AVFoundation
import Combine

@MainActor
final class ScannerViewModel: ObservableObject {
    
    // MARK: Parameters
    
    @Published var isRunning = false
    @Published var isTorchOn = false
    @Published var permissionDenied = false
    @Published var lastScanned: String?
    @Published var errorMessage: String?

    private let scanner = ScannerController()
    private var cancellables = Set<AnyCancellable>()
    private var lastEmitAt = Date.distantPast

    var session: AVCaptureSession { scanner.session }
    
    
    // MARK: Init

    init() {
        scanner.scannedCodePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] code in
                guard let self else { return }
                
                if Date().timeIntervalSince(lastEmitAt) > 0.8 {
                    lastEmitAt = Date()
                    lastScanned = code
                }
            }
            .store(in: &cancellables)

        scanner.onRuntimeError = { [weak self] error in
            Task { @MainActor in self?.errorMessage = error.localizedDescription }
        }
    }
    
    
    // MARK: Methods

    func requestPermissionAndStart() {
        Task {
            let granted = await ScannerController.requestCameraPermission()
            
            await MainActor.run {
                self.permissionDenied = !granted
            }
            
            guard granted else { return }
            
            do {
                try await scanner.configureIfNeeded()
                try await scanner.start()
                await MainActor.run { self.isRunning = true }
            } catch {
                await MainActor.run { self.errorMessage = error.localizedDescription }
            }
        }
    }

    func stop() {
        Task {
            await scanner.stop()
            await MainActor.run {
                isRunning = false
                isTorchOn = false
            }
        }
    }

    func toggleTorch() {
        Task {
            do {
                let newState = try await scanner.toggleTorch(desired: !isTorchOn)
                await MainActor.run { self.isTorchOn = newState }
            } catch {
                await MainActor.run { self.errorMessage = error.localizedDescription }
            }
        }
    }
    
    func updateROI(layer: AVCaptureVideoPreviewLayer, in bounds: CGRect, fraction: CGFloat = 0.7) {
        Task {
            await scanner.updateRectOfInterest(previewLayer: layer, in: bounds, fraction: fraction)
        }
    }
}
