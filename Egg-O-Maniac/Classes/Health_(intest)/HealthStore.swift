//
//  HealthStore.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 18/01/2021.
//

import Foundation
import HealthKit

class HealthStore {
    
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping ( Bool ) -> Void) {
        let proteineType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!
        let FatSaturated = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatSaturated)!
        let FatMonounsaturated = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatMonounsaturated)!
        let FatPolyunsaturated = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatPolyunsaturated)!
        let totaloFat = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!
        let glucid = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!
        
//        let test = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.vo2Max)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [proteineType, FatSaturated, FatMonounsaturated, FatPolyunsaturated, totaloFat, glucid], read: []) { (succes, error) in
            completion(succes)
        }
    }
    
}
