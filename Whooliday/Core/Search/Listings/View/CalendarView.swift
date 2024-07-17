//
//  CalendarView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 27/06/24.
//

import SwiftUI

// calendar used to select date interval for the search phase 
struct CalendarView: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @State private var currentMonth: Date = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        VStack {
            // Intestazione del mese
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearString(from: currentMonth))
                    .font(.headline)
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Giorni della settimana
            HStack {
                ForEach(["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 8)
            
            // Griglia dei giorni
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth(for: currentMonth), id: \.self) { date in
                    DayView(date: date, startDate: $startDate, endDate: $endDate, isSelectable: isDateSelectable(date))
                }
            }
        }
        .padding()
    }
    
    func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
    }
    
    func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func daysInMonth(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }
        
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)
        }
    }
    
    func isDateSelectable(_ date: Date) -> Bool {
        return date >= calendar.startOfDay(for: Date())
    }
}

struct DayView: View {
    let date: Date
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    let isSelectable: Bool
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Text(dateFormatter.string(from: date))
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .onTapGesture {
                if isSelectable {
                    selectDate(date)
                }
            }
    }
    
    private var isSelected: Bool {
        date == startDate || date == endDate
    }
    
    private var isInRange: Bool {
        guard let start = startDate, let end = endDate else { return false }
        return date > start && date < end
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue
        } else if isInRange {
            return .blue.opacity(0.3)
        } else {
            return .clear
        }
    }
    
    private var textColor: Color {
        if !isSelectable {
            return .gray
        } else if isSelected {
            return .white
        } else if calendar.isDateInToday(date) {
            return .blue
        } else {
            return .primary
        }
    }
    
    private func selectDate(_ date: Date) {
        if startDate == nil {
            startDate = date
        } else if endDate == nil && date > startDate! {
            endDate = date
        } else {
            startDate = date
            endDate = nil
        }
    }
}

struct ContentView2: View {
    @State private var startDate: Date?
    @State private var endDate: Date?
    
    var body: some View {
        VStack {
            CalendarView(startDate: $startDate, endDate: $endDate)
            
            if let start = startDate {
                Text("Data di inizio: \(start, formatter: dateFormatter)")
            }
            if let end = endDate {
                Text("Data di fine: \(end, formatter: dateFormatter)")
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
