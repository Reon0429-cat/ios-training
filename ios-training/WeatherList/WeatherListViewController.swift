//
//  WeatherListViewController.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/17.
//

import UIKit

final class WeatherListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let weatherUseCase = WeatherUseCase()
    private var weathers = [(weather: Weather, area: String)]()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshControl()
        Task {
            await self.displayWeathers()
        }
    }
    
    private func displayWeathers() async {
        do {
            let weatherItems = try await self.weatherUseCase.fetchWeatherItems()
            weathers.removeAll()
            for weatherItem in weatherItems {
                let weather = (weather: weatherItem.info,
                               area: weatherItem.area)
                weathers.append(weather)
            }
            DispatchQueue.executeMainThread {
                self.tableView.reloadData()
            }
        } catch let error as WeatherFetchError {
            let errorDescription = error.errorDescription ?? ""
            DispatchQueue.executeMainThread {
                self.presentErrorAlert(
                    title: "エラーが発生しました。\(errorDescription)"
                )
            }
        } catch {
            DispatchQueue.executeMainThread {
                self.presentErrorAlert(
                    title: "予期しないエラーが発生しました。"
                )
            }
        }
    }
    
    @objc private func refreshTable() {
        Task {
            await self.displayWeathers()
            DispatchQueue.executeMainThread {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.registerCustomCell(WeatherTableViewCell.self)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(refreshTable),
                                 for: .valueChanged)
    }
    
    private func presentWeatherDisplay(weather: Weather) {
        let viewController = WeatherDisplayViewController.instantiate(
            weather: weather,
            weatherUseCase: WeatherUseCase()
        )
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weather = weathers[indexPath.row].weather
        presentWeatherDisplay(weather: weather)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: WeatherTableViewCell.self)
        let weather = weathers[indexPath.row]
        cell.configure(with: weather)
        return cell
    }
    
}

extension WeatherListViewController: AlertPresentable { }
