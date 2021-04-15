//
//  FitCalendarView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/12/21.
//

import SwiftUI

struct FitCalendarView: View {
    
    @State var year: Int // = 2021
    @State var month: Int //= 1
    
    init() {
        let today = DayComponents.today()
        _year = State(initialValue: today.year)
        _month = State(initialValue: today.month)
        //        year = today.year
        //        month = today.month
    }
    
    func incrementMonth() {
        if month < 12 {
            month += 1
        } else {
            month = 1
            year += 1
        }
    }
    
    func decrementMonth() {
        if month > 1 {
            month -= 1
        } else {
            month = 12
            year -= 1
        }
    }
    
    func toCurrentMonth() {
        let today = DayComponents.today()
        year = today.year
        month = today.month
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: decrementMonth) {Image(systemName: "chevron.backward.circle").font(.system(size: 24))}
                    .padding()
                Spacer()
                Text("\(Calendar.gregMonthSymbols[month-1]) \(year.description)")
                    .font(.headline)
                Spacer()
                Button(action: incrementMonth) {Image(systemName: "chevron.forward.circle").font(.system(size: 24))}
                    .padding()
            }
            
            // 6*7 grid
            // first day of month is first location in grid filled
            // first day of month + daysInMonth is first NOT filled
            
            // displays a set of set components
            // throw in an hstack for days of the week
            GeometryReader {(proxy: GeometryProxy) in
                ZStack {
                    ForEach(DayComponents.getDayComponents(year: year, month: month)) {(dayComponents: DayComponents) in
                        NavigationLink(destination: FitCalendarDayView(dayComponents: dayComponents)) {
                        FitCalendarCellView(dayComponents: dayComponents)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: DayComponents.getStride(proxy: proxy).xStride, height: DayComponents.getStride(proxy: proxy).yStride, alignment: .center)
                        .position(x: dayComponents.getCenter(proxy: proxy).x, y: dayComponents.getCenter(proxy: proxy).y)
                        // geometry read to right spot in 6*7 grid,
                        // just be a square nav link that perhaps has the "day" and how many workouts completed/planned
                    }
                }
            }
            Button("View Current Month", action: toCurrentMonth)
        }
        .navigationBarTitle("Fit Calendar")
    }
}

//struct FitCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        FitCalendarView()
//    }
//}
