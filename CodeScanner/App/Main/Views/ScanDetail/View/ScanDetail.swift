//
//  ScanDetail.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI

struct ScanDetail: View {
    
    
    // MARK: Parameters
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = ScanDetailViewModel()
    
    @State private var showRename = false
    @State private var renameText = ""
    @State private var confirmDelete = false
    
    let scan: ScanDTO
    let updateTitle: (String) -> ()
    
    
    // MARK: Init
    
    init(dto: ScanDTO, updateTitle: @escaping (String) -> ()) {
        self.scan = dto
        self.updateTitle = updateTitle
    }
    
    
    // MARK: Body
    
    var body: some View {
        Group {
            if scan.isLoading {
                ScanDetailSkeleton(code: scan.code)
            } else {
                if scan.isProduct, let product = scan.product {
                    ScanDetailContent(scan: scan, product: product)
                } else {
                    MinimalScanContent(scan: scan)
                }
            }
        }
        .navigationTitle(scan.titleText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { actionToolbar }
        .alert("Переименовать", isPresented: $showRename) {
            TextField("Новое название", text: $renameText, prompt: Text(renameText))
            Button("Сохранить") {
                let newTitle = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
                let text = newTitle.isEmpty ? scan.codeText : newTitle
                if viewModel.onRename(to: text, dto: scan, viewContext) {
                    updateTitle(text)
                }
                showRename = false
            }
            .disabled(renameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Отмена", role: .cancel) {}
        } message: {
            if !renameText.isEmpty {
                Text("Текущее: \(renameText)")
            }
        }
        .alert("Удалить запись?", isPresented: $confirmDelete) {
            Button("Удалить", role: .destructive) {
                if viewModel.onDelete(scan, viewContext) {
                    dismiss()
                }
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text("Это действие нельзя отменить.")
        }
        .onAppear {
            renameText = (scan.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
            ? scan.title
            : scan.codeText
        }
    }

    // MARK: Toolbar

    @ToolbarContentBuilder
    private var actionToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            ShareLink(item: scan.shareText) { Image(systemName: "square.and.arrow.up") }
            
            Menu {
                Button {
                    viewModel.onCopy(scan)
                } label: {
                    Label("Скопировать код", systemImage: "doc.on.doc")
                }
                Button {
                    showRename = true
                } label: {
                    Label("Переименовать", systemImage: "pencil.line")
                }
                Divider()
                Button(role: .destructive) {
                    confirmDelete = true
                } label: {
                    Label("Удалить", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

// MARK: - Previews

#Preview("Failed") {
    NavigationStack { ScanDetail(dto: ScanDTO.getPreview(isLoading: false), updateTitle: { _ in }) }
}

#Preview("Loading") {
    NavigationStack { ScanDetail(dto: ScanDTO.getPreview(isLoading: true), updateTitle: { _ in }) }
}

#Preview("Filled") {
    let nutr = NutrimentsDTO(
        energy100g: 900, energyServing: 1800, energyUnit: "kJ",
        proteins100g: 7.1, proteinsServing: 14.2,
        fat100g: 10.3, fatServing: 20.6,
        saturatedFat100g: 4.0, saturatedFatServing: 8.0,
        carbohydrates100g: 55.2, carbohydratesServing: 110.4,
        sugars100g: 30.0, sugarsServing: 60.0,
        salt100g: 0.7, saltServing: 1.4
    )
    let dto = OFFProductDTO(
        code: "4601234567890",
        name: "Шоколад молочный",
        brand: "GoodBrand",
        quantity: "90 г",
        countries: "Россия, Финляндия",
        categories: ["Сладости", "Шоколад", "Молочный"],
        nutriScore: "D",
        novaGroup: "4",
        nutriments: nutr,
        allergens: "Молоко, соя",
        traces: "Может содержать следы орехов",
        ingredientsText: "Сахар, какао-масло, сухое молоко, какао-тертое, лецитин (соевый), ванилин.",
        imageThumb: nil,
        imageFront: URL(string: "https://images.openfoodfacts.org/images/products/389/483/305/front_ru.5.400.jpg"),
        imageIngredients: nil,
        imageNutrition: nil,
        lastModified: .now,
        isLoading: false
    )
    let scan = ScanDTO(
        code: "Code 123",
        type: "Type 123",
        title: "Title 123",
        isProduct: false,
        product: dto,
        isLoading: false
    )
    NavigationStack { ScanDetail(dto: scan, updateTitle: { _ in }) }
}
