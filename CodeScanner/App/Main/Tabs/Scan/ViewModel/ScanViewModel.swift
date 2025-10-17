//
//  ListViewModel.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

import Combine
internal import CoreData

final class ScanViewModel: ObservableObject {
    
    @Published var currentDTO: ScanDTO?

    @MainActor
    func applyScannerResult(_ result: ScannerResult?) {
        guard let result else {
            currentDTO = nil
            return
        }
        
        let dto = ScanDTO(from: result)
        
        currentDTO = dto
        
        processCode(dto)
    }
    
}


private
extension ScanViewModel {
    
    func processCode(_ scan: ScanDTO) {
        Task {
            let code = scan.code
            
            if let scan = findScan(by: code) {
                print(1)
                let dto = ScanDTO(from: scan)
                await MainActor.run {
                    currentDTO = dto
                }
            } else {
                do {
                    print(2)
                    let dto = try await OFFNetworkManager().requestInfo(by: code)
                    
                    print(2.5)
                    
                    guard currentDTO?.code == code else { return }
                    
                    var newScan = scan
                    
                    newScan.product = dto
                    newScan.isProduct = true
                    newScan.isLoading = false
                    if let name = dto.name, newScan.title == "Новый скан" {
                        newScan.title = name
                    }
                    
                    persist(newScan)
                    
                    print(3)
                    
                    await MainActor.run {
                        currentDTO = newScan
                    }
                } catch {
                    print(error)
                    
                    print(4)
                    
                    guard currentDTO?.code == code else { return }
                    
                    print(5)
                    
                    var newScan = scan
                    
                    newScan.isLoading = false
                    newScan.isProduct = false
                    
                    persist(newScan)
                    
                    await MainActor.run {
                        currentDTO = newScan
                    }
                }
            }
        }
    }
    
    func findScan(by code: String) -> Scan? {
        let request = NSFetchRequest<Scan>(entityName: "Scan")
        request.predicate = NSPredicate(format: "code == %@", code)
        request.fetchLimit = 1
        
        return try? PersistenceController.shared.container.viewContext.fetch(request).first
    }
    
    func persist(_ dto: ScanDTO) {
        let ctx = PersistenceController.shared.newBackgroundContext()
        ctx.perform {
            do {
                _ = try Scan.upsert(from: dto, in: ctx)
                
                PersistenceController.shared.saveContext(context: ctx)
            } catch {
                print("Core Data save error:", error)
            }
        }
    }
    
}
