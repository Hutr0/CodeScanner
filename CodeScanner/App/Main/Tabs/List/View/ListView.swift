//
//  ListScreen.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import SwiftUI
internal import CoreData

struct ListView: View {
    
    @StateObject private var viewModel = ListViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Scan.date, ascending: false),
        ]
    )
    private var scans: FetchedResults<Scan>
    
    @State private var renameTarget: ScanDTO?
    @State private var renameText: String = ""
    @State private var showRenameAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(scans.enumerated(), id: \.element) { (i, scan) in
                    NavigationLink(value: scan) {
                        let dto = ScanDTO(from: scan)
                        
                        ScanCell(dto: dto) { dto in
                            renameTarget = dto
                            renameText = dto.title
                            showRenameAlert = true
                        } onShare: { dto in
                            shareScan(dto)
                        } onDelete: { _ in
                            deleteItem(by: i)
                        }
                        .swipeActions(edge: .leading) {
                            Button("Переименовать") {
                                renameTarget = dto
                                renameText = dto.title
                                showRenameAlert = true
                            }.tint(.blue)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationDestination(for: Scan.self) { scan in
                let dto = ScanDTO(from: scan)
                ScanDetail(dto: dto, updateTitle: { _ in /* Not needed because dto is temorary model for this View */ })
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Список")
            .alert("Переименовать", isPresented: $showRenameAlert) {
                TextField("Новое название", text: $renameText, prompt: renameTarget?.title != nil ? Text(renameTarget!.title) : nil)
                Button("Сохранить", action: applyRename)
                Button("Отмена", role: .cancel) {}
            } message: {
                if let renameTarget {
                    Text("Текущее: \(renameTarget.title)")
                }
            }
        }
    }
}

private
extension ListView {
    
    func shareScan(_ dto: ScanDTO) {
        let text = dto.shareText
        
        let avc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(avc, animated: true)
        }
    }
    
    func applyRename() {
        guard let target = renameTarget else { return }
        let title = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }

        if let obj = object(for: target) {
            obj.title = title
            PersistenceController.shared.saveContext(context: viewContext)
        }

        renameTarget = nil
        renameText = ""
    }
    
    func deleteItem(by index: Int) {
        guard index >= 0 && index < scans.count else { return }
        
        withAnimation {
            let object = scans[index]
            viewContext.delete(object)
            PersistenceController.shared.saveContext(context: viewContext)
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { scans[$0] }.forEach(viewContext.delete)
            PersistenceController.shared.saveContext(context: viewContext)
        }
    }
    
    func object(for dto: ScanDTO) -> Scan? {
        scans.first { ($0.code ?? "") == dto.code }
    }
    
}

#Preview {
    ListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
