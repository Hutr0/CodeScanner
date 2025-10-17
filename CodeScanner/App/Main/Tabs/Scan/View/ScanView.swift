//
//  ListScreen.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct ScanView: View {
    
    @StateObject private var viewModel = ScanViewModel()
    @State private var showDetail = false
    
    var body: some View {
        NavigationStack {
            ScannerView(isPaused: $showDetail) { result in
                applyScannerResult(result)
            }
            .sheet(isPresented: $showDetail, onDismiss: discardCode) {
                NavigationStack {
                    if let dto = viewModel.currentDTO {
                        ScanDetail(dto: dto, updateTitle: { title in viewModel.currentDTO?.title = title })
                            .presentationDetents([.large])
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Закрыть") { discardCode() }
                                }
                            }
                    } else {
                        ContentUnavailableView("Не удалось загрузить товар", systemImage: "exclamationmark.triangle", description: Text("Попробуй отсканировать ещё раз"))
                    }
                }
            }
        }
    }
    
    @MainActor
    func applyScannerResult(_ result: ScannerResult) {
        viewModel.applyScannerResult(result)
        showDetail = true
    }
    
    @MainActor
    func discardCode() {
        showDetail = false
        viewModel.applyScannerResult(nil)
    }
}

#Preview {
    ListView()
}
