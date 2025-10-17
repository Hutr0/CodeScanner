//
//  ScanDetailViewModel.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 17.10.2025.
//

import SwiftUI
import Combine
internal import CoreData

final class ScanDetailViewModel: ObservableObject {
    
    
    // MARK: Methods
    
    func onCopy(_ dto: ScanDTO) {
        UIPasteboard.general.string = dto.code
    }
    
    func onDelete(_ dto: ScanDTO, _ context: NSManagedObjectContext) -> Bool {
        guard let scan = getScan(dto, context) else { return false }
        
        context.delete(scan)
        
        PersistenceController.shared.saveContext(context: context)
        
        return true
    }
    
    func onRename(to newTitle: String, dto: ScanDTO, _ context: NSManagedObjectContext) -> Bool {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return false }
        guard let scan = getScan(dto, context) else { return false }
        
        scan.title = title
        PersistenceController.shared.saveContext(context: context)
        
        return true
    }
    
    func getScan(_ dto: ScanDTO, _ context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Scan? {
        
        let request = NSFetchRequest<Scan>(entityName: "Scan")
        request.predicate = NSPredicate(format: "code == %@", dto.code)
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
    
}
