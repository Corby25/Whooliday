//
//  PriceChartView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 24/06/24.
//

import SwiftUI
import SwiftUICharts


struct PriceChartView: View {
    @ObservedObject var viewModel: ExploreViewModel
    
    var body: some View {
        VStack {
            BarChartView(
                data: ChartData(values: viewModel.showDailyPrices ?
                    viewModel.dailyPrices.map { ($0.0, $0.1) } :
                    viewModel.weeklyAverages.map { ($0.0, $0.1) }),
                title: viewModel.showDailyPrices ? "Prezzo Giornaliero - €" : "Media Settimanale - €",
                legend: viewModel.showDailyPrices ? "Prezzo Giornaliero" : "Media Settimanale",
                form: ChartForm.extraLarge
            )
            
            Spacer()
            
            Picker("Tipo di prezzo", selection: $viewModel.showDailyPrices) {
                Text("Giornaliero").tag(true)
                Text("Media Settimanale").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
            .padding()
        }
        .frame(height: 300)
    }
}

#Preview {
    let exampleService = ExploreService()
    let exampleViewModel = ExploreViewModel(service: exampleService)
    
    // Add example data to priceCalendar
    exampleViewModel.priceCalendar = [
        "2024-06-24": PriceData(daily: 141.05),
        "2024-06-25": PriceData(daily: 141.05),
        "2024-06-26": PriceData(daily: 141.05),
        "2024-06-27": PriceData(daily: 141.05),
        "2024-06-28": PriceData(daily: 141.05),
        "2024-06-29": PriceData(daily: 141.05),
        "2024-06-30": PriceData(daily: 141.05),
        "2024-07-01": PriceData(daily: 141.05)
    ]
    
    // Populate dailyPrices and calculate weekly averages
    exampleViewModel.dailyPrices = exampleViewModel.priceCalendar.map { (formattedDate($0.key), $0.value.daily) }.sorted { $0.0 < $1.0 }
    exampleViewModel.calculateWeeklyAverages()
    
    return PriceChartView(viewModel: exampleViewModel)
}


private func formattedDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMM d"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    return dateString
}
