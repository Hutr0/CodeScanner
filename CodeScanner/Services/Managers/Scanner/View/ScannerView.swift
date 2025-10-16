//
//  ScannerView.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct ScannerView: View {
    
    @StateObject private var vm = ScannerViewModel()
    @State private var isPulsing = false
    
    var onCodeScanned: (String) -> Void

    var body: some View {
        Group {
            if vm.permissionDenied {
                PermissionDeniedPlaceholder()
            } else {
                GeometryReader { geo in
                    CameraPreview(session: vm.session)
                        .ignoresSafeArea(.container)
                        .overlay {
                            Image(systemName: "viewfinder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width / 2)
                                .foregroundStyle(.white)
                                .fontWeight(.thin)
                                .allowsHitTesting(false)
                                .scaleEffect(isPulsing ? 1.06 : 0.94)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isPulsing)
                                .onAppear { isPulsing = true }
                        }
                        .overlay(alignment: .topTrailing) {
                            Button {
                                vm.toggleTorch()
                            } label: {
                                Image(systemName: vm.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .buttonStyle(.glass)
                            .foregroundStyle(vm.isTorchOn ? AnyShapeStyle(.yellow) : AnyShapeStyle(.foreground))
                            .padding()
                        }
                }
            }
        }
        .onChange(of: vm.lastScanned) { _, code in
            guard let code else { return }
            onCodeScanned(code)
        }
        .task {
            vm.requestPermissionAndStart()
        }
        .onDisappear {
            vm.stop()
        }
        .alert("Ошибка", isPresented: .constant(vm.errorMessage != nil)) {
            Button("Ок") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}

private
struct PermissionDeniedPlaceholder: View {
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "camera.fill")
                .font(.system(size: 48))
            Text("Нет доступа к камере")
                .font(.headline)
            Text("Разреши доступ к камере в Настройках, чтобы сканировать коды.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            if let url = URL(string: UIApplication.openSettingsURLString) {
                Link("Открыть настройки", destination: url)
                    .buttonStyle(.glassProminent)
            }
        }
        .padding()
    }
}

#Preview {
    ScannerView() { _ in }
}
