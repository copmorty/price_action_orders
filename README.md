# Price Action Orders

[![build](https://github.com/copmorty/price_action_orders/actions/workflows/main.yml/badge.svg)](https://github.com/copmorty/price_action_orders/actions/workflows/main.yml)

A Flutter desktop application for cryptocurrency trading on the Binance exchange, through its API. The app allows to see cryptocurrency prices, spot wallet balances, to create market, limit, and stop-limit orders from the spot account and it also allows to see open orders, order history and trade history. All these features work in real time, according to the user's movements and the operation of the exchange.

![PAO-0 8 1](https://user-images.githubusercontent.com/23016725/130780454-9cfb9d70-99ad-4a58-8d4b-060eccc6cd18.png)


## Getting Started

### Demo Builds
- [Price Action Orders windows-build](https://500c.short.gy/paodw)
- [Price Action Orders macos-build](https://500c.short.gy/paodmos)

### Running the app
The app has two independent modes, Test (test network with fake assets) and Real (production network with your real assets).\
Steps to run the app:
- You can download and use any of the demo builds or you can compile the project with Flutter 3+.
- In order to run it in Test mode you will need an API key and secret from [Binance testnet](https://testnet.binance.vision/).
- In order to run it in Real mode you will need an API key and secret from [Binance](https://www.binancezh.top/en/support/faq/360002502072).
- Once you have one or both combinations of API key-secret, start the app, you will be prompted to enter them when launching the application. From there, you will be able to choose which mode you want to run.

## About the project

This project was built follwoing the clean code architecture in order to be maintainable and testable through time, and without having to worry how big it gets. The project uses Riverpod for dependency injection and state management.


## License

This project is licensed under the [MIT License](https://github.com/copmorty/price_action_orders/blob/master/LICENSE).
