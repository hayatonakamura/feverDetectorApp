//
//  RecentsViewController.swift
//  feverDetector
//
//  Created by Hayato Nakamura on 2020/05/06.
//  Copyright © 2020 Hayatopia. All rights reserved.
//

import UIKit
import Foundation
import Charts

// MARK: - Recents
struct Recents: Codable {
    let seven, ten, nine, six: [Eight]
    let three, two, four, five: [Eight]
    let eight, one: [Eight]
}
// MARK: - Eight
struct Eight: Codable {
    let pictureName, weather: String
    let name: Name
    let mean: String

    enum CodingKeys: String, CodingKey {
        case pictureName = "picture_name"
        case weather, name, mean
    }
}
enum Name: String, Codable {
    case hayato = "Hayato"
    case unknown = "Unknown"
}

class RecentsViewController: UIViewController {

    
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var heatmapImage: UIImageView!
    @IBOutlet weak var pictureNumber: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTempLabel: UILabel!
    @IBOutlet weak var outsideBodyTempLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var feverChart: HorizontalBarChartView!
    
    var pictureName = [] as [String]
    var bodyTemp = [] as [String]
    var weather = [] as [String]
    var name = [] as [String]
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Read the recent 10 list
        if let url = URL(string: "https://hayatopia.s3.amazonaws.com/recent.json") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                     let data = try JSONDecoder().decode(Recents.self, from: data)
                    self.pictureName = [] as [String]
                    self.bodyTemp = [] as [String]
                    self.weather = [] as [String]
                    self.name = [] as [String]
                    
                    let one = data.one[0]
                    self.pictureName.append(one.pictureName)
                    self.bodyTemp.append(one.mean)
                    self.weather.append(one.weather)
                    self.name.append(one.name.rawValue)
                    
                    let two = data.two[0]
                    self.pictureName.append(two.pictureName)
                    self.bodyTemp.append(two.mean)
                    self.weather.append(two.weather)
                    self.name.append(two.name.rawValue)
                    
                    let three = data.three[0]
                    self.pictureName.append(three.pictureName)
                    self.bodyTemp.append(three.mean)
                    self.weather.append(three.weather)
                    self.name.append(three.name.rawValue)
                    
                    let four = data.four[0]
                    self.pictureName.append(four.pictureName)
                    self.bodyTemp.append(four.mean)
                    self.weather.append(four.weather)
                    self.name.append(four.name.rawValue)
                    
                    let five = data.five[0]
                    self.pictureName.append(five.pictureName)
                    self.bodyTemp.append(five.mean)
                    self.weather.append(five.weather)
                    self.name.append(five.name.rawValue)
                    
                    let six = data.six[0]
                    self.pictureName.append(six.pictureName)
                    self.bodyTemp.append(six.mean)
                    self.weather.append(six.weather)
                    self.name.append(six.name.rawValue)
                    
                    let seven = data.seven[0]
                    self.pictureName.append(seven.pictureName)
                    self.bodyTemp.append(seven.mean)
                    self.weather.append(seven.weather)
                    self.name.append(seven.name.rawValue)
                    
                    let eight = data.eight[0]
                    self.pictureName.append(eight.pictureName)
                    self.bodyTemp.append(eight.mean)
                    self.weather.append(eight.weather)
                    self.name.append(eight.name.rawValue)
                    
                    let nine = data.nine[0]
                    self.pictureName.append(nine.pictureName)
                    self.bodyTemp.append(nine.mean)
                    self.weather.append(nine.weather)
                    self.name.append(nine.name.rawValue)
                    
                    let ten = data.ten[0]
                    self.pictureName.append(ten.pictureName)
                    self.bodyTemp.append(ten.mean)
                    self.weather.append(ten.weather)
                    self.name.append(ten.name.rawValue)
                    
                    
                    
                    print(self.pictureName)
                    self.setImage(from: self.pictureName[0])
                    self.updateLabel(num: self.counter)
                    //self.update_fever_bar()
                    

                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
        
    
    }
    
    
    func updateLabel(num: Int){
        DispatchQueue.main.async {
             self.update_fever_bar()
            let test = self.pictureName[num]
            let startInd = test.startIndex
            let begin = test.index(startInd, offsetBy:5)
            let newtest = String(test[begin...])
            let newstring = newtest.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
            
            self.nameLabel.text = "Name: " + self.name[num]
            self.dateLabel.text = "Date: " + String(newstring)
            self.bodyTempLabel.text = "Body Temp: "+self.bodyTemp[num] + "°C"
            self.outsideBodyTempLabel.text = "Weather: " + self.weather[num] + "°C"
            let now = abs((self.counter)%10)
            self.pictureNumber.text = String(now+1) + "/10"
           
        }
        //update_fever_bar()
    }
    
    
    func setImage(from url: String) {
        let handlerone = "https://hayatopia.s3.amazonaws.com/"
        let handlertwo = "https://facescolumbia.s3.amazonaws.com/"
        let heatmapURL = handlerone + url + "_HEATMAP.png"
        let faceURL = handlertwo + url + "_cropped.jpg" //CHANGE
        
        guard let heatImageURL = URL(string: heatmapURL) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: heatImageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.heatmapImage.image = image
            }
        }
        
        guard let faceImageURL = URL(string: faceURL) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: faceImageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.faceImage.image = image
            }
        }
    }
    
    @IBAction func rightButton(_ sender: Any) {
        self.counter += 1
        let now = abs((self.counter)%10)
        //update_fever_bar()
        setImage(from: self.pictureName[now])
        pictureNumber.text = String(now+1) + "/10"
        self.setImage(from: self.pictureName[now])
        updateLabel(num: now)
        
    }
    
    @IBAction func leftButton(_ sender: Any) {
        self.counter -= 1
        let now = abs((self.counter)%10)
        //update_fever_bar()
        setImage(from: self.pictureName[now])
        pictureNumber.text = String(now+1) + "/10"
        self.setImage(from: self.pictureName[now])
        updateLabel(num: now)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        if let url = URL(string: "https://hayatopia.s3.amazonaws.com/recent.json") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                     let data = try JSONDecoder().decode(Recents.self, from: data)
                    self.counter = 0
                    self.pictureName = [] as [String]
                    self.bodyTemp = [] as [String]
                    self.weather = [] as [String]
                    self.name = [] as [String]
                    
                    let one = data.one[0]
                    self.pictureName.append(one.pictureName)
                    self.bodyTemp.append(one.mean)
                    self.weather.append(one.weather)
                    self.name.append(one.name.rawValue)
                    
                    let two = data.two[0]
                    self.pictureName.append(two.pictureName)
                    self.bodyTemp.append(two.mean)
                    self.weather.append(two.weather)
                    self.name.append(two.name.rawValue)
                    
                    let three = data.three[0]
                    self.pictureName.append(three.pictureName)
                    self.bodyTemp.append(three.mean)
                    self.weather.append(three.weather)
                    self.name.append(three.name.rawValue)
                    
                    let four = data.four[0]
                    self.pictureName.append(four.pictureName)
                    self.bodyTemp.append(four.mean)
                    self.weather.append(four.weather)
                    self.name.append(four.name.rawValue)
                    
                    let five = data.five[0]
                    self.pictureName.append(five.pictureName)
                    self.bodyTemp.append(five.mean)
                    self.weather.append(five.weather)
                    self.name.append(five.name.rawValue)
                    
                    let six = data.six[0]
                    self.pictureName.append(six.pictureName)
                    self.bodyTemp.append(six.mean)
                    self.weather.append(six.weather)
                    self.name.append(six.name.rawValue)
                    
                    let seven = data.seven[0]
                    self.pictureName.append(seven.pictureName)
                    self.bodyTemp.append(seven.mean)
                    self.weather.append(seven.weather)
                    self.name.append(seven.name.rawValue)
                    
                    let eight = data.eight[0]
                    self.pictureName.append(eight.pictureName)
                    self.bodyTemp.append(eight.mean)
                    self.weather.append(eight.weather)
                    self.name.append(eight.name.rawValue)
                    
                    let nine = data.nine[0]
                    self.pictureName.append(nine.pictureName)
                    self.bodyTemp.append(nine.mean)
                    self.weather.append(nine.weather)
                    self.name.append(nine.name.rawValue)
                    
                    let ten = data.ten[0]
                    self.pictureName.append(ten.pictureName)
                    self.bodyTemp.append(ten.mean)
                    self.weather.append(ten.weather)
                    self.name.append(ten.name.rawValue)
                                        
                    print(self.pictureName)
                    self.setImage(from: self.pictureName[0])
                    self.updateLabel(num: self.counter)
                    //self.update_fever_bar()
                    

                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
    
    
    
    func update_fever_bar() {
        
        let maxTemp = 41.0
        let index = abs((self.counter)%10)
        let currTemp = bodyTemp[index]
        self.feverChart.drawBarShadowEnabled = true
        self.feverChart.drawValueAboveBarEnabled = true
        self.feverChart.maxVisibleCount = Int(maxTemp)
        self.feverChart.rightAxis.axisMaximum = maxTemp
        self.feverChart.leftAxis.axisMaximum = maxTemp
                
        let xAxis  = self.feverChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 10.0
        
        let leftAxis = self.feverChart.leftAxis;
        leftAxis.drawAxisLineEnabled = false;
        leftAxis.drawGridLinesEnabled = true;
        leftAxis.axisMinimum = 35.0; // this replaces startAtZero = YES
        leftAxis.enabled = false
        
        let rightAxis = self.feverChart.rightAxis
        rightAxis.enabled = true;
        rightAxis.drawAxisLineEnabled = false;
        rightAxis.drawGridLinesEnabled = true;
        rightAxis.axisMinimum = 35.0; // this replaces startAtZero = YES
        
        let l = self.feverChart.legend
        l.enabled =  false
        feverChart.fitBars = true;
        self.feverChart.animate(xAxisDuration: 2.5, yAxisDuration: 2.5)
        
        let barWidth = 0.6
        var yVals = [BarChartDataEntry]()
        yVals.append(BarChartDataEntry(x: Double(1.0), y: Double(currTemp)!))
        yVals.append(BarChartDataEntry(x: Double(1.0), y: Double(38.0)))
        
        var set1 : BarChartDataSet!
        set1 = BarChartDataSet(entries: yVals, label: "DataSet")
        set1.colors = [#colorLiteral(red: 1, green: 0, blue: 0.3303074837, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
        var dataSets = [BarChartDataSet]()
        dataSets.append(set1)
        let data = BarChartData(dataSets: dataSets)
        data.barWidth =  barWidth;
        feverChart.data = data
        feverChart.drawValueAboveBarEnabled = true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
