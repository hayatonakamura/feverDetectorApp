//
//  ViewController.swift
//  feverDetector
//
//  Created by Hayato Nakamura on 2020/05/06.
//  Copyright © 2020 Hayatopia. All rights reserved.
//

import UIKit
import Charts

import Foundation

// MARK: - Week
struct Week: Codable {
    let the0, the1, the2, the3: Int
    let the4, the5, the6: Int
    let weather: String

    enum CodingKeys: String, CodingKey {
        case the0 = "0"
        case the1 = "1"
        case the2 = "2"
        case the3 = "3"
        case the4 = "4"
        case the5 = "5"
        case the6 = "6"
        case weather
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var totalHitsLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let url = URL(string: "https://hayatopia.s3.amazonaws.com/weekData.json") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                    let data = try JSONDecoder().decode(Week.self, from: data)
                    print(data.the3)
                    
                    
                    let num = data.the0 + data.the1 + data.the2 + data.the3 + data.the4 + data.the5 + data.the6
                    let weatherTemp = data.weather
                    print(weatherTemp)
                    self.updateLabel(hits: num, weather: weatherTemp)
                    DispatchQueue.main.async {
                     let week_data = ["1", "2", "3", "4", "5", "6", "7"]
                        let vals = [data.the0, data.the1, data.the2, data.the3, data.the4, data.the5, data.the6]
                     self.bar_chart.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                     self.bar_chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                     self.setChart_text(dataPoints: week_data, values: vals)
                     
                    }
                    

                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
    
    
    func updateLabel(hits: Int, weather: String){
        DispatchQueue.main.async {
            self.totalHitsLabel.text = "Total Hits this week: " + String(hits)
            self.weatherLabel.text = "Average Outside Temp: " + String(weather) + "°C"
        }
    }
    
    
    
    func setChart_text(dataPoints: [String], values: [Int]) {
        
        bar_chart.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Weekly Hits")
        let chartData = BarChartData(dataSet: chartDataSet)
        bar_chart.leftAxis.enabled = false
        bar_chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        bar_chart.xAxis.granularityEnabled = true
        bar_chart.xAxis.labelPosition = .bottom
        
        chartDataSet.colors = [UIColor(red: 255/255, green: 126/255, blue: 0/255, alpha: 1)]
        bar_chart.data = chartData
    }
    
    @IBAction func refresh_button(_ sender: Any) {
        self.bar_chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    

}

