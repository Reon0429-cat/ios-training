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
    private var weatherItems = [WeatherItem]()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshControl()
        displayWeathers()
    }
    
    private func displayWeathers() {
        Task {
            do {
                let weatherItems = try await self.weatherUseCase.fetchWeatherItems()
                self.weatherItems = weatherItems
                tableView.reloadData()
            } catch let error as WeatherFetchError {
                let errorDescription = error.errorDescription ?? ""
                presentErrorAlert(
                    title: "エラーが発生しました。\(errorDescription)"
                )
            } catch {
                presentErrorAlert(
                    title: "予期しないエラーが発生しました。"
                )
            }
        }
    }
    
    @objc private func refreshTable() {
        displayWeathers()
        refreshControl.endRefreshing()
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
    
    private func presentWeatherDisplay(weatherItem: WeatherItem) {
        let viewController = WeatherDisplayViewController.instantiate(
            weatherItem: weatherItem,
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
        let weatherItem = weatherItems[indexPath.row]
        presentWeatherDisplay(weatherItem: weatherItem)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return weatherItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: WeatherTableViewCell.self)
        let weatherItem = weatherItems[indexPath.row]
        cell.configure(with: weatherItem)
        return cell
    }
    
}

extension WeatherListViewController: AlertPresentable { }
